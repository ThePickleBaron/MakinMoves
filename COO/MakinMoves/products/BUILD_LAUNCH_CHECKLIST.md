# Product #2 Build & Launch Checklist

**Product:** Freelancer Invoice + Client Tracker (Notion Template)
**Price:** $39
**Status:** All materials complete — ready to build and launch
**Est. Time to Launch:** 3 hours (2 hr build + 1 hr launch)

---

## PRE-BUILD CHECKLIST (Before Opening Notion)

- [ ] Read `template_spec.md` completely (20 min)
- [ ] Review sample databases in spec (understand the flow)
- [ ] Decide on invoice numbering format (e.g., INV-2025-001)
- [ ] Choose base currency (USD, EUR, etc.)
- [ ] Clear calendar for 2-hour focused work block
- [ ] Test Notion workspace is working (create test page)

---

## BUILD PHASE (2 hours)

### Step 1: Create Databases (30 min)
- [ ] Create "Clients" database with properties:
  - Title, Email, Phone, Website, Address, Payment Terms, Default Rate, Currency, Status, Industry, First Engagement Date, Notes
- [ ] Create "Projects" database with properties:
  - Title, Client (relation), Status, Type, Description, Start Date, End Date, Budget (Total), Hours Budgeted, Invoice(s) (relation), Notes
- [ ] Create "Invoices" database with properties:
  - Title, Client (relation), Project (relation), Invoice Date, Due Date, Amount, Currency, Description, Status, Payment Status, Payment Method, Payment Received Date, Amount Paid, Notes
- [ ] Create "Payments" database with properties:
  - Title, Invoice(s) (relation), Client (relation), Amount, Currency, Payment Date, Payment Method, Received Status, Reference, Notes
- [ ] Create "Reminders" database with properties:
  - Title, Type, Invoice (relation), Client (relation), Reminder Date, Status, Notes, Completed Date

### Step 2: Add Rollups & Formulas (45 min)
**Clients Database:**
- [ ] Total Revenue (rollup: sum of Invoice amounts)
- [ ] Outstanding Balance (rollup: sum of Invoice amounts remaining)
- [ ] Total Projects (rollup: count of projects)

**Projects Database:**
- [ ] Budget Remaining (formula: Budget - Total Invoiced)
- [ ] Hours Logged (rollup: sum of invoice hours)
- [ ] Total Invoiced (rollup: sum of invoice amounts)

**Invoices Database:**
- [ ] Days Outstanding (formula: dateBetween between due date and today)
- [ ] Amount Remaining (formula: Amount - Amount Paid)
- [ ] Payment Status (auto-update based on amount paid)
- [ ] Sent Reminders (rollup: count of reminders)

**Payments Database:**
- [ ] Linked Invoice Total (rollup: sum of linked invoice amounts)
- [ ] Variance (formula: Amount - Linked Invoice Total)

### Step 3: Create Views (45 min)

**Clients Database Views:**
- [ ] Active Clients (table, filtered by Status = Active)
- [ ] By Industry (grouped by Industry)
- [ ] Contact Sheet (table: Name, Email, Phone, Address, Payment Terms)
- [ ] Top Earners (table, sorted by Total Revenue desc)

**Projects Database Views:**
- [ ] Active Projects (table, filtered by Status = Active)
- [ ] By Client (grouped by Client)
- [ ] Timeline (calendar, showing Start Date → End Date)
- [ ] Over Budget (table, filtered by Budget Remaining < 0)
- [ ] Upcoming Deadlines (table, sorted by End Date asc)

**Invoices Database Views:**
- [ ] All Invoices (table, sorted by Invoice Date desc)
- [ ] Unpaid (table, filtered by Payment Status ≠ Paid)
- [ ] Overdue (table, filtered by Days Outstanding > 0)
- [ ] This Month (table, filtered by Invoice Date = current month)
- [ ] By Status (grouped by Payment Status)
- [ ] Payment Timeline (calendar, showing Due Date)
- [ ] Awaiting Payment (kanban, grouped by Payment Status)

