# Freelancer Invoice + Client Tracker — Complete Notion Template Specification

**Version:** 1.0
**Last Updated:** 2026-03-29
**Scope:** Comprehensive template for freelancers managing clients, projects, invoices, and revenue

---

## Overview

This Notion template is a complete system for freelancers to:
- Track all clients and their information (contact, payment terms, rates)
- Manage projects from proposal to completion
- Generate and track invoices
- Monitor payments received vs. outstanding
- Visualize monthly revenue with dashboards and filtered views
- Ensure nothing slips through the cracks

**Core Databases:** 5
**Supporting Views:** 18+
**Key Features:** Relations, rollups, formulas, timeline views, filtered dashboards

---

## Database Architecture

### 1. Clients Database

**Purpose:** Master list of all clients with contact and payment information.

**Properties:**

| Property Name | Type | Description | Example |
|--------------|------|-------------|---------|
| Client Name | Title | Client company or individual name | Acme Corp |
| Email | Email | Primary contact email | contact@acme.com |
| Phone | Phone Number | Client phone number | (555) 123-4567 |
| Website | URL | Client company website | https://acme.com |
| Address | Rich Text | Full mailing address | 123 Main St, Boston, MA 02101 |
| Payment Terms | Select | Net 15, Net 30, Net 45, Upon Invoice, Upon Completion | Net 30 |
| Default Rate (Hourly) | Number | Default hourly rate for this client | 150 |
| Currency | Select | USD, EUR, GBP, CAD, AUD | USD |
| Client Status | Select | Active, Inactive, Paused, Prospect | Active |
| Industry | Multi-select | Clients industry tags (Tech, Marketing, Legal, etc.) | Tech, SaaS |
| First Engagement Date | Date | When you started working with this client | 2024-09-15 |
| Notes | Rich Text | Any important notes about the client relationship | Prefers invoices on 1st of month; uses Quickbooks |
| Total Revenue | Rollup | Sum of all invoice amounts from this client | $12,450 |
| Outstanding Balance | Rollup | Sum of all unpaid invoices from this client | $2,500 |
| Total Projects | Rollup | Count of projects for this client | 5 |
| Projects | Relation | Links to Projects database | [Project 1, Project 2...] |
| Invoices | Relation | Links to all invoices for this client | [Invoice 1, Invoice 2...] |

**Views:**

- **Active Clients** (Table, filtered by Client Status = Active)
- **By Industry** (Grouped table, grouped by Industry)
- **Client Contact Sheet** (Table with Email, Phone, Address, Payment Terms)
- **Top Earners** (Table, sorted by Total Revenue descending)

---

### 2. Projects Database

**Purpose:** Track project scope, timeline, budget, and deliverables.

**Properties:**

| Property Name | Type | Description | Example |
|--------------|------|-------------|---------|
| Project Name | Title | Descriptive project title | Website Redesign Q2 |
| Client | Relation | Link to Clients database | Acme Corp |
| Project Status | Select | Proposal, Active, On Hold, Completed, Cancelled | Active |
| Project Type | Select | Web Development, Consulting, Design, Writing, Other | Web Development |
| Description | Rich Text | Project overview and scope | Complete redesign of public-facing website; mobile-first; SEO optimization |
| Start Date | Date | Project start or expected start | 2025-01-15 |
| End Date | Date | Project end or expected end | 2025-03-15 |
| Budget (Total) | Number | Total project budget in dollars | 8,500 |
| Budget (Remaining) | Formula | Budget - Sum of invoiced amounts | =prop("Budget (Total)") - prop("Total Invoiced") |
| Hours Budgeted | Number | Total estimated hours for project | 120 |
| Hours Logged | Rollup | Sum of hours across all invoices for this project | 95 |
| Invoice(s) | Relation | All invoices tied to this project | [Invoice 1, Invoice 2...] |
| Total Invoiced | Rollup | Sum of all invoice amounts for this project | $7,200 |
| Project Manager / Lead | Text | Who owns this project internally | Jane Smith |
| URL / Reference | URL | Link to project files, design files, repo, etc. | https://github.com/acme/website-redesign |
| Notes | Rich Text | Key milestones, deliverables, blockers | Waiting on brand guidelines from client |

**Views:**

