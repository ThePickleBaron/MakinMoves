# Database Setup Requirements for Real-Time Financial Tracking
**CFO:** Grounded
**CTMO dependency:** n8n Phase 1 + PostgreSQL
**Deadline:** March 30, 2026 (before autonomous operation)

---

## Essential Tables (PostgreSQL)

### 1. `public.revenue_summary` (Real-time tracking)
```
- id (UUID)
- timestamp (when revenue posted)
- stream (Digital Products, PoD, Affiliate)
- platform (Gumroad, Redbubble, WordPress, etc.)
- transaction_id (external ref)
- gross_amount (before fees)
- net_amount (after platform commission)
- currency (USD)
- status (complete, pending, refunded)
```

### 2. `digital_products.sales` (Gumroad transactions)
```
- id (UUID)
- product_id (template name)
- quantity (units sold)
- gross_sale ($25–45)
- gumroad_fee (10%)
- net_sale (90%)
- sale_timestamp
- customer_country
```

### 3. `pod.sales` (Redbubble transactions)
```
- id (UUID)
- design_id (sticker/product)
- quantity
- unit_price
- redbubble_commission (60% user, 40% Redbubble)
- net_to_makinmoves (our 40%)
- sale_timestamp
- product_type (sticker, t-shirt, etc.)
```

### 4. `affiliate.clicks_and_revenue` (WordPress blog tracking)
```
- id (UUID)
- affiliate_platform (Amazon, Gumroad partners, etc.)
- article_id (blog post)
- click_timestamp
- click_source (UTM params)
- conversion_amount (if sale)
- commission_rate (30–50%)
- status (clicked, converted, not_converted)
```

### 5. `public.recovery_tracker` (Goal progress)
```
- id (UUID)
- target_amount ($10,000)
- recovered_amount (SUM of all net revenue)
- recovery_percent (recovered / target)
- days_elapsed
- projected_completion_date
- last_updated
```

### 6. `costs.monthly_fixed` (Burn rate tracking)
```
- id (UUID)
- month (2026-03, 2026-04, etc.)
- hosting ($25)
- email_platform ($15)
- tools ($0–50)
- other
- total_fixed_cost
```

---

## Real-Time Queries CFO Will Run

**Daily (Morning standup):**
```sql
-- Yesterday's revenue by stream
SELECT stream, SUM(net_amount) as daily_revenue
FROM public.revenue_summary
WHERE DATE(timestamp) = CURRENT_DATE - 1
GROUP BY stream;

-- Recovery progress
SELECT recovered_amount, target_amount, ROUND(100.0 * recovered_amount / target_amount, 1) as pct_complete
FROM public.recovery_tracker
ORDER BY last_updated DESC LIMIT 1;
```

**Weekly (Monday financial report):**
```sql
-- Week-over-week revenue
SELECT stream, SUM(net_amount) as week_revenue
FROM public.revenue_summary
WHERE timestamp >= CURRENT_DATE - 7
GROUP BY stream;

-- Conversion rates
SELECT COUNT(DISTINCT customer_id) as unique_buyers, SUM(gross_amount) as revenue, COUNT(*) as transactions
FROM digital_products.sales
WHERE sale_timestamp >= CURRENT_DATE - 7;
```

**Monthly (Recovery status):**
```sql
-- Cumulative progress toward $10k
SELECT
  (SELECT SUM(net_amount) FROM public.revenue_summary) as total_revenue,
  (SELECT target_amount FROM public.recovery_tracker ORDER BY last_updated DESC LIMIT 1) as recovery_goal,
  ROUND(100.0 * (SELECT SUM(net_amount) FROM public.revenue_summary) / 10000, 1) as pct_to_goal;
```

---

## CTMO Confirmation Needed (by 6:58 PM)

- [ ] PostgreSQL database provisioned and accessible to CFO instance
- [ ] Table schemas created (at minimum: `revenue_summary`, `digital_products.sales`, `recovery_tracker`)
- [ ] n8n workflow configured to push transactions to PostgreSQL within 5 minutes of sale
- [ ] CFO has query access (SELECT only, no DROP/ALTER)
- [ ] Test transaction verified (can CFO query test data?)
- [ ] Daily sync confirmed (n8n running continuously, no manual refresh needed)

---

## Timeline Impact

**If DB is ready by March 30:** CFO can track real-time revenue hourly starting April 1
**If DB is delayed to March 31:** CFO can only do EOD batch reporting (1-day lag)
**If DB not ready by April 4:** Escalate immediately—cannot validate $70 revenue checkpoint

---

**CFO Status:** Financial model and tracking framework ready. Waiting on CTMO infrastructure.

**Agents running:** Cost modeling agent is stress-testing these queries (6:30–7:00 PM)