**Payments Database Views:**
- [ ] All Payments (table, sorted by Payment Date desc)
- [ ] Recent Payments (table, filtered by Payment Date ≥ last 30 days)
- [ ] By Client (grouped by Client)
- [ ] This Month (table, filtered by Payment Date = current month)
- [ ] Payment Status (grouped by Received Status)
- [ ] Reconciliation (table, showing Variance)

**Reminders Database Views:**
- [ ] Pending Reminders (table, filtered by Status = Pending)
- [ ] By Type (grouped by Type)
- [ ] Overdue Reminders (table, filtered by Status = Pending AND Reminder Date < today)
- [ ] This Week (table, filtered by Reminder Date = this week)

### Step 4: Add Sample Data (15 min)
- [ ] Create 3–5 sample clients (tech, marketing, consulting)
- [ ] Create 3–5 sample projects
- [ ] Create 5–10 sample invoices (mix of paid, unpaid, overdue)
- [ ] Create 3–5 sample payments
- [ ] Create 2–3 sample reminders

### Step 5: Test & Polish (10 min)
- [ ] Verify all relations are working (click and see linked records)
- [ ] Test all formulas (check Days Outstanding, Budget Remaining, etc.)
- [ ] Test all views (apply filters, sorts, groupings)
- [ ] Add colors to Status properties (red=overdue, green=paid, yellow=pending)
- [ ] Add icons to each database
- [ ] Check for any broken formulas or missing links

---

## POST-BUILD CHECKLIST

### Create Deliverable
- [ ] Save the template as a "Duplicate-able" page
- [ ] Export the page as a Notion page (or `.notion` file if available)
- [ ] Test: Duplicate the template into a new workspace to confirm it works
- [ ] Verify all databases, views, formulas work in the duplicate

---

## GUMROAD LAUNCH CHECKLIST (1 hour)

### Account Setup
- [ ] Create Gumroad account (gumroad.com)
- [ ] Set up payment method
- [ ] Complete profile (name, email, bio)

### Product Creation
- [ ] Click "Create a product"
- [ ] Select "File Upload" (for Notion template)
- [ ] Upload the built Notion template

### Listing Details
- [ ] **Title:** Copy from `gumroad_listing.md` → "Freelancer Invoice + Client Tracker — All-in-One Notion Template"
- [ ] **Subtitle:** Copy from listing → "Stop losing track of invoices and clients..."
- [ ] **Description:** Copy full description from `gumroad_listing.md`
- [ ] **Price:** Set to $39
- [ ] **License:** "Creator retains copyright" (default)
- [ ] **Product Type:** "Digital products" or "Templates"

### Customization
- [ ] **Thumbnail:** Create/upload thumbnail image
  - Suggestion: Blue gradient background, white text "Invoice + Client Tracker", dollar sign icon
  - Use Canva (free) if you don't have design software
- [ ] **Tags:** Add "notion, freelance, invoice, template, client-management"
- [ ] **License/Terms:** Add note: "This is a Notion template. You'll receive a link to duplicate it into your Notion workspace."

### Email Automation
- [ ] Configure post-purchase email
- [ ] Include link to `setup_guide.md` (PDF or Google Drive link)
- [ ] Include link to `template_spec.md` (reference documentation)
- [ ] Add support email address
- [ ] Suggest follow-up: "What features would you like in Version 2.0?"

### Publish
- [ ] Review all details one final time
- [ ] Click "Publish"
- [ ] Share Gumroad link on your channels

---

## INITIAL MARKETING CHECKLIST

### Week 1 — Soft Launch
- [ ] **Reddit:**
  - [ ] Post to r/freelance (title: "I built a $39 Notion template to replace Freshbooks")
  - [ ] Post to r/Notion (title: "Freelancer Invoice + Client Tracker — Template for managing invoices and clients")
  - [ ] Post to r/solopreneur (same)
  - [ ] Post to r/slavelabor (optional, if relevant)
  