- **Active Projects** (Table, filtered by Project Status = Active)
- **By Client** (Grouped table, grouped by Client)
- **Timeline** (Calendar view, showing Start Date to End Date)
- **Over Budget** (Table, filtered by Budget (Remaining) < 0)
- **Upcoming Deadlines** (Table, sorted by End Date ascending)

---

### 3. Invoices Database

**Purpose:** Central hub for all invoices — track creation, amounts, payment status.

**Properties:**

| Property Name | Type | Description | Example |
|--------------|------|-------------|---------|
| Invoice # | Title | Unique invoice number (can be auto-formatted) | INV-2025-001 |
| Client | Relation | Link to Clients database | Acme Corp |
| Project | Relation | Link to Projects database (optional; billable support may not tie to project) | Website Redesign Q2 |
| Invoice Date | Date | Date invoice was issued | 2025-02-15 |
| Due Date | Date | Payment due date | 2025-03-17 |
| Amount | Number | Total invoice amount in currency specified | 2,500 |
| Currency | Select | USD, EUR, GBP, CAD, AUD | USD |
| Description | Rich Text | Line items and description of work/deliverables | - Web Development: 40 hours @ $150/hr = $6,000; - Design Review: 10 hours @ $150/hr = $1,500 |
| Status | Select | Draft, Sent, Viewed, Partially Paid, Paid, Overdue, Cancelled | Sent |
| Payment Status | Select | Unpaid, Partially Paid, Paid | Unpaid |
| Payment Method | Select | Bank Transfer, Credit Card, Check, PayPal, Cash, Other | Bank Transfer |
| Payment Received Date | Date | Date payment was received (leave blank if unpaid) | 2025-03-10 |
| Days Outstanding | Formula | Days between today and Due Date; shows negative if overdue | =dateBetween(now(), prop("Due Date"), "days") |
| Amount Paid | Number | Amount actually paid (may differ from Amount if partial) | 0 |
| Amount Remaining | Formula | Amount - Amount Paid | =prop("Amount") - prop("Amount Paid") |
| Notes | Rich Text | Internal notes; follow-up reminders; payment info received | Client requested 2 invoices for accounting purposes; split across Feb and Mar |
| Sent Reminders | Rollup | Count of payment reminders sent (via Reminders database) | 0 |

**Views:**

- **All Invoices** (Table, sorted by Invoice Date descending)
- **Unpaid** (Table, filtered by Payment Status ≠ Paid, sorted by Due Date ascending)
- **Overdue** (Table, filtered by Days Outstanding > 0, sorted by Days Outstanding descending)
- **This Month** (Table, filtered by Invoice Date = current month)
- **By Status** (Grouped table, grouped by Status)
- **Payment Timeline** (Calendar, showing Due Date)
- **Awaiting Payment** (Kanban, grouped by Payment Status: Unpaid → Partially Paid → Paid)

---

### 4. Payments Tracker Database

**Purpose:** Log every payment received; reconcile against invoices.

**Properties:**

| Property Name | Type | Description | Example |
|--------------|------|-------------|---------|
| Payment ID | Title | Unique identifier or reference | PAY-2025-089 |
| Invoice(s) | Relation | One or more invoices this payment applies to | [INV-2025-001] |
| Client | Relation | Link to Clients database | Acme Corp |
| Amount | Number | Payment amount received | 2,500 |
| Currency | Select | USD, EUR, GBP, CAD, AUD | USD |
| Payment Date | Date | Date payment was received / cleared | 2025-03-10 |
| Payment Method | Select | Bank Transfer, Credit Card, Check, PayPal, Cash, Other | Bank Transfer |
| Received Status | Select | Pending, Received, Cleared, Disputed | Cleared |
| Reference / Confirmation | Text | Payment reference, check number, transaction ID, etc. | TXN-2589471 |
| Notes | Rich Text | Any notes about this payment (delayed, partial, dispute reason, etc.) | On time; received via wire transfer |
| Linked Invoice Total | Rollup | Sum of amounts from linked invoices (for reconciliation) | $2,500 |
| Variance | Formula | Amount - Linked Invoice Total (should be 0) | =prop("Amount") - prop("Linked Invoice Total") |

**Views:**

- **All Payments** (Table, sorted by Payment Date descending)
- **Recent Payments** (Table, filtered by Payment Date ≥ last 30 days)
- **By Client** (Grouped table, grouped by Client)
- **This Month** (Table, filtered by Payment Date = current month)
- **Payment Status** (Grouped table, grouped by Received Status)
- **Reconciliation View** (Table with Invoice links and Variance visible; filter Variance ≠ 0)

