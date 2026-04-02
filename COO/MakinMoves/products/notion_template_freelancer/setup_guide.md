# Setup Guide: Freelancer Invoice + Client Tracker

**Duration:** 30–45 minutes for full setup and customization
**Skill Level:** Beginner (no Notion coding required)
**What You'll Need:** A Notion account (free or paid), 30 minutes of uninterrupted time

---

## Table of Contents

1. [Step 1: Duplicate the Template](#step-1-duplicate-the-template)
2. [Step 2: Customize Your Workspace](#step-2-customize-your-workspace)
3. [Step 3: Configure Client Settings](#step-3-configure-client-settings)
4. [Step 4: Add Your First Clients](#step-4-add-your-first-clients)
5. [Step 5: Import Historical Data (Optional)](#step-5-import-historical-data-optional)
6. [Step 6: Create Your First Invoice](#step-6-create-your-first-invoice)
7. [Step 7: Invite Team Members (Optional)](#step-7-invite-team-members-optional)
8. [Step 8: Setup Automation (Optional)](#step-8-setup-automation-optional)
9. [Customization Tips](#customization-tips)
10. [Troubleshooting](#troubleshooting)

---

## Step 1: Duplicate the Template

### What You're Doing
Creating your own copy of this template in your Notion workspace.

### How To:

1. **Open the template link** you received after purchase
2. Click **"Duplicate"** in the top-right corner (or look for a button saying "Add to Notion")
3. A new window will open. Choose **where to save it** in your Notion workspace:
   - Recommended: Create a new page called **"Freelance Business"** and save the template inside
   - Or save to root of your workspace
4. Click **"Duplicate"** to confirm
5. Wait 10–30 seconds for Notion to copy all databases and views (you'll see a loading screen)
6. Once complete, you'll be in the new template—**congratulations!**

**Tip:** If you don't see the "Duplicate" button, right-click the page title and select "Duplicate."

---

## Step 2: Customize Your Workspace

### 2a. Rename the Workspace Title
1. Click the main page title at the very top (probably says "Freelancer Invoice + Client Tracker")
2. Change it to your name or business name (e.g., "Sarah's Freelance Hub" or "Acme Agency")
3. Add an emoji if you like (click the icon to the left of the title)

### 2b. Review the Sidebar Structure

Your new workspace should look like this:

```
Freelancer Invoice + Client Tracker (or your custom name)
├── Clients
├── Projects
├── Invoices
├── Payments
├── Reminders
├── Dashboard
└── Settings (create this now if you want to centralize info)
```

**If anything is missing:** Don't worry. All databases exist; they might just be on different pages. Look for them in your "All" or search the Notion sidebar.

### 2c. Set Your Base Currency

Although not required, it's helpful to standardize on one currency. Make a note:

**My Base Currency:** ______ (USD, EUR, GBP, CAD, AUD, etc.)

All currency fields in the template support any currency—just be consistent.

---

## Step 3: Configure Client Settings

Before adding clients, you'll customize a few key settings.

### 3a. Review the Clients Database

1. Open **Clients** database
2. Look at the properties (columns) on the right:
   - Client Name, Email, Phone, Website, Address, Payment Terms, Default Rate, Currency, Status, Industry, First Engagement Date, Notes, + rollups

**These are pre-configured.** You can:
- Delete any columns you don't use
- Add new columns (right-click header → Add property)
- Change the order of columns (drag headers left/right)

### 3b. Customize Payment Terms (If Needed)

1. Click on the **"Payment Terms"** column header
2. Select **"Edit Property"**
3. You'll see the default options: Net 15, Net 30, Net 45, Upon Invoice, Upon Completion
4. **Add, edit, or delete options** to match your business:
   - Example: If you always invoice on 50/50 split, add "50% Upfront, 50% on Delivery"
   - Delete any terms you never use
5. Click **"Done"**

### 3c. Customize Industry Tags (If Needed)

1. Click on the **"Industry"** column header
2. Select **"Edit Property"**
3. You'll see example industries: Tech, Marketing, Legal, E-commerce, Consulting, Design, Education, Healthcare, Other
4. **Modify to match your typical clients:**
   - Remove industries you don't serve
   - Add industries you specialize in
5. Click **"Done"**

### 3d. Set Your Default Hourly Rate

This is just a reference. It applies to new clients unless overridden per-client.

1. On any client record, look for **"Default Rate (Hourly)"**
2. Enter your standard rate (e.g., $150)
3. You can override this per client (some clients might be $100, others $200)

---

## Step 4: Add Your First Clients

### Quick Entry

1. Open the **Clients** database
2. Click **"+ Add a new entry"** (usually at the bottom or top of the table)
3. Fill in the key info:
   - **Client Name** (required)
   - **Email**
   - **Phone**
   - **Payment Terms** (select from dropdown)
   - **Default Rate**
   - **Status** (set to "Active" for current clients)
4. Click outside the row to save
5. Click the row to open the full client card and add more details (address, website, notes, etc.)

### Best Practices

- **Start with active clients only.** Add past clients later after you're comfortable with the system.
- **Fill in payment terms early.** This affects your Due Date calculation on invoices.
- **Use notes liberally.** "Prefers invoices on the 1st of month," "Uses Quickbooks," "Needs 2 separate invoices for accounting" — these matter.
- **Set a consistent default rate.** You'll override per-client when needed, but this speeds things up.

### Adding Related Data Later

**Don't worry about Projects, Invoices yet.** As you create invoices and projects, they'll automatically link to the client. You don't need to manually connect them (Notion handles that).

---

## Step 5: Import Historical Data (Optional)

If you have invoices, clients, or payments from another system (Freshbooks, Wave, Excel, email), import them now.

### 5a. Export from Your Current System

**From Excel/Google Sheets:**
1. Prepare a CSV file with these columns: `Client Name`, `Email`, `Invoice #`, `Amount`, `Invoice Date`, `Due Date`, `Status`
2. Save as `.csv`

**From Freshbooks/Wave:**
1. Export invoices as CSV (usually under Reports → Invoices)
2. Save the file locally

**From Email/Manual Records:**
1. Create a spreadsheet with key invoice info
2. Save as `.csv`

### 5b. Import to Notion

1. Open the **Invoices** database
2. Click **"..."** (more options) in top-right
3. Select **"Import"** → **"CSV"**
4. Select your `.csv` file
5. Map columns:
   - CSV Column → Notion Database Property
   - E.g., "Invoice #" → "Invoice #", "Amount" → "Amount"
6. Review the preview and click **"Import"**
7. Repeat for Clients and Payments if needed

**Note:** You may need to manually link clients to invoices after import (Notion tries to match automatically). Don't worry—you can do this incrementally.

---

## Step 6: Create Your First Invoice

### Step-by-Step

1. Open the **Invoices** database
2. Click **"+ Add a new entry"**
3. Fill in:
   - **Invoice #** (e.g., INV-2025-001; you choose the format)
   - **Client** (select from dropdown — only your active clients will show)
   - **Project** (optional; if not linked to a project, leave blank)
   - **Invoice Date** (today's date)
   - **Due Date** (e.g., today + 30 days if client's payment terms are Net 30)
   - **Amount** (total invoice amount)
   - **Currency** (USD, EUR, etc.)
   - **Description** (line items: e.g., "Web Development: 40 hours @ $150/hr = $6,000")
   - **Status** (set to "Draft" while creating; change to "Sent" when you send it)
4. Click the invoice row to open the full card
5. Add **Notes** if relevant (e.g., "Include payment instructions in cover email")
6. Save

### Sending the Invoice

**Notion doesn't send invoices.** You'll export or screenshot the invoice and email it manually:

1. Click **"..."** (more options) on the invoice card
2. Select **"Export as PDF"** or screenshot the invoice
3. Email the PDF to the client
4. Come back to the invoice in Notion and change **Status** to "Sent"

**Optional:** Use a tool like Zapier or n8n to auto-send from Notion (see [Step 8: Setup Automation](#step-8-setup-automation-optional)).

---

## Step 7: Invite Team Members (Optional)

If you have a business partner, assistant, or bookkeeper, share the workspace.

### How To:

1. Click **"Share"** in the top-right of your Notion workspace
2. Enter their **email address**
3. Choose their **permission level:**
   - **Edit:** Can view, add, and modify everything
   - **Comment:** Can view and comment but not edit
   - **View:** Read-only access
4. Click **"Invite"**
5. They'll get an email and can access the shared workspace

### Suggested Permissions:

- **Bookkeeper / Admin:** Full Edit access
- **Client (view only):** Comment or View access to see project progress
- **Team member helping with proposals:** Edit on specific pages only

---

## Step 8: Setup Automation (Optional)

This requires a bit of technical comfort, but dramatically increases the power of your template.

### 8a. Auto-Create Reminders for Overdue Invoices

**Using Zapier (easiest):**

1. Sign up for Zapier (free tier available)
2. Create a new Zap:
   - **Trigger:** Notion → When a database entry is updated
   - Select the "Invoices" database
   - Filter: "Status" is "Overdue" (use a formula or filter in Notion first)
3. **Action:** Create a new record in the "Reminders" database with:
   - Type: "Payment Reminder"
   - Invoice: Link to the overdue invoice
   - Client: Auto-populate from invoice
   - Reminder Date: Today's date
   - Status: "Pending"
4. Test the Zap and activate

**Using Notion's Built-in Reminders (simpler):**

1. Open each invoice
2. Click **"..."** → **"Add reminder"**
3. Set reminder for "Due Date" or "Due Date + 7 days"
4. Notion will notify you via email

### 8b. Email Notification on Payment Received

1. Open the Payments database
2. Click **"+ New template button"** to create automation
3. Set trigger: When a new payment is added
4. Action: Send email to you confirming the payment
5. Notion will send you notifications (requires Notion Pro, but does work)

---

## Step 9: Customization Tips

### Customization #1: Change Views
You get 18+ pre-built views. If you want different ones:

1. Open any database
2. Click **"+ Add a view"** at the top-left
3. Choose view type (Table, Gallery, Timeline, Kanban, Calendar)
4. Add filters, sorts, and grouping to fit your workflow

**Example:** If you want to see invoices by month, create a new Table view, sort by Invoice Date, and group by month.

### Customization #2: Add More Properties

If you need to track something not in the template (e.g., VAT/GST, PO numbers, contract dates):

1. Open the relevant database (e.g., Invoices)
2. Click **"+"** at the far right of the column headers
3. Choose property type (Text, Number, Date, Checkbox, etc.)
4. Name it and configure
5. Click **"Done"**

**Common additions:**
- **Invoices:** Add "VAT/GST #" (Checkbox or Text)
- **Projects:** Add "Contract URL" (Link)
- **Clients:** Add "Tax ID" (Text)

### Customization #3: Change Colors & Icons

1. Click the page name in the sidebar
2. Click the icon and color next to the page title
3. Choose a new icon or color
4. Repeat for all databases

### Customization #4: Create a Client Portal

**Advanced:** If you want clients to see their invoice status:

1. Create a new "Client View" of the Invoices database (filtered to a specific client)
2. Share this view publicly with a unique link
3. Send each client their link so they can see their invoices
4. Set to **"View only"** so they can't edit

---

## Step 10: Best Practices & Workflow

### Daily Workflow

1. **Start of day:** Check **"Pending Reminders"** view (Reminders database) for any follow-ups
2. **When you finish work:** Add time/deliverable to the Project
3. **When creating an invoice:** Copy the hours from the Project, create the invoice in the Invoices database, change status to "Draft"
4. **Before sending:** Export as PDF and email to client, then update status to "Sent" in Notion
5. **When paid:** Log the payment in the Payments database, which automatically updates the invoice status

### Weekly Workflow

1. **Check "Overdue" view** in Invoices database—any invoices past due?
2. **Create payment reminders** for invoices due this week
3. **Review "Active Projects"** view—are any over budget or past timeline?
4. **Check outstanding balance** on each client's record (via rollup)

### Monthly Workflow

1. **Review Monthly Revenue Dashboard:**
   - Total revenue this month (invoiced and paid)
   - Compare to last month
   - Check outstanding balance
   - Review overdue invoices
2. **Archive completed projects** (change status to "Completed")
3. **Export revenue report** for accounting (see instructions below)
4. **Plan next month's focus** based on active projects and client capacity

### Exporting for Accounting

1. Open the **Invoices** database
2. Filter by Invoice Date = current month
3. Click **"..."** → **"Export as PDF"** or **"Export as CSV"**
4. Save to your accounting folder
5. Share with your accountant or bookkeeper

---

## Troubleshooting

### Issue: Missing Databases

**Problem:** I can't see the Invoices or Payments database.

**Solution:**
1. Look in the left sidebar for **"All Pages"** or **"Database"**
2. Search using Notion's search (Ctrl+K or Cmd+K)
3. If still missing, check that you duplicated the entire template (not just a single page)

---

### Issue: Relations Not Working

**Problem:** I created a client, but when I try to link it to an invoice, it doesn't show up.

**Solution:**
1. Make sure the client's **Status** is set to "Active" (some views filter by status)
2. Try refreshing Notion (Cmd+R or Ctrl+R)
3. Check that you created the client in the **Clients** database (not somewhere else)

---

### Issue: Formulas Showing Errors

**Problem:** A column (like "Days Outstanding") shows "#ERROR!" instead of a number.

**Solution:**
1. Click the column header
2. Select **"Edit Property"**
3. Check that the formula is referring to the correct properties (property names are case-sensitive)
4. Common fix: If you renamed a property, update the formula to match the new name
5. If still broken, delete and re-create the formula (copy it from the Template Spec document)

---

### Issue: Invoices Not Auto-Updating to "Overdue"

**Problem:** I expected the status to automatically change to "Overdue" but it didn't.

**Solution:**
- Notion **doesn't auto-update** formulas in the UI; you have to refresh.
- Better approach: Create a **filter view** showing invoices where Due Date < Today (this shows truly overdue invoices)
- Or use the **"Overdue"** pre-built view which already has this filter

---

### Issue: Can't Duplicate the Template

**Problem:** I clicked "Duplicate" but it didn't work.

**Solution:**
1. Make sure you're logged into your Notion account
2. Try a different browser (sometimes browser extensions block Notion)
3. If you have a slow internet connection, wait 30+ seconds
4. Try duplicating a single page first to test (then duplicate the whole template)
5. If all else fails, ask support in Notion or reach out with your error message

---

### Issue: Want to Add Time Tracking

**Problem:** I need to track hours per project, not just use the "Hours Logged" rollup.

**Solution (without creating new database):**
1. Add a property to the **Invoices** database called **"Hours"** (Number)
2. When creating an invoice, fill in the hours worked
3. This automatically shows in the Project's "Hours Logged" rollup

**Better solution (advanced):**
1. Create a new database called **"Time Entries"** with properties: Date, Project, Hours, Notes
2. Link it to the Projects database
3. Create a rollup on Project pulling "Sum of Hours" from Time Entries
4. Now you have detailed time tracking

---

### Issue: Can't Share with Team

**Problem:** I tried to invite my team member but they didn't get an email.

**Solution:**
1. Make sure you have Notion **Workspace Admin** access (only admins can invite)
2. Check that you entered their email correctly
3. Ask them to check their spam folder
4. Try inviting them again
5. As a workaround, share the specific database (or page) instead of the whole workspace

---

## Quick Start Checklist

Use this checklist to get up and running in under 30 minutes:

- [ ] Duplicate the template to your Notion workspace
- [ ] Rename the workspace to your business name
- [ ] Customize payment terms (if needed)
- [ ] Set your default hourly rate
- [ ] Add 3–5 current clients to the Clients database
- [ ] Create your first invoice in the Invoices database
- [ ] Update the invoice status to "Sent" after emailing it
- [ ] Log a test payment in the Payments database
- [ ] Check the Monthly Revenue Dashboard and confirm numbers make sense
- [ ] Invite your bookkeeper or team member (optional)

**That's it!** You're ready to use the system.

---

## Getting Help

### Common Questions

**Q: Can I use this for my agency with multiple team members?**
A: Yes. Share the workspace with your team. Consider giving different people access to different databases (e.g., only the Project Manager sees Projects, only Admin sees Payments).

**Q: What if I want to track expenses too?**
A: Create a new database called "Expenses" with similar fields (Date, Amount, Category, Project). Link it to Projects to calculate project profit = Invoice Amount - Expenses.

**Q: Can I integrate with Stripe or PayPal?**
A: Use Zapier or n8n to create a zap: When payment received in Stripe → Create record in Notion Payments database. (Requires Zapier Pro or n8n, ~$20–50/month.)

**Q: How do I handle retainer clients (monthly recurring)?**
A: Create a template button on the Invoices database that duplicates your retainer invoice and auto-populates the client, amount, and due date. Click it once a month to invoice the retainer client.

---

## Next Steps

1. **This week:** Use the system for one full client cycle (invoice → payment).
2. **This month:** Import your historical invoices so you have a complete view of revenue.
3. **Ongoing:** Create recurring payment reminders for clients who are consistently late.
4. **Consider:** Explore the 8 customization tips above if you want more features.

---

## Support & Feedback

If you run into issues or have feature requests:

1. **Check the Troubleshooting section above** (most issues are covered)
2. **Consult the Template Spec document** for details on any property, formula, or relation
3. **Notion Help Center:** notion.so/help for Notion-specific questions
4. **Reach out:** If you have feedback or find bugs, reply to the purchase confirmation email

---

**Congratulations!** You now have a professional invoice and client tracking system. You're going to save so much time and money. Let's go build your freelance empire.

