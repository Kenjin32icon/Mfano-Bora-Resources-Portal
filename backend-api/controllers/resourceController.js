// backend-api/controllers/resourceController.js
const pool = require('../config/db');

/* ---------------------------- PUBLIC ---------------------------- */

// GET /api/resources - Fetch all resources with filtering and search
async function getResources(req, res) {
  try {
    const { category, subcategory, search, featured } = req.query;

    let query = `
      SELECT r.id, r.title, r.description, r.file_url, r.file_size_kb,
             r.download_count, r.is_featured, r.publish_date,
             sc.name AS sub_category_name, sc.slug AS sub_category_slug,
             c.name AS category_name, c.slug AS category_slug
      FROM resources r
      JOIN sub_categories sc ON r.sub_category_id = sc.id
      JOIN categories c ON sc.category_id = c.id
      WHERE r.is_published = TRUE
    `;

    const queryParams = [];

    if (category) {
      queryParams.push(category);
      query += ` AND c.slug = $${queryParams.length}`;
    }

    if (subcategory) {
      queryParams.push(subcategory);
      query += ` AND sc.slug = $${queryParams.length}`;
    }

    if (featured) {
      query += ` AND r.is_featured = TRUE`;
    }

    if (search) {
      queryParams.push(`%${search}%`);
      query += ` AND (r.title ILIKE $${queryParams.length} OR r.description ILIKE $${queryParams.length})`;
    }

    query += ` ORDER BY r.publish_date DESC`;

    const result = await pool.query(query, queryParams);
    res.json({ success: true, count: result.rows.length, data: result.rows });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
}

// GET /api/resources/:id - Fetch a single resource (used by Dev 5's detail view)
async function getResourceById(req, res) {
  try {
    const { id } = req.params;
    const result = await pool.query(
      `SELECT r.*, sc.name AS sub_category_name, c.name AS category_name
       FROM resources r
       JOIN sub_categories sc ON r.sub_category_id = sc.id
       JOIN categories c ON sc.category_id = c.id
       WHERE r.id = $1 AND r.is_published = TRUE`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Resource not found' });
    }

    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
}

// POST /api/resources/:id/download - Track download counts
async function trackDownload(req, res) {
  try {
    const { id } = req.params;
    const result = await pool.query(
      'UPDATE resources SET download_count = download_count + 1 WHERE id = $1 RETURNING download_count',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Resource not found' });
    }

    res.json({ success: true, download_count: result.rows[0].download_count });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to record download' });
  }
}

/* ----------------------------- ADMIN ----------------------------- */

// POST /api/admin/resources - Create a new resource
async function createResource(req, res) {
  try {
    const { sub_category_id, title, description, file_url, file_size_kb, is_featured } = req.body;

    if (!sub_category_id || !title || !description || !file_url) {
      return res.status(400).json({
        success: false,
        error: 'sub_category_id, title, description, and file_url are required.',
      });
    }

    const query = `
      INSERT INTO resources (sub_category_id, title, description, file_url, file_size_kb, is_featured)
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
    `;

    const values = [sub_category_id, title, description, file_url, file_size_kb || 0, is_featured || false];
    const result = await pool.query(query, values);

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to create resource' });
  }
}

// PUT /api/admin/resources/:id - Update an existing resource
async function updateResource(req, res) {
  try {
    const { id } = req.params;
    const { sub_category_id, title, description, file_url, is_featured, is_published } = req.body;

    const query = `
      UPDATE resources
      SET sub_category_id = $1, title = $2, description = $3, file_url = $4,
          is_featured = $5, is_published = $6, updated_at = CURRENT_TIMESTAMP
      WHERE id = $7
      RETURNING *
    `;

    const result = await pool.query(query, [
      sub_category_id,
      title,
      description,
      file_url,
      is_featured,
      is_published,
      id,
    ]);

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Resource not found' });
    }

    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to update resource' });
  }
}

// DELETE /api/admin/resources/:id - Delete a resource
async function deleteResource(req, res) {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM resources WHERE id = $1 RETURNING id', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, error: 'Resource not found' });
    }

    res.json({ success: true, message: 'Resource deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Failed to delete resource' });
  }
}

module.exports = {
  getResources,
  getResourceById,
  trackDownload,
  createResource,
  updateResource,
  deleteResource,
};