---

### 5. Reminders / Follow-ups Database

**Purpose:** Track payment reminders, follow-ups, and action items tied to clients/invoices.

**Properties:**

| Property Name | Type | Description | Example |
|--------------|------|-------------|---------|
| Reminder | Title | Description of reminder/follow-up | Payment reminder for INV-2025-001 |
| Type | Select | Payment Reminder, Client Check-in, Proposal Follow-up, Deliverable Reminder, Other | Payment Reminder |
| Invoice | Relation | Link to Invoices (for payment reminders) | INV-2025-001 |
| Client | Relation | Link to Clients | Acme Corp |
| Reminder Date | Date | When the reminder should fire | 2025-03-17 |
| Status | Select | Pending, Sent, Completed, Snoozed, Cancelled | Pending |
| Notes | Rich Text | Details about the follow-up | Send polite payment reminder; include payment instructions |
| Completed Date | Date | When the reminder was addressed | 2025-03-18 |

**Views:**

- **Pending Reminders** (Table, filtered by Status = Pending, sorted by Reminder Date ascending)
- **By Type** (Grouped table, grouped by Type)
- **Overdue Reminders** (Table, filtered by Status = Pending AND Reminder Date < today)
- **This Week** (Table, filtered by Reminder Date between today and today + 7 days)

---

## Dashboard Views (Summary Database or Views)

### Monthly Revenue Dashboard

Create a **separate database** or use a **Summary page** with embedded views and formulas:

**Key Metrics (Using Rollups/Formulas):**

| Metric | Formula / Description |
|--------|----------------------|
| **Total Revenue (This Month)** | Sum of Invoice.Amount where Invoice Date = current month |
| **Total Revenue (YTD)** | Sum of Invoice.Amount where Invoice Date >= Jan 1 of current year |
| **Total Paid (This Month)** | Sum of Payment.Amount where Payment Date = current month |
| **Outstanding (This Month)** | Sum of Invoice.Amount Remaining where Invoice Date = current month AND Status ≠ Paid |
| **Overdue Amount** | Sum of Invoice.Amount Remaining where Due Date < today |
| **Clients (Active)** | Count of Clients where Status = Active |
| **Projects (Active)** | Count of Projects where Status = Active |
| **Average Invoice Amount** | Average of Invoice.Amount (all invoices) |
| **Days Sales Outstanding (DSO)** | Average of (Payment Received Date - Invoice Date) for paid invoices |

**Visualizations:**

1. **Revenue by Client** (Grouped bar chart: Group by Client, Sum Amount)
2. **Revenue Over Time** (Line chart: X-axis = Invoice Date by month, Y-axis = Sum Amount)
3. **Invoice Status Breakdown** (Pie chart: Group by Payment Status, count invoices)
4. **Top 5 Projects by Revenue** (Bar chart: Top 5 projects sorted by Total Invoiced)
5. **Payment Timeline** (Scatter plot: X = Due Date, Y = Amount; color by Payment Status)

---

## Sample Data Examples

### Sample Client
- **Name:** Acme Digital Marketing
- **Email:** billing@acmedigital.com
- **Phone:** (617) 555-0123
- **Payment Terms:** Net 30
- **Default Rate:** $150/hr
- **Status:** Active
- **Total Revenue:** $18,750 (6 invoices over 1 year)
- **Outstanding Balance:** $3,500 (2 invoices unpaid)

### Sample Project
- **Name:** Website Redesign Q1-Q2 2025
- **Client:** Acme Digital Marketing
- **Status:** Active
- **Start Date:** 2025-01-20
- **End Date:** 2025-03-30
- **Budget (Total):** $10,000
- **Hours Budgeted:** 150
- **Hours Logged:** 127
- **Total Invoiced:** $9,450 (2 invoices sent)

### Sample Invoice
- **Invoice #:** INV-2025-042
- **Client:** Acme Digital Marketing
- **Project:** Website Redesign Q1-Q2 2025
- **Invoice Date:** 2025-03-01
- **Due Date:** 2025-03-31
- **Amount:** $4,725
- **Description:**
  - Web Development: 25 hours @ $150/hr = $3,750
  - UI/UX Design Review: 6.5 hours @ $150/hr = $975
