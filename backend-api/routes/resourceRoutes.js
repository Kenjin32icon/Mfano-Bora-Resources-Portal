// backend-api/routes/resourceRoutes.js
const express = require('express');
const router = express.Router();
const {
  getResources,
  getResourceById,
  trackDownload,
} = require('../controllers/resourceController');

router.get('/', getResources);
router.get('/:id', getResourceById);
router.post('/:id/download', trackDownload);

module.exports = router;
