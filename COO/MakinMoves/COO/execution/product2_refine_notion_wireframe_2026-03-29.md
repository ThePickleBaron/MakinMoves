# Product #2 — REFINE Phase Deliverable
## Freelancer Invoice + Client Tracker (Notion): Database Schema + Wireframe
### Filed: 2026-03-29 17:07 | COO | Pipeline Stage: 🔧 REFINE

---

## Product Title (Locked)
**"Freelance Business OS — The Notion System for Independent Contractors"**

Price: $29 (launch price, first 15 sales) → $39 (standard)
Format: Notion template (duplicate link) + PDF Setup Guide + Loom walkthrough video link

---

## Anti-Subscription Positioning (Locked)
**"Stop paying $15/month for invoicing software. One purchase. Your entire freelance business in Notion — forever."**

---

## 5-Module Architecture (Scope Locked — No Additions Until v2)

### Module 1: Client Directory (CRM)
**Purpose:** Single source of truth for every client relationship

**Database: `Clients`**
| Property | Type | Notes |
|----------|------|-------|
| Name | Title | Client/company name |
| Status | Select | Active / Inactive / Lead / Archived |
| Industry | Select | 10 common freelancer industries |
| Primary Contact | Text | Name + role |
| Email | Email | Direct link |
| Phone | Phone | Optional |
| Hourly Rate | Number | Client-specific rate override |
| Total Revenue | Rollup | Sum of all paid invoices for this client |
| Active Projects | Rollup | Count of projects with status ≠ Complete |
| Notes | Text | Relationship context, communication preferences |
| Files | Files | Contract, NDA, brand assets |
| Date Added | Date | When relationship started |

**Views:**
- 📋 All Clients (table, sorted by Total Revenue desc)
- 🎯 Active Clients (filtered: Status = Active)
- 🔍 Leads Pipeline (filtered: Status = Lead, grouped by Stage)

---

### Module 2: Project Pipeline
**Purpose:** Track every project from prospect to invoiced

**Database: `Projects`**
| Property | Type | Notes |
|----------|------|-------|
| Project Name | Title | Descriptive name |
| Client | Relation | → Clients |
| Status | Select | Prospect / Active / Review / Complete / Cancelled |
| Stage | Select | Discovery / Proposal / Contract / In Progress / Delivery / Revision / Done |
| Start Date | Date | Actual or projected |
| Deadline | Date | Enables countdown formula |
| Days Until Deadline | Formula | `dateBetween(prop("Deadline"), now(), "days")` |
| Project Value | Number | Total contracted amount |
| Invoiced | Rollup | Sum of invoice amounts linked to this project |
| Remaining | Formula | `prop("Project Value") - prop("Invoiced")` |
| Scope Notes | Text | Agreed deliverables (scope reference) |
| Revision Count | Number | Manual track (alert if approaching limit) |
| Tags | Multi-select | Type of work (design, dev, writing, etc.) |

**Views:**
- 🗂️ Board View (Kanban by Stage)
- 📅 Calendar View (by Deadline)
- 💰 Revenue Pipeline (grouped by Status, shows Project Value)
- 📊 All Projects (table)

---

### Module 3: Invoice Log
**Purpose:** Create, track, and follow up on every invoice

**Database: `Invoices`**
| Property | Type | Notes |
|----------|------|-------|
| Invoice # | Title | Auto-formatted: INV-001, INV-002... |
| Client | Relation | → Clients |
| Project | Relation | → Projects |
| Amount | Number | Invoice total |
| Status | Select | Draft / Sent / Overdue / Paid / Cancelled |
| Issue Date | Date | Date invoice sent |
| Due Date | Date | Payment due |
| Days Overdue | Formula | If unpaid + past due: `dateBetween(now(), prop("Due Date"), "days")` |
| Paid Date | Date | Actual payment received |
| Payment Method | Select | Bank Transfer / PayPal / Stripe / Venmo / Check / Other |
| Notes | Text | Partial payments, disputes, etc. |

**Views:**
- 📬 Outstanding Invoices (filtered: Status = Sent or Overdue, sorted by Due Date)
- ⚠️ Overdue (filtered: Status = Overdue, sorted by Days Overdue desc)
- ✅ Paid This Month (filtered: Paid Date = this month)
- 📊 All Invoices (table, full history)

**Built-in follow-up prompts (linked to invoice page):**
- Day 1 overdue message template
- Day 7 overdue message template
- Day 14 final notice template

---

### Module 4: Payment Tracker + Revenue Dashboard
**Purpose:** Know exactly what's been paid, what's pending, and revenue trends

