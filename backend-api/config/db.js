// backend-api/config/db.js
// Single shared Postgres connection pool. Every controller imports this
// instead of creating its own pool, so we don't leak connections.

const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  connectionString:
    process.env.DATABASE_URL ||
    'postgresql://postgres:postgres@localhost:5432/mfano_bora_db',
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle Postgres client', err);
});

module.exports = pool;
