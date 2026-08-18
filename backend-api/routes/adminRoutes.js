// backend-api/routes/adminRoutes.js
//
// Every route in this file is mounted behind requireAdminKey in server.js.
// This is where the Admin Panel (KnowledgeBaseEditor.js) talks to the API.

const express = require('express');
const router = express.Router();

const {
  createResource,
  updateResource,
  deleteResource,
} = require('../controllers/resourceController');

const { createCategory, createSubCategory } = require('../controllers/categoryController');

// Resources
router.post('/resources', createResource);
router.put('/resources/:id', updateResource);
router.delete('/resources/:id', deleteResource);

// Categories & Sub-Categories
router.post('/categories', createCategory);
router.post('/subcategories', createSubCategory);

module.exports = router;
