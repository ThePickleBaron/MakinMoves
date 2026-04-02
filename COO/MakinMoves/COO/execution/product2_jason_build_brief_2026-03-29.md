# Product #2 — Notion Template Build Brief for Jason

> **Filed by:** COO — 2026-03-29 17:37
> **Purpose:** Action brief for Jason to build the actual Notion template (30–90 min hands-on)
> **Pipeline Stage:** 🧪 PROTOTYPE — All docs ready. Build is the final step before LAUNCH READY.

---

## What You Need to Build

The Notion template "Freelancer Invoice + Client Tracker" needs to be built inside your actual Notion account. The AI team has prepared every specification — your job is to execute the build using these specs.

**Estimated time:** 60–90 minutes

---

## Files You'll Use

All files are in `/products/notion_template_freelancer/`:

| File | What It's For | When to Use |
|------|--------------|-------------|
| `template_spec.md` | Complete blueprint — all databases, properties, formulas, views | Open this and follow it step-by-step while building |
| `setup_guide.md` | Buyer-facing setup instructions (512 lines) | Review after build to make sure what you built matches what the guide describes |
| `gumroad_listing.md` | Full Gumroad product page copy | Use when you go to list the product |
| `README.md` | Product overview and launch checklist | Reference for positioning and projections |

---

## Step-by-Step Build Order

### Phase 1: Create the Notion Page (5 min)
1. Open Notion → Create a new page in your workspace
2. Title it: **"Freelancer Business OS — Template [DEMO]"**
3. This will be your template workspace

### Phase 2: Build the 4 Core Databases (45–60 min)

Build in this order (relations flow from bottom up):

**Database 1: Clients** (~10 min)
- Add all properties from `template_spec.md` → "Database Architecture → 1. Clients Database"
- Key formulas to add: `Total Revenue` (rollup), `Outstanding Balance` (rollup), `Total Projects` (rollup)
- Add 2–3 sample client entries with realistic data

**Database 2: Projects** (~10 min)
- Add all properties from spec
- Create relation: Projects → Clients database
- Add sample entries linking to your sample clients

**Database 3: Invoices** (~10 min)
- Add all properties from spec
- Create relations: Invoices → Clients, Invoices → Projects
- Key formula: `Days Overdue` — use `dateBetween(now(), prop("Due Date"), "days")` with condition
- Add sample invoices including 1 overdue one (to test formula)

**Database 4: Activity Log** (~5 min)
- Simpler — just track client touchpoints
- Create relation: Activity Log → Clients, Activity Log → Projects

### Phase 3: Build Views (10–15 min)

For each database, add the views from spec:
- Active Clients view (filter: Client Status = Active)
- Outstanding Invoices view (filter: Invoice Status ≠ Paid)
- Revenue Dashboard (grouped/sorted by month)
- Overdue tracker (filter: Days Overdue > 0, sort desc)

### Phase 4: Build the Start Here Page (10 min)
Create a main dashboard page that links to all 4 databases with:
1. Quick stats callout (total revenue, outstanding, active clients)
2. Links to each database view
3. "Quick start" section pointing to the 5-step onboarding in setup_guide.md

### Phase 5: Test & Verify (15 min)
- [ ] Add 3 complete clients with realistic data
- [ ] Add 5 invoices (2 paid, 1 pending, 1 overdue, 1 sent)
- [ ] Add 3 projects across different clients
- [ ] Confirm `Days Overdue` formula fires on overdue invoice
- [ ] Confirm `Outstanding Balance` rollup adds up correctly
- [ ] Confirm `Total Revenue` rollup shows correct total
- [ ] Navigate through all views — confirm filters work
- [ ] Follow setup_guide.md Step 1 as if you're a new buyer — does it make sense?

### Phase 6: Create Template Link (5 min)
1. Go to the top-level template page
2. Click Share → Publish to web → Enable "Allow duplicate as template"
3. Copy the template link
4. Save the link — this is what you'll deliver to Gumroad buyers

---

## Known Formula Notes (From CTMO Review)

- Use `dateBetween(now(), prop("Due Date"), "days")` for Days Overdue
- Notion's formula editor uses `prop()` syntax (post-2023 update)
- Rollups require the relation to be set up first — build Clients before linking Projects
- If a formula shows an error, check property types match (number fields for rollup math)

---

## After You Build

1. Copy the "Duplicate this template" link from Notion
2. Create a simple PDF (or use the existing `setup_guide.md`) that includes:
   - The template link at the top
   - The setup steps (copy from setup_guide.md)
3. Upload that PDF to Gumroad as the product file
4. Use `gumroad_listing.md` for all listing copy

---

## Revenue Context

This product is projected at $29–39 per sale. With 20–30 sales in Month 1:
- Conservative: $580–$780
- Moderate: $975–$1,170

Combined with Product #1 (launching immediately), the board's 60-day target of $3,000/month is achievable with both products live and actively promoted.

---

*Once you've built and tested the template, file a quick note in `COO/inbox/` with the template URL and confirmation, and the team will advance Product #2 to LAUNCH READY.*
