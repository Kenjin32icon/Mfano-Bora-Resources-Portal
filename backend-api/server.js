const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Database Connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/mfano_bora_db',
});

/* ==========================================================================
   PUBLIC API ENDPOINTS (For Developer 4 & 5 Frontend Consumption)
   ========================================================================== */

// GET /api/resources - Fetch all resources with filtering and search
app.get('/api/resources', async (req, res) => {
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
});

// POST /api/resources/:id/download - Track download counts
app.post('/api/resources/:id/download', async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query('UPDATE resources SET download_count = download_count + 1 WHERE id = $1', [id]);
    res.json({ success: true, message: 'Download count incremented' });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Failed to record download' });
  }
});

// GET /api/categories - Fetch hierarchical categories for sidebars and navigation
app.get('/api/categories', async (req, res) => {
  try {
    const categoriesQuery = await pool.query('SELECT * FROM categories ORDER BY id ASC');
    const subCategoriesQuery = await pool.query('SELECT * FROM sub_categories ORDER BY id ASC');

    const categories = categoriesQuery.rows.map(cat => ({
      ...cat,
      subcategories: subCategoriesQuery.rows.filter(sub => sub.category_id === cat.id)
    }));

    res.json({ success: true, data: categories });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Server Error' });
  }
});

/* ==========================================================================
   ADMIN API ENDPOINTS (For Content Population - Devs 7-10 & Admin Panel)
   ========================================================================== */

// POST /api/admin/resources - Create a new resource
app.post('/api/admin/resources', async (req, res) => {
  try {
    const { sub_category_id, title, description, file_url, file_size_kb, is_featured } = req.body;
    
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
});

// PUT /api/admin/resources/:id - Update an existing resource
app.put('/api/admin/resources/:id', async (req, res) => {
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

    const result = await pool.query(query, [sub_category_id, title, description, file_url, is_featured, is_published, id]);
    res.json({ success: true, data: result.rows[0] });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Failed to update resource' });
  }
});

// DELETE /api/admin/resources/:id - Delete a resource
app.delete('/api/admin/resources/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query('DELETE FROM resources WHERE id = $1', [id]);
    res.json({ success: true, message: 'Resource deleted successfully' });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Failed to delete resource' });
  }
});

app.listen(PORT, () => {
  console.log(`Backend Server running on port ${PORT}`);
});
