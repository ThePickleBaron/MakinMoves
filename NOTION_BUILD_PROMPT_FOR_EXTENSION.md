# Notion Template Build Prompt — For Claude Chrome Extension

**Copy this into Claude Chrome and paste it in. You handle captchas/verification.**

---

## THE PROMPT

I'm building a Notion template for freelancers (Invoice + Client Tracker). 

**What I need:** Step-by-step guidance to build this in Notion from scratch.

**Your role:** Tell me exactly what to click, what to create, and what to configure. I'll execute and verify each step.

**Build Spec (from COO brief):**

### Databases to Create (In This Order)
1. **Clients** — Name, Email, Rate, Status, Contract Date
2. **Projects** — Name, Client (relation), Budget, Status, Start Date, End Date
3. **Invoices** — Number, Project (relation), Amount, Due Date, Paid Date, Status
4. **Activity Log** — Entry Type, Related To, Timestamp, Description
5. **Payments** — Invoice (relation), Amount, Date, Method, Status

### Views Needed
- Clients: Table view (default)
- Projects: Table view + Kanban by Status
- Invoices: Table view + Overdue filter + By-Client filter
- All: Gallery views where sensible

### Formulas/Rollups
- Invoice Total per Client (sum)
- Days Overdue (if unpaid)
- Projects per Client (count)
- Revenue by Month (sum with date filter)

### Sample Data
- 3 sample clients
- 5 sample projects
- 8 sample invoices
- Enough to show the template works

---

## How This Works

1. **You:** Walk me through the Notion UI. What buttons exist? What options?
2. **Me:** Tell you exactly what to click and configure.
3. **You:** Execute, verify it worked, report back.
4. **Me:** Next step.

**If you hit a captcha or verification:** Stop, tell me you hit it, do it manually, then continue.

---

## Success Criteria

When done, you should have:
- ✅ 5 working databases
- ✅ 18+ views configured
- ✅ Formulas calculating correctly
- ✅ Sample data populated
- ✅ Shareable template link generated
- ✅ Link copied to clipboard

---

## Let's Go

Start by: "I'm ready. I'm in Notion. Show me the first step."