- [ ] **Twitter/X:**
  - [ ] Tweet: Share link + benefit statement
  - [ ] Include: #Notion #Freelance #InvoiceTemplate #SmallBusiness
  - [ ] Pin tweet for 2 weeks
  
- [ ] **Indie Hackers:**
  - [ ] Post to "Show IH" section with:
    - What: "Built a Notion template for freelancer invoicing"
    - Why: "Lost $8K in invoices; built system to prevent that"
    - Tech: Notion, Gumroad
    - Link to Gumroad

- [ ] **Email:**
  - [ ] Send to existing email list (if you have one)
  - [ ] Subject: "I just launched a Notion invoice tracker for freelancers ($39)"
  - [ ] Include 10% discount code if desired

### Week 2–4 — Momentum
- [ ] Monitor first 5–10 sales for feedback
- [ ] Collect testimonials from early customers
- [ ] Address any support questions
- [ ] Share customer testimonials on social media
- [ ] Post on LinkedIn (if you have a profile)

---

## SUCCESS METRICS (Track These)

### Sales
- [ ] Track units sold per day
- [ ] Track revenue per channel (which source drove the most sales?)
- [ ] Calculate conversion rate (views to purchases)

### Customer Satisfaction
- [ ] Monitor Gumroad star rating (target: 4.5+)
- [ ] Count reviews and testimonials
- [ ] Track refund requests (target: < 5%)
- [ ] Note support questions (to improve docs)

### Growth
- [ ] Track email list growth (if collecting emails)
- [ ] Track social media followers
- [ ] Identify top marketing channels for Month 2

---

## MONTH 1 GOALS

- [ ] 20+ units sold
- [ ] $780+ revenue
- [ ] 4.5+ star rating (with 5+ reviews)
- [ ] < 5% refund rate
- [ ] 10+ customer testimonials collected
- [ ] < 5 support issues (setup guide should handle most)

---

## IF YOU GET STUCK

### Template Building Issues
- **Missing properties:** Check `template_spec.md` for exact property names and types
- **Formula errors:** Copy formula directly from spec
- **View not working:** Verify all databases are created and linked before creating views
- **Notion general help:** Search notion.so/help or check Notion support forums

### Gumroad Issues
- **Upload failing:** Try a different format or smaller file size
- **Payment not working:** Verify payment method is added to account
- **Listing not showing:** Check that product is "Published" (not Draft)

### Marketing Issues
- **No sales first week:** This is normal — expect 5–20 in Week 1, acceleration Week 2–3
- **Negative feedback:** Read carefully, address in setup guide, plan improvements
- **Support overwhelm:** Prioritize answering customer emails; use setup guide to redirect to self-service

---

## NEXT PHASE: UPSELLS (After 50+ units sold)

Once Product #2 is stable, launch:

1. **Time Tracking Add-on** ($15)
   - Database to log hours daily
   - Auto-link to invoices
   - Time-estimate vs. actual tracking

2. **Expense Tracker Add-on** ($12)
   - Track project costs
   - Calculate project profit
   - Tax expense categorization

3. **Contract & SOW Template** ($25)
   - Store signed contracts
   - Track contract terms
   - Link to projects

**Target:** 20% adoption of upsells = +$2–3K in Month 2–3

---

## FINAL CHECKLIST

- [ ] Read full `template_spec.md`
- [ ] Build template (2 hours)
- [ ] Test template (30 min)
- [ ] Create Gumroad account
- [ ] Upload template to Gumroad
- [ ] Copy listing from `gumroad_listing.md`
- [ ] Create thumbnail
- [ ] Set up email automation
- [ ] Publish product
- [ ] Post to Reddit (3 subreddits)
- [ ] Post to Twitter
- [ ] Post to Indie Hackers
- [ ] Monitor first sales and feedback
- [ ] Collect testimonials
- [ ] Plan Month 2 marketing and upsells

**Total Time:** ~3–4 hours for build and launch. Marketing is ongoing.

**Status:** READY TO GO

