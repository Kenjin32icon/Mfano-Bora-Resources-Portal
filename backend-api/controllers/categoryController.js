// backend-api/controllers/categoryController.js
const pool = require('../config/db');

/* ---------------------------- PUBLIC ---------------------------- */

// GET /api/categories - Fetch hierarchical categories for sidebars and navigation
async function getCategories(req, res) {
  try {
    const categoriesQuery = await pool.query('SELECT * FROM categories ORDER BY id ASC');
    const subCategoriesQuery = await pool.query('SELECT * FROM sub_categories ORDER BY id ASC');

    const categories = categoriesQuery.rows.map((cat) => ({
      ...cat,
      subcategories: subCategoriesQuery.rows.filter((sub) => sub.category_id === cat.id),
    }));

    res.json({ success: true, data: categories });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, error: 'Server Error' });
  }
}

/* ----------------------------- ADMIN ----------------------------- */

// POST /api/admin/categories - Create a new top-level category
async function createCategory(req, res) {
  try {
    const { name, slug, description } = req.body;

    if (!name || !slug) {
      return res.status(400).json({ success: false, error: 'name and slug are required.' });
    }

    const result = await pool.query(
      `INSERT INTO categories (name, slug, description) VALUES ($1, $2, $3) RETURNING *`,
      [name, slug, description || null]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    console.error(err);
    if (err.code === '23505') {
      return res.status(409).json({ success: false, error: 'A category with that name or slug already exists.' });
    }
    res.status(500).json({ success: false, error: 'Failed to create category' });
  }
}

// POST /api/admin/subcategories - Create a new sub-category under a category
async function createSubCategory(req, res) {
  try {
    const { category_id, name, slug, description } = req.body;

    if (!category_id || !name || !slug) {
      return res.status(400).json({ success: false, error: 'category_id, name and slug are required.' });
    }

    const result = await pool.query(
      `INSERT INTO sub_categories (category_id, name, slug, description) VALUES ($1, $2, $3, $4) RETURNING *`,
      [category_id, name, slug, description || null]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (err) {
    console.error(err);
    if (err.code === '23505') {
      return res.status(409).json({ success: false, error: 'A sub-category with that slug already exists.' });
    }
    res.status(500).json({ success: false, error: 'Failed to create sub-category' });
  }
}

module.exports = { getCategories, createCategory, createSubCategory };