- **Status:** Sent
- **Payment Status:** Unpaid
- **Days Outstanding:** 15 (as of 2025-03-16)

### Sample Payment
- **Payment ID:** PAY-2025-127
- **Invoice(s):** INV-2025-040
- **Client:** Acme Digital Marketing
- **Amount:** $4,725
- **Payment Date:** 2025-03-14
- **Method:** Bank Transfer
- **Reference:** Wire TXN #4891027

---

## Relations & Rollups Summary

| From Database | To Database | Relationship Type | Key Rollups |
|---------------|-------------|-------------------|------------|
| Clients | Projects | One-to-Many | Total Projects, Total Revenue, Outstanding Balance |
| Clients | Invoices | One-to-Many | Total Revenue, Outstanding Balance |
| Clients | Payments | One-to-Many | Total Paid (this period) |
| Projects | Invoices | One-to-Many | Total Invoiced, Budget Remaining, Hours Logged |
| Invoices | Payments | One-to-Many | Amount Paid, Amount Remaining |
| Invoices | Reminders | One-to-Many | Sent Reminders (count) |

---

## Formula Examples

### Days Outstanding
```
dateBetween(now(), prop("Due Date"), "days")
```
Returns negative number if overdue, positive if future.

### Budget Remaining
```
prop("Budget (Total)") - prop("Total Invoiced")
```
Shows how much budget is left for a project.

### Amount Remaining on Invoice
```
prop("Amount") - prop("Amount Paid")
```
Tracks partial payments.

### Invoice Status (Auto-update)
```
if(prop("Amount Paid") == 0, "Unpaid", if(prop("Amount Paid") < prop("Amount"), "Partially Paid", "Paid"))
```
Auto-updates based on payment recorded.

---

## Views Quick Reference

**Clients Database:**
- Active Clients, By Industry, Contact Sheet, Top Earners

**Projects Database:**
- Active Projects, By Client, Timeline, Over Budget, Upcoming Deadlines

**Invoices Database:**
- All Invoices, Unpaid, Overdue, This Month, By Status, Payment Timeline, Awaiting Payment (Kanban)

**Payments Tracker:**
- All Payments, Recent Payments, By Client, This Month, Payment Status, Reconciliation View

**Reminders:**
- Pending Reminders, By Type, Overdue Reminders, This Week

---

## Implementation Notes for Builder

1. **Auto-numbering:** Use a formula or manual system to generate Invoice # (e.g., INV-2025-001). Notion doesn't have true auto-increment, so consider using `concat("INV-", year(now()), "-", padStart(prop("Manual ID"), 3, "0"))` or manage manually.

2. **Currency:** Create a master "Settings" page with a property storing the base currency (USD). Reference it in multi-currency setups if needed.

3. **Recurring Reminders:** Use Zapier or n8n to auto-create reminders for overdue invoices (7 days past due, 14 days, 30 days).

4. **Template Button:** Create a "Duplicate Invoice" template button that pre-fills Client, Project, and increments the Invoice #.

5. **Database Connections:** All relations should be bidirectional (Notion auto-creates reverse relations).

6. **Filters:** Use color coding for Status (Red = Overdue, Yellow = Due Soon, Green = Paid).

7. **Synced Blocks:** Embed key metrics from the dashboard onto the Client detail page so freelancers see their lifetime value at a glance.

8. **Cover Images:** Use branded covers for each database (customize colors per database).

---

## Time to Build

- **Core Databases Setup:** 30–40 minutes (create 5 databases, set properties, add relations)
- **Views Creation:** 20–30 minutes (18+ views with filters, sorts, grouping)
- **Formulas & Rollups:** 15–20 minutes (add formulas, test calculations)
- **Dashboard & Sample Data:** 20–30 minutes (add dashboards, sample entries, format)
- **Polish & Testing:** 10–15 minutes (colors, icons, final check)

**Total: 1.5–2 hours** to a fully functional, professional template.

---

## Support & Customization

**Common Customizations:**
- Add Time Tracking database (log hours daily; link to Invoices)
- Add Expense Tracker (track project costs; subtract from project profit)
- Add Contract / SOW database (track signed contracts and terms)
- Add Client Feedback database (testimonials, case study links)
- Add Tax / Deduction Tracker (for tax season prep)

