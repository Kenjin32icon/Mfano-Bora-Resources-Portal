// backend-api/middleware/auth.js
//
// Minimal admin protection for Task 15 (Security & Privacy).
// The admin dashboard sends a shared secret in the `x-api-key` header.
// This is intentionally simple (fits an 11-person, 10-day attachment
// project) — for a production rollout you'd swap this for per-user
// JWT/session auth, but this stops the "anyone with the URL can delete
// the database" problem right now.

function requireAdminKey(req, res, next) {
  const providedKey = req.header('x-api-key');
  const expectedKey = process.env.ADMIN_API_KEY;

  if (!expectedKey) {
    console.error('ADMIN_API_KEY is not set in the environment.');
    return res
      .status(500)
      .json({ success: false, error: 'Server misconfiguration: admin key not set.' });
  }

  if (!providedKey || providedKey !== expectedKey) {
    return res.status(401).json({ success: false, error: 'Unauthorized: invalid or missing API key.' });
  }

  next();
}

module.exports = { requireAdminKey };
