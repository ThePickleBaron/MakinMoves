/**
 * Micro-SaaS Starter Template
 * A minimal but complete Express app structure for building
 * small subscription-based tools (calculators, converters, dashboards, APIs).
 *
 * Revenue model: Free tier + paid tier ($9-29/mo)
 * Stack: Express + PostgreSQL + Stripe (add when ready)
 */

const express = require("express");
const { Pool } = require("pg");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", "..", ".env") });

const app = express();
const PORT = process.env.SAAS_PORT || 3001;

app.use(express.json());
app.use(express.static(path.join(__dirname, "public")));

const pool = new Pool({
  host: "localhost",
  port: 5432,
  database: "makinmoves",
  user: "makinmoves",
  password: process.env.POSTGRES_PASSWORD || "changeme123",
});

// ── Simple API Key Auth Middleware ─────────────────────
function authMiddleware(req, res, next) {
  const apiKey = req.headers["x-api-key"];
  if (!apiKey) {
    return res.status(401).json({ error: "API key required" });
  }
  // TODO: Validate against database
  req.userId = apiKey; // Placeholder
  next();
}

// ── Public Routes ─────────────────────────────────────
app.get("/", (req, res) => {
  res.json({
    name: "Your Micro-SaaS",
    version: "1.0.0",
    docs: "/api/docs",
    status: "running",
  });
});

// Free tier: Limited usage
app.get("/api/free/:input", (req, res) => {
  // Replace with your tool's logic
  const result = {
    input: req.params.input,
    output: `Processed: ${req.params.input}`,
    tier: "free",
    limit: "10 requests/day",
  };
  res.json(result);
});

// ── Paid API Routes ───────────────────────────────────
app.get("/api/v1/process", authMiddleware, (req, res) => {
  // Replace with your premium tool logic
  res.json({
    input: req.query.input,
    output: `Premium result for: ${req.query.input}`,
    tier: "pro",
  });
});

// ── User Management ───────────────────────────────────
app.post("/api/signup", async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ error: "Email required" });

  // Generate simple API key
  const apiKey = require("crypto").randomUUID();

  try {
    await pool.query(
      `INSERT INTO saas.subscribers (project_id, plan, mrr, status)
       VALUES (1, 'free', 0, 'active')`
    );
    res.json({ email, api_key: apiKey, plan: "free" });
  } catch (err) {
    res.status(500).json({ error: "Signup failed" });
  }
});

// ── Usage Tracking ────────────────────────────────────
app.get("/api/usage", authMiddleware, (req, res) => {
  res.json({
    userId: req.userId,
    requests_today: 0,
    limit: 100,
    plan: "free",
    upgrade_url: "/pricing",
  });
});

// ── Health Check ──────────────────────────────────────
app.get("/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.json({ status: "healthy", db: "connected" });
  } catch {
    res.status(503).json({ status: "unhealthy", db: "disconnected" });
  }
});

if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Micro-SaaS running at http://localhost:${PORT}`);
    console.log("\nIdeas for micro-SaaS tools:");
    console.log("  - Text/image converter or optimizer");
    console.log("  - SEO analyzer or keyword checker");
    console.log("  - Invoice/receipt generator");
    console.log("  - QR code generator with analytics");
    console.log("  - Color palette / design tool");
    console.log("  - Webhook relay / notification service");
    console.log("  - API monitoring / uptime checker");
  });
}

module.exports = app;