**Database: Not a separate DB** — this is a filtered view + summary rollup from Invoices

**Dashboard Page Elements:**
- **This Month Revenue** (formula from Invoices, filtered by current month)
- **Outstanding Balance** (sum of all Sent + Overdue invoices)
- **YTD Revenue** (sum of all Paid invoices, current year)
- **Average Invoice Value** (formula)
- **Fastest Paying Client** (linked to Clients rollup)
- **Slowest Paying Client** (linked to Clients rollup)

**Monthly Revenue Gallery:**
- Linked view grouped by Month (Paid Date)
- Shows: invoices paid, total collected, count

---

### Module 5: Activity Timeline
**Purpose:** Everything that matters, in one chronological feed

**Database: `Activity Log`**
| Property | Type | Notes |
|----------|------|-------|
| Activity | Title | Brief description |
| Type | Select | Invoice Sent / Payment Received / Project Started / Project Completed / Client Added / Note / Follow-up Sent |
| Client | Relation | → Clients |
| Project | Relation | → Projects |
| Date | Date | When it happened |
| Amount | Number | For financial events |

**Views:**
- 📅 Timeline (by Date, all types)
- 💬 Client Activity (grouped by Client, filtered by selected client)
- 💰 Financial Events Only (filtered: Type = Invoice Sent or Payment Received)

---

## Start Here Page Structure

```
🚀 Welcome to Your Freelance Business OS

Setup takes 5 steps:
Step 1: Duplicate this template to your Notion workspace
Step 2: Add your first client in the Client Directory
Step 3: Add your first project and link it to that client
Step 4: Create your first invoice (use INV-001)
Step 5: Watch the Revenue Dashboard update automatically

📹 Watch the 8-minute walkthrough: [Loom link]

---
📋 Module Guide
[Links to each of the 5 modules]
---
💡 Tips
- All databases are linked — add a client once, reference everywhere
- The Overdue view updates automatically at midnight
- Use the Activity Log to keep a paper trail for every client interaction
```

---

## PDF Setup Guide Outline (Companion Document)

1. **What's in this template** (1 page) — module overview, what each tracks
2. **Getting started in 5 steps** (1 page) — matches Start Here page
3. **Customizing for your business** (1 page) — how to rename statuses, add industries, adjust rate fields
4. **Notion formulas explained** (1 page) — plain English explanations of every formula
5. **Follow-up message templates** (1 page) — the 3 invoice follow-up scripts, ready to copy

---

## Technical Notes for CTMO

1. **Delivery mechanism:** Gumroad delivers a PDF with the Notion template duplicate link embedded. The link is a `notion.so/template/[id]` URL — buyers click "Duplicate" and it lands in their workspace.
2. **No Notion account requirement for purchase** — buyers need a free Notion account to use the template (they almost certainly have one)
3. **Video walkthrough:** Loom free tier supports up to 25 videos, 5-min limit. Options: (a) Use Loom free, keep video ≤5 min; (b) Unlisted YouTube video (no limit, no cost); COO recommends YouTube unlisted.
4. **Formula compatibility:** All formulas use Notion's standard formula syntax (post-2023 update). Avoiding deprecated `dateCompare` — using `dateBetween` throughout.

---

## Listing Description Draft

**Headline:** Freelance Business OS — Track Clients, Projects & Invoices in One Notion System

**Subhead:** Stop juggling spreadsheets, email threads, and half-remembered conversations. One Notion workspace, your entire freelance operation.

**Body:**
Most freelancers track clients in their head, invoices in a spreadsheet, projects in a notebook, and payment reminders in their inbox. That's four systems where things fall through the cracks.

This template gives you one system:

- **Client Directory** — Every client, their rates, total revenue, and relationship notes in one database
- **Project Pipeline** — Kanban view from prospect to paid, with deadlines and scope built in
- **Invoice Log** — Track every invoice with built-in overdue detection and follow-up templates
- **Revenue Dashboard** — Your monthly and YTD revenue, outstanding balance, and payment trends, calculated automatically
- **Activity Timeline** — A running log of every payment, project start, and client interaction

One purchase. No monthly fees. Forever yours.

Works with any free Notion account. Setup in under 10 minutes.
Includes: Full Notion template + PDF setup guide + 8-minute video walkthrough

**CTA:** Get the Freelance Business OS for $29 →

---

## Next Step
→ PROTOTYPE phase: Build the actual Notion template (databases, views, formulas, Start Here page)
→ Gate: CTMO reviews formula approach and delivery mechanism before build begins
→ Estimated build: 6–8 hours for full template + PDF guide
