/**
 * MakinMoves Revenue Dashboard
 * Simple Express server showing revenue across all income streams.
 * Run: node tools/dashboard.js  ->  http://localhost:3000
 */

const express = require("express");
const { Pool } = require("pg");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env") });

const app = express();
const PORT = process.env.DASHBOARD_PORT || 3000;

const pool = new Pool({
  host: "localhost",
  port: 5432,
  database: "makinmoves",
  user: "makinmoves",
  password: process.env.POSTGRES_PASSWORD || "changeme123",
});

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.get("/", async (req, res) => {
  try {
    // Revenue summary
    const revenue = await pool.query(`
      SELECT stream, SUM(amount) as total, COUNT(*) as entries
      FROM revenue_summary
      GROUP BY stream
      ORDER BY total DESC
    `);

    // Recovery progress
    const recovery = await pool.query(`
      SELECT * FROM recovery_tracker ORDER BY id DESC LIMIT 1
    `);

    // Recent activity
    const recentSales = await pool.query(`
      SELECT p.name, s.amount, s.net_amount, s.sale_date
      FROM digital_products.sales s
      JOIN digital_products.products p ON s.product_id = p.id
      ORDER BY s.sale_date DESC LIMIT 10
    `);

    const totalRevenue = revenue.rows.reduce(
      (sum, r) => sum + parseFloat(r.total || 0),
      0
    );

    res.render("dashboard", {
      revenue: revenue.rows,
      recovery: recovery.rows[0] || {
        target_amount: 0,
        recovered_amount: 0,
      },
      recentSales: recentSales.rows,
      totalRevenue,
    });
  } catch (err) {
    res.send(`
      <h1>MakinMoves Dashboard</h1>
      <p>Database not ready yet. Start Docker first:</p>
      <pre>docker compose up -d</pre>
      <p>Error: ${err.message}</p>
    `);
  }
});

// API endpoint for programmatic access
app.get("/api/revenue", async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT stream, source, amount, period, notes
      FROM revenue_summary
      ORDER BY period DESC
    `);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get("/api/recovery", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT * FROM recovery_tracker ORDER BY id DESC LIMIT 1"
    );
    res.json(result.rows[0] || { target_amount: 0, recovered_amount: 0 });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`MakinMoves Dashboard running at http://localhost:${PORT}`);
});
