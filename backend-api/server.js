// backend-api/server.js
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const { requireAdminKey } = require('./middleware/auth');
const resourceRoutes = require('./routes/resourceRoutes');
const categoryRoutes = require('./routes/categoryRoutes');
const adminRoutes = require('./routes/adminRoutes');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Health check (useful for Dev 11's QA pass and deployment checks)
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'Mfano Bora Resources API is running.' });
});

/* ==========================================================================
   PUBLIC API ENDPOINTS (For Developer 4 & 5 Frontend Consumption)
   ========================================================================== */
app.use('/api/resources', resourceRoutes);
app.use('/api/categories', categoryRoutes);

/* ==========================================================================
   ADMIN API ENDPOINTS (For Content Population - Devs 7-10 & Admin Panel)
   Every route below requires the `x-api-key` header to match ADMIN_API_KEY.
   ========================================================================== */
app.use('/api/admin', requireAdminKey, adminRoutes);

// 404 fallback
app.use((req, res) => {
  res.status(404).json({ success: false, error: 'Route not found' });
});

app.listen(PORT, () => {
  console.log(`Backend Server running on port ${PORT}`);
});
