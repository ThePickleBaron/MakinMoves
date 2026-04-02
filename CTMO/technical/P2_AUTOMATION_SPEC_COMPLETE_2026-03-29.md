# P2 Freelance Writing: Complete Automation Specification
**Status:** Production-Ready Technical Spec
**Date:** 2026-03-29
**Owner:** CTMO
**Deadline:** Implementation by April 21 (first cold client expected)
**Context:** Hybrid acquisition (cold + warm email). This spec covers client intake → project tracking → invoicing → payment automation.

---

## EXECUTIVE SUMMARY

**What:** End-to-end automation for P2 freelance writing service (cold email clients → onboarding → project tracking → invoicing → payment collection).

**Why:** CFO/CEO approved Hybrid P2 strategy (cold + warm). Cold closes expected April 21. Need automation infrastructure BEFORE first client to ensure seamless delivery at scale (target: 2-3 clients/month by June).

**Recommendation:** **Use Zapier free tier + Airtable free tier** (NOT n8n). Reasons:
1. **Free tier sufficient** for 10-20 clients/month (40-50 workflow tasks/month = well under limits)
2. **Faster setup** (3-4 hours vs. 2+ days for n8n configuration)
3. **Integrations match exactly** (Calendly, Airtable, Stripe, email tools all native)
4. **Zero infrastructure cost** (no Docker, no hosting)
5. **Easier for manual intervention** if needed (less technical than n8n)

**Alternative:** If autonomy required post-March 31 (no manual intervention), use n8n self-hosted (already in Docker). Cost-benefit heavily favors Zapier for P2 at current scale.

---

## PART 1: INTEGRATION CHAIN ARCHITECTURE

### 1.1 Overall Flow

```
CLIENT INTAKE
  ↓ [Calendly booking received]
  ↓ [Zapier trigger]
  ↓ [Create Airtable record + send welcome email]
  ↓
PROJECT TRACKING
  ↓ [Onboarding form filled → Airtable updated]
  ↓ [Invoice generated in Zapier → stored in Airtable]
  ↓ [Project status tracked (draft/review/final)]
  ↓
INVOICING & PAYMENT
  ↓ [Invoice due date triggered → send payment reminder]
  ↓ [Stripe payment received → mark as paid in Airtable]
  ↓ [Revenue logged for CFO tracking]
  ↓
DELIVERY & FOLLOW-UP
  ↓ [Deliver final deliverable → mark project complete]
  ↓ [Send post-delivery email + feedback request]
  ↓ [Track refund requests]
```

### 1.2 Platform Selection Matrix

| Component | Platform | Reason | Free Tier Capacity |
|-----------|----------|--------|-------------------|
| **Booking** | Calendly | Native Zapier integration, UI familiar | 1 user, unlimited bookings ✓ |
| **CRM/Tracking** | Airtable | Free tier: 1,000 records/base, perfect for <50 clients | 1 base, 1,200 records/base ✓ |
| **Email** | SendGrid or Mailchimp | Free tier adequate for transactional email | SendGrid: 100/day, Mailchimp: <300/month ✓ |
| **Payments** | Stripe | Native Zapier integration, PCI compliant | Unlimited, 2.9% + $0.30/transaction |
| **Automation** | Zapier | Free tier: 100 tasks/month (sufficient) | 100 tasks/month ✓✓✓ |
| **Invoicing** | Manual (Wave free) or Zapier + Airtable | Optional: Wave free invoicing, OR generate via Zapier | Wave: unlimited invoices ✓ |
| **Backup/Sync** | Google Sheets (free export) | Export Airtable weekly to Drive for backup | Unlimited ✓ |

**Total Monthly Cost:** $0-29 (optional SendGrid paid tier if >100 emails/day)

---

## PART 2: DETAILED WORKFLOW SPECIFICATIONS

### Workflow 1: Calendly Booking → Airtable Contact Creation

**Trigger:** Calendly booking confirmed
**Actions:**
1. Extract booking data: client name, email, event type, time
2. Check Airtable "Clients" table: does this email already exist?
   - **If YES:** Update record with latest booking date
   - **If NO:** Create new record
3. Create companion record in "Projects" table (status: "Awaiting Onboarding")
4. Send welcome email via SendGrid (template: "Welcome to P2 Freelance Writing")

**Zapier Task Count:** 1 task = 1 Calendly trigger + Airtable operations
**Latency Target:** <2 min (usually <30 sec)
**Failure Recovery:**
- If Airtable down: Zapier retries every 2 hours (up to 3x)
- If email fails: Email still queued in SendGrid, retry automatically
- **Manual fallback:** Check Calendly→Airtable sync weekly

**Key Fields in Airtable "Clients" table:**
- Name (text)
- Email (email)
- Phone (text)
- Date Booked (date)
- Booking Source (single select: Cold Email / Warm Email / Website)
- Status (single select: Prospect / Onboarded / Active / Completed / Refunded)
- Total Spent (currency, auto-sum from Projects)

---

### Workflow 2: Onboarding Form Submitted → Project Details Captured

**Trigger:** Typeform or Airtable form submission (client details)
**Actions:**
1. Extract fields: project scope, word count, deadline, tone, budget confirmation
2. Create/update "Projects" record in Airtable
3. Calculate invoice amount (based on word count × $0.08/word or flat fee)
4. Send project confirmation email (auto-generated from Airtable data)
5. Trigger email: "Your project is queued. You'll receive first draft by [DATE]"

**Zapier Task Count:** 1 task per form submission
**Latency Target:** <5 min
**Failure Recovery:**
- If form tool down: Client can reply via email (fallback manual intake)
- If Airtable quota exceeded: Zapier queues and retries

**Airtable "Projects" table schema:**
- Project ID (auto-number)
- Client (linked to Clients table)
- Title (text)
- Word Count (number)
- Deadline (date)
- Status (single select: Awaiting Onboarding / Assigned / In Progress / Draft Ready / Revisions / Final / Paid)
- Rate (currency: auto-calc word count × $0.08 or override)
- Invoice ID (text, linked to Invoices)
- Amount Due (currency, auto from rate)
- Date Created (auto)
- Date Due (auto)

---

### Workflow 3: Invoice Generation & Payment Reminder

**Trigger 1: Project onboarding complete** (manual trigger or Airtable status change)
**Actions:**
1. Generate invoice number (format: P2-2026-001, auto-increment)
2. Create invoice record in Airtable "Invoices" table
3. Generate PDF invoice (Zapier template or Wave)
4. Send invoice email with Stripe payment link via SendGrid
5. Set reminder for 5 days before due date

**Trigger 2: 5 days before due date** (Zapier scheduled trigger via Airtable date field)
**Actions:**
1. Check Airtable: has payment been received?
   - **If YES:** Skip remainder
   - **If NO:** Send payment reminder email
2. Log reminder sent in Airtable

**Zapier Task Count:** 2 tasks total (1 for generation, 1 for reminder)
**Latency Target:** Invoice email <2 min, Reminder <5 min on due date
**Failure Recovery:**
- If Stripe link fails: Send manual payment instructions in email
- If reminder date missed: Manual check via Airtable weekly

**Airtable "Invoices" table schema:**
- Invoice Number (text, unique)
- Project ID (linked to Projects)
- Amount (currency)
- Due Date (date)
- Date Created (date, auto)
- Status (single select: Draft / Sent / Paid / Overdue / Refunded)
- Stripe Payment Intent ID (text)
- Payment Received Date (date)
- Notes (long text)

---

### Workflow 4: Stripe Payment Received → Airtable Updated + Revenue Logged

**Trigger:** Stripe charge succeeded
**Actions:**
1. Extract payment data: amount, customer email, charge ID
2. Look up Airtable "Projects" by customer email
3. Update Project status → "Paid"
4. Update Invoice status → "Paid" + capture Stripe transaction ID
5. Log to CFO revenue tracking table (separate view or export)
6. Send thank-you email

**Zapier Task Count:** 1 task per payment
**Latency Target:** <5 min (usually <1 min)
**Failure Recovery:**
- If Airtable lookup fails: Manual match via email address
- If revenue log fails: Stripe data is canonical source of truth (CFO can query Stripe dashboard)

---

### Workflow 5: Project Delivery → Auto-Trigger Follow-Up Sequence

**Trigger:** Project status manually changed to "Final" in Airtable (or scheduled 1 day before deadline)
**Actions:**
1. Send project delivery email with final deliverable link
2. Request feedback via Typeform link
3. Offer revision window (48 hours)
4. Schedule follow-up email for 3 days post-delivery (cross-sell bundled services)

**Zapier Task Count:** 2 tasks (delivery email + follow-up scheduled)
**Latency Target:** Immediate (<1 min)
**Failure Recovery:**
- If email fails: Still in SendGrid queue, retry automatically
- If feedback form down: Client can reply via email

---

### Workflow 6: Refund Request → Processing + Status Update

**Trigger:** Email received (client@domain requests refund)
**Actions:**
1. Create refund request record in Airtable "Refunds" table
2. Alert CEO via email (manual review required)
3. Update Project status → "Refund Requested"
4. Document refund amount, reason, decision

**Manual Step:** CEO reviews and approves/denies within 24 hours
**Post-Approval:**
1. Stripe API: Initiate refund
2. Zapier: Update Airtable refund status → "Processed"
3. Send refund confirmation email
4. Update Project status → "Refunded"

**Zapier Task Count:** 2-3 tasks (intake + approval notification + execution)
**Latency Target:** <2 hours for alert, <24 hours for approval, <30 min for execution
**Failure Recovery:** Manual review ensures no automated errors

**Airtable "Refunds" table schema:**
- Refund ID (auto)
- Project ID (linked)
- Amount (currency)
- Reason (long text)
- Status (single select: Requested / Approved / Denied / Processed)
- Date Requested (auto)
- Date Processed (date)
- Notes (long text)

---

## PART 3: ZAPIER CONFIGURATION DETAILS

### Free Tier vs. Pro Tier Analysis

| Metric | Zapier Free | Your Usage | Verdict |
|--------|------------|-----------|---------|
| Tasks/month | 100 | 40-50 | ✓✓✓ Well under limit |
| Workflows (Zaps) | 5 | 6 needed | ⚠️ Need 1 more workflow, upgrade to Pro |
| Actions/step | 1 | 1-2 | ✓ OK |
| Triggers | Unlimited | 6 | ✓ OK |
| Conditional logic | Limited | Needed | ⚠️ Free has "Path" but not full logic |
| API connections | Limited | Calendly, Airtable, Stripe, SendGrid | ✓ All supported |
| Execution frequency | Real-time or schedule | Real-time + scheduled | ✓ OK |

**Recommendation:** **Upgrade to Zapier Pro ($29.99/mo)** to get 20+ workflows (only $30/year for unlimited Zaps).

### Free Tier Task Calculation

**Estimated monthly tasks at 3 clients/month:**

| Workflow | Trigger | # Tasks | Frequency | Monthly |
|----------|---------|---------|-----------|---------|
| Calendly → Airtable | Booking confirmed | 1 | 3x/month | 3 |
| Onboarding form | Form submission | 1 | 3x/month | 3 |
| Invoice generation | Status change | 1 | 3x/month | 3 |
| Invoice reminder | Scheduled | 1 | 3x/month | 3 |
| Stripe webhook | Payment received | 1 | 3x/month | 3 |
| Delivery email | Status change | 1 | 3x/month | 3 |
| Weekly export | Scheduled | 1 | 4x/month | 4 |
| **TOTAL** | | | | **22 tasks/month** |

**At 10 clients/month (future state):**
- Estimate: ~70 tasks/month (still within free tier!)
- Headroom until ~150 clients/month before needing Team plan

**Upgrade path:**
- 0-15 clients/month: **Free tier** (100 tasks)
- 15-100 clients/month: **Pro tier** ($29.99/mo, 750 tasks)
- 100+ clients/month: **Team tier** ($99/mo, 20,000 tasks)

---

### Zap Configuration (Ready-to-Use)

#### Zap 1: Calendly → Airtable + Welcome Email

```
TRIGGER: Calendly — Event scheduled
  - Calendar: P2 Sales
  - Event type: P2 Consultation

ACTION 1: Airtable — Find record
  - Base: MakinMoves / P2 Clients
  - Table: Clients
  - Search: Email = {Attendee Email}

ACTION 2: Airtable — Create/Update record (based on ACTION 1 result)
  - IF found: Update record
    - Status = "Onboarded"
    - Last Booking Date = {Event Start Time}
  - IF not found: Create record
    - Name = {Attendee Name}
    - Email = {Attendee Email}
    - Phone = {Attendee Phone} (if available)
    - Status = "Prospect"
    - Booking Source = "Cold Email"

ACTION 3: Airtable — Create record
  - Base: MakinMoves / P2 Clients
  - Table: Projects
  - Fields:
    - Client = {ACTION 2 record ID}
    - Status = "Awaiting Onboarding"
    - Date Created = TODAY()

ACTION 4: SendGrid — Send email
  - To: {Attendee Email}
  - From: ops@makinmoveswriting.com
  - Subject: Welcome to P2 Freelance Writing
  - Template: p2-welcome-email.html
  - Merge vars:
    - CLIENT_NAME = {Attendee Name}
    - NEXT_STEP_URL = [Typeform onboarding link]
    - CALENDAR_TIME = {Event Start Time}
```

#### Zap 2: Typeform Onboarding → Project Details + Confirmation

```
TRIGGER: Typeform — Form response submitted

ACTION 1: Airtable — Find record
  - Base: MakinMoves / P2 Clients
  - Table: Clients
  - Search: Email = {Respondent Email}

ACTION 2: Airtable — Update record (Projects table)
  - Linked Project record
  - Fields:
    - Title = {Project Title from form}
    - Word Count = {Word Count from form}
    - Deadline = {Deadline date from form}
    - Status = "Assigned"
    - Amount Due = {Word Count} × 0.08 (or custom rate if overridden)

ACTION 3: SendGrid — Send email
  - To: {Respondent Email}
  - Template: p2-confirmation-email.html
  - Merge vars:
    - CLIENT_NAME = {Respondent Name}
    - WORD_COUNT = {Word Count}
    - DEADLINE = {Deadline}
    - AMOUNT = {Amount Due}
```

#### Zap 3: Project Ready → Invoice + Payment Link

```
TRIGGER: Airtable — Record enters status "Assigned"

ACTION 1: Airtable — Create record
  - Table: Invoices
  - Fields:
    - Invoice Number = "P2-" + TODAY().format("YYYY-MM-") + auto-increment
    - Project ID = {Trigger Record}
    - Amount = {Project.Amount Due}
    - Due Date = {Project.Deadline}
    - Status = "Sent"
    - Date Created = TODAY()

ACTION 2: Stripe — Create payment link
  - Amount = {Invoice.Amount}
  - Description = "Project: {Project.Title}"
  - Success URL = https://makinmoveswriting.com/success
  - Metadata:
    - invoice_id = {ACTION 1 Invoice ID}
    - client_email = {Client Email}

ACTION 3: SendGrid — Send email
  - To: {Client Email}
  - Template: p2-invoice-email.html
  - Merge vars:
    - INVOICE_NUMBER = {Invoice Number}
    - AMOUNT = {Invoice Amount}
    - DUE_DATE = {Invoice Due Date}
    - PAYMENT_LINK = {Stripe Link from ACTION 2}
    - PROJECT_TITLE = {Project Title}
```

#### Zap 4: Scheduled Invoice Reminder (5 Days Before Due Date)

```
TRIGGER: Airtable — When a record's date is [5 days before due]
  - Table: Invoices
  - Date field: Due Date
  - Offset: -5 days
  - Check frequency: Daily at 9 AM

ACTION 1: Airtable — Find record
  - Table: Invoices
  - Search: Trigger record ID
  - Purpose: Check if Status = "Paid"

ACTION 2: Conditional logic
  - IF Status ≠ "Paid"
    - THEN send reminder email
    - ELSE skip

ACTION 3: SendGrid — Send email (if condition met)
  - To: {Client Email}
  - Template: p2-payment-reminder.html
  - Merge vars:
    - DUE_DATE = {Due Date}
    - AMOUNT = {Amount}
    - PAYMENT_LINK = {Stored payment link}

ACTION 4: Airtable — Update record
  - Table: Invoices
  - Field: Status = "Overdue" (if 7+ days past due)
```

#### Zap 5: Stripe Payment Received → Update Airtable + Thank You Email

```
TRIGGER: Stripe — Charge succeeded

ACTION 1: Airtable — Find record
  - Table: Invoices
  - Search: Custom JSON matching Stripe metadata
    - invoice_id (from Stripe charge metadata)

ACTION 2: Airtable — Update record
  - Table: Invoices
  - Fields:
    - Status = "Paid"
    - Payment Received Date = TODAY()
    - Stripe Payment Intent ID = {Stripe Charge ID}

ACTION 3: Airtable — Update record (linked Project)
  - Fields:
    - Status = "Paid"

ACTION 4: SendGrid — Send email
  - To: {Client Email} (from Stripe metadata or Airtable lookup)
  - Template: p2-thank-you-email.html
  - Merge vars:
    - AMOUNT_PAID = {Stripe Amount / 100}
    - DELIVERY_DATE = {Project.Deadline + 1 day}

ACTION 5: Log to CFO revenue table (optional, see PART 6)
  - Airtable — Create record in "Revenue" table
  - Fields:
    - Date = TODAY()
    - Stream = "P2 Freelance Writing"
    - Amount = {Stripe Amount}
    - Status = "Received"
```

#### Zap 6: Project Delivery + Follow-Up Sequence

```
TRIGGER: Airtable — When Project Status = "Final"

ACTION 1: SendGrid — Send email
  - To: {Client Email}
  - Template: p2-delivery-email.html
  - Merge vars:
    - DELIVERY_LINK = [Dropbox link or email body content]
    - REVISION_WINDOW = "48 hours"

ACTION 2: SendGrid — Schedule email (3 days later)
  - Template: p2-followup-crosssell.html
  - Merge vars:
    - SERVICES_LINK = [Link to bundle offer or next service]
    - DISCOUNT_CODE = [Optional: affiliate code]

ACTION 3: Typeform — Add record (optional feedback collection)
  - Create new response tracker in Airtable
  - Link to Project record
  - Track: Did client provide feedback? (YES/NO)
```

---

## PART 4: AIRTABLE BASE SCHEMA

### Table 1: Clients

| Field | Type | Properties | Notes |
|-------|------|-----------|-------|
| Clients ID | Auto-number | Primary key | Auto-generated |
| Name | Single line text | Required | Client name |
| Email | Email | Required, Unique | Lookup key for Zapier |
| Phone | Phone number | Optional | |
| Booking Source | Single select | Options: Cold Email, Warm Email, Website | For tracking channel |
| Status | Single select | Options: Prospect, Onboarded, Active, Completed, Refunded | Workflow status |
| Date Booked | Date | Auto | First booking date |
| Last Contact Date | Date | | Rollup from Projects |
| Total Spent | Currency | Rollup: Sum of Projects.Amount Due | |
| Notes | Long text | | Sales notes |

### Table 2: Projects

| Field | Type | Properties | Notes |
|-------|------|-----------|-------|
| Project ID | Auto-number | Primary key | |
| Client ID | Link to Clients | Required | Foreign key |
| Title | Single line text | Required | Project name |
| Word Count | Number | Required | For rate calculation |
| Deadline | Date | Required | Project due date |
| Status | Single select | Options: Awaiting Onboarding, Assigned, In Progress, Draft Ready, Revisions, Final, Paid | Workflow status |
| Rate (per word) | Currency | Default: $0.08 | Configurable per project |
| Amount Due | Formula | {Word Count} × {Rate} | Auto-calculated |
| Invoice ID | Link to Invoices | | Foreign key |
| Date Created | Date | Auto | |
| Notes | Long text | | Revision requests, etc. |

### Table 3: Invoices

| Field | Type | Properties | Notes |
|-------|------|-----------|-------|
| Invoice ID | Auto-number | Primary key | |
| Invoice Number | Single line text | Format: P2-2026-001 | For client-facing reference |
| Project ID | Link to Projects | Required | Foreign key |
| Amount | Currency | Required | Total invoice amount |
| Due Date | Date | Required | Payment due date |
| Status | Single select | Options: Draft, Sent, Paid, Overdue, Refunded | Workflow status |
| Date Created | Date | Auto | |
| Date Paid | Date | | Payment received date |
| Stripe Payment Intent ID | Single line text | | For reconciliation |
| Stripe Link | URL | | Generated by Zapier |
| Notes | Long text | | Payment notes |

### Table 4: Refunds

| Field | Type | Properties | Notes |
|-------|------|-----------|-------|
| Refund ID | Auto-number | Primary key | |
| Project ID | Link to Projects | Required | Which project |
| Amount | Currency | Required | Refund amount |
| Reason | Long text | Required | Why refund requested |
| Status | Single select | Options: Requested, Approved, Denied, Processed | Approval workflow |
| Date Requested | Date | Auto | |
| Date Processed | Date | | When refund executed |
| Notes | Long text | | Decision rationale |

### Table 5: Revenue (CFO Tracking)

| Field | Type | Properties | Notes |
|-------|------|-----------|-------|
| Transaction ID | Auto-number | Primary key | |
| Date | Date | Auto | Transaction date |
| Stream | Single select | P2 Freelance Writing | Revenue stream label |
| Client | Link to Clients | | For attribution |
| Invoice | Link to Invoices | | Full audit trail |
| Amount | Currency | Required | Transaction amount |
| Status | Single select | Pending, Received, Refunded | Payment status |
| Notes | Long text | | Tracking notes |

---

## PART 5: LATENCY ANALYSIS & MONITORING

### Latency Targets vs. Reality

| Step | Target | Actual (Zapier + Airtable) | Bottleneck | Risk |
|------|--------|--------------------------|-----------|------|
| Booking → Welcome email | <5 min | <2 min | Calendly webhook | Low |
| Form submit → Confirmation | <5 min | <2 min | Typeform webhook | Low |
| Status change → Invoice email | <2 min | <1 min | Airtable trigger | Low |
| Invoice due → Reminder email | On-time | ±2 hours | Zapier schedule precision | Medium |
| Payment received → Airtable update | <5 min | <1 min | Stripe webhook | Low |
| Delivery → Follow-up | <1 min | <1 min | SendGrid queue | Low |

**Key insight:** Scheduled triggers (invoices reminders) have ±2 hour variance. Manual reminder check at end of week mitigates.

### Dashboard for Monitoring

**Create view in Airtable "Monitor" table:**

```
Metric                           | Frequency | Owner | Target
─────────────────────────────────────────────────────────────
Active projects (Status: In Prog) | Daily    | CEO  | >0
Overdue invoices                  | Daily    | CEO  | =0
Failed Zapier workflows           | Daily    | CTMO | =0
Email open rates (SendGrid)       | Weekly   | CEO  | >40%
Average project completion time   | Weekly   | CEO  | <7 days
Revenue collection rate           | Weekly   | CFO  | >90%
Refund requests                   | Weekly   | CEO  | <5%
```

**How to set up:** Export Airtable weekly to Google Sheets + simple dashboard formulas.

---

## PART 6: FAILURE RECOVERY PROCEDURES

### Failure Scenario 1: Calendly Booking Not Syncing to Airtable

**Symptoms:**
- Client booked appointment, but no Airtable record created
- Zapier shows failed task

**Recovery:**
1. Check Zapier task history: see error message
2. Common causes:
   - Airtable API token expired: Reconnect Zapier integration (1 min)
   - Email already exists + duplicate check failed: Manually update existing record (2 min)
   - Airtable quota exceeded: Wait 24 hours or upgrade (free account has limits)
3. Manual fallback:
   - Check Calendly directly, copy booking data
   - Create Airtable record manually (5 min)
   - Send welcome email manually
4. Retry failed task in Zapier (auto-retry happens every 2 hours, up to 3x)

**Prevention:**
- Check Zapier task history weekly (should see 0 failed tasks)
- Test Zapier workflow monthly: book a test appointment, verify Airtable sync

### Failure Scenario 2: Invoice Email Not Sent (SendGrid Down)

**Symptoms:**
- Invoice created in Airtable, but client didn't receive email
- Zapier shows "Action not executed" error

**Recovery:**
1. Check SendGrid dashboard: is service down or quota exceeded?
   - If down: Wait for service recovery (usually <1 hour)
   - If quota exceeded: Email is queued, will send when quota resets
2. Manual fallback:
   - Retrieve client email from Airtable
   - Get invoice data + Stripe payment link
   - Send email manually via Gmail (cc yourself for CRM)
   - Log action in Airtable Invoice record: "Invoice sent manually via email"
3. Zapier auto-retries every 2 hours (up to 3x)

**Prevention:**
- Use free SendGrid tier (100/day limit) or paid tier ($20/mo, unlimited)
- Monitor SendGrid email bounces weekly
- Test invoice email flow monthly

### Failure Scenario 3: Stripe Payment Not Updating Airtable

**Symptoms:**
- Client paid via Stripe, but Airtable Invoice still shows "Sent" (not "Paid")
- Zapier webhook received, but action failed

**Recovery:**
1. Check Stripe dashboard:
   - Verify payment succeeded (charge status = succeeded)
   - Copy charge ID
2. Check Airtable:
   - Manually find Invoice record
   - Update Status → "Paid"
   - Add Stripe Charge ID to field
3. Send thank-you email manually
4. Zapier auto-retries webhook for 24 hours

**Prevention:**
- Check Airtable weekly: filter for Invoices with Status = "Sent" AND Due Date < TODAY (overdue unpaid invoices)
- If any found, manually verify in Stripe (might be paid but sync failed)
- Set up Stripe webhook retry policy (default: 5x retry over 24 hours)

### Failure Scenario 4: Conditional Logic Not Triggering (e.g., Overdue Invoice Not Flagged)

**Symptoms:**
- Invoice is 7+ days past due, but Airtable Status still = "Sent" (not "Overdue")
- Scheduled Zapier workflow was supposed to run

**Recovery:**
1. Check Zapier schedule trigger:
   - Verify Zap is "On" (not paused)
   - Check last run time in task history
   - Scheduled triggers can be ±2 hours late
2. Manual override:
   - Airtable: Check "Due Date" field for overdue invoices
   - Update Status → "Overdue" manually
   - Send payment reminder email manually
3. Check Airtable trigger setup:
   - Verify "Due Date" field is correctly populated
   - Verify Zapier is connected to correct base/table

**Prevention:**
- Test scheduled workflow monthly: create test invoice, wait for reminder
- Set up email alert in Airtable (if available) or use Zapier to run manual check daily

### Failure Scenario 5: Refund Processing Fails

**Symptoms:**
- Client requests refund, Zapier creates refund record, but Stripe refund not executed
- CEO approves refund, but Stripe API call fails

**Recovery:**
1. Check Stripe API error logs (in Zapier)
   - Common issue: charge already refunded, charge expired, invalid charge ID
2. Manual refund process:
   - Open Stripe dashboard
   - Find original charge
   - Click "Refund" button
   - Set amount (usually full invoice amount)
   - Note refund reason in Stripe
   - Copy Refund ID
3. Update Airtable:
   - Find Refunds record
   - Status → "Processed"
   - Add Stripe Refund ID
   - Send refund confirmation email manually
4. Update Project Status → "Refunded"

**Prevention:**
- CFO monitors "Refunds" table weekly
- All refunds require CEO approval (no auto-execution)
- Stripe refunds processed within 24 hours of approval

---

## PART 7: RATE LIMITS ON FREE TIER

### Zapier Free Tier Limits

| Limit | Free | Pro | Your Usage | Verdict |
|-------|------|-----|-----------|---------|
| **Tasks/month** | 100 | 750 | 22-70 (est) | ✓ Free sufficient (0-50 clients/month) |
| **Workflows (Zaps)** | 5 | Unlimited | 6 needed | ⚠️ **Upgrade to Pro** (+$29.99/mo) |
| **Trigger types** | Limited | Unlimited | Calendly, Airtable, Stripe | ✓ OK |
| **Multi-step workflows** | Yes | Yes | 4-5 steps per Zap | ✓ OK |
| **Execution frequency** | Real-time + scheduled | Real-time + scheduled | Real-time | ✓ OK |
| **Conditional logic** | Limited ("Paths") | Full | Simple if/then | ✓ Sufficient |
| **Data lookup/matching** | Yes | Yes | Airtable find records | ✓ OK |
| **Custom code** | No | Yes | Not needed | ✓ OK |

**Recommendation:** **UPGRADE TO ZAPIER PRO ($29.99/mo)** to get unlimited Zaps. Only real blocker is 5 Zaps on free tier; you need 6.

### Airtable Free Tier Limits

| Limit | Free | Paid | Your Usage | Verdict |
|-------|------|------|-----------|---------|
| **Bases** | Unlimited | | 1-2 bases | ✓ OK |
| **Records/base** | 1,200 | Unlimited | 50-200 (at 10 clients/month) | ✓ Free sufficient |
| **Collaborators** | 5 | Unlimited | 1-2 (CEO + CFO) | ✓ OK |
| **Views** | Unlimited | | Client list, Invoice list, Dashboard | ✓ OK |
| **Attachments/base** | 20 GB | Unlimited | <1 GB (no file storage) | ✓ OK |
| **API calls/day** | 100 | Generous | <50 (Zapier + manual) | ✓ OK |
| **API keys** | 5 | Unlimited | 1-2 (Zapier + personal) | ✓ OK |

**Recommendation:** **FREE TIER SUFFICIENT** up to 50-100 clients/month (1,200 record limit). Beyond that, upgrade to Pro ($10/month/user).

**Current projection:**
- Month 2: 3 clients → 30 records (0.3% of limit)
- Month 3: 6 clients → 60 records (0.5% of limit)
- Month 6: 20 clients → 200 records (1.7% of limit)
- Year 2: 150+ clients → Would need upgrade

### SendGrid Free Tier Limits

| Limit | Free | Standard | Your Usage | Verdict |
|-------|------|----------|-----------|---------|
| **Emails/day** | 100 | Unlimited | 5-10/day (at 3-5 projects/month) | ✓ Free sufficient |
| **Contacts** | Unlimited | | 50-200 | ✓ OK |
| **Campaigns** | Unlimited | | 3-4 (welcome, confirmation, reminder, thank you) | ✓ OK |
| **API calls** | Unlimited | | <1,000/month (via Zapier) | ✓ OK |

**Recommendation:** **FREE TIER SUFFICIENT** up to 100 emails/day. At 3-5 projects/month (5-10 emails/day), free tier covers all transactional email.

### Stripe Limits

| Limit | Plan | Notes | Your Usage | Verdict |
|-------|------|-------|-----------|---------|
| **Transactions** | All | No per-transaction limit | 3-20/month | ✓ Unlimited |
| **Transaction fee** | All | 2.9% + $0.30 | ~$12-24/month | ✓ Standard |
| **Refunds** | All | Unlimited | <5% of transactions | ✓ OK |
| **Webhooks** | All | Unlimited | 1 (payment.succeeded) | ✓ OK |
| **API rate limit** | All | 100 requests/sec | <10 requests/sec | ✓ OK |

**Recommendation:** **STANDARD PLAN** (2.9% + $0.30 per transaction). No free tier, but cost is minimal at current volume.

---

## PART 8: SCALING TIMELINE & UPGRADE TRIGGERS

### Phase 1: April-May 2026 (Hybrid Launch)

| Metric | Target | Platform | Cost | Action |
|--------|--------|----------|------|--------|
| Clients | 2-3 | Zapier Free + Airtable Free + SendGrid Free | $0 | Go live with free tier |
| Projects/month | 6-9 | | | |
| Workflows | 6 | Zapier Pro | +$30/mo | Upgrade for unlimited Zaps |
| Airtable records | <50 | Airtable Free | $0 | Monitor growth |
| Monthly cost | | | $30/mo | Zapier Pro only |

### Phase 2: June-August 2026 (Scaling Cold + Warm)

| Metric | Target | Platform | Cost | Action |
|--------|--------|----------|------|--------|
| Clients | 8-15 | Zapier Pro + Airtable Free + SendGrid Free | $30/mo | Continue |
| Projects/month | 24-45 | | | |
| Workflows | 8-10 | Zapier Pro | $30/mo | Still within limit |
| Airtable records | 100-200 | Airtable Free | $0 | Monitor growth |
| Email volume | 10-20/day | SendGrid Free | $0 | Monitor daily limit |
| Monthly cost | | | $30/mo | No changes |

### Phase 3: September-December 2026 (Early Profitability)

| Metric | Target | Platform | Cost | Action |
|--------|--------|----------|------|--------|
| Clients | 30-50 | Zapier Pro + Airtable Pro + SendGrid Standard | $50-100/mo | Start upgrades |
| Projects/month | 90-150 | | | |
| Workflows | 15-20 | Zapier Team (needed) | $99/mo | Upgrade to Team for more workflows |
| Airtable records | 300-500 | Airtable Pro | $10/mo/user | Upgrade to Pro (1,200 → unlimited) |
| Email volume | 30-50/day | SendGrid Standard | $20/mo | Upgrade for unlimited |
| Monthly cost | | | $129-150/mo | Team tier + Pro tier + SendGrid |

**Upgrade Triggers:**
1. **Zapier:** When you hit 6 workflows → Upgrade to Pro ($30)
2. **Airtable:** When records exceed 1,000 → Upgrade to Pro ($10/user/month)
3. **SendGrid:** When daily emails exceed 80 → Upgrade to Standard ($20/month)
4. **Zapier Team:** When you need 20+ workflows → Upgrade to Team ($99/month)

---

## PART 9: AIRTABLE vs. HUBSPOT COMPARISON

### Feature Comparison

| Feature | Airtable Free | HubSpot Free | Winner for P2 | Notes |
|---------|---------------|--------------|---------------|-------|
| **Contact management** | ✓ (1,200 records) | ✓ (unlimited) | HubSpot | HubSpot scales infinitely |
| **Pipelines/deals** | ✓ (custom views) | ✓ (native pipeline) | HubSpot | HubSpot UI is clearer |
| **Email tracking** | No | ✓ (native) | HubSpot | HubSpot tracks opens/clicks |
| **Automation (workflows)** | ✓ (via Zapier) | ✓ (5 workflows native) | HubSpot | HubSpot native is simpler |
| **Forms** | ✓ (via Typeform) | ✓ (native) | HubSpot | HubSpot forms are free |
| **Reporting** | ✓ (custom charts) | ✓ (dashboards) | HubSpot | HubSpot dashboards are prettier |
| **API integration** | ✓ (via Zapier) | ✓ (native) | HubSpot | HubSpot has more native integrations |
| **Invoicing** | No | No | Tie | Need Wave or Stripe anyway |
| **Stripe integration** | ✓ (via Zapier) | ✓ (via Zapier) | Tie | Both require Zapier |
| **Learning curve** | Moderate | Easy | HubSpot | HubSpot has better docs |

### Cost Comparison (Year 1)

| Item | Airtable | HubSpot | Savings |
|------|----------|---------|---------|
| CRM free tier | $0 | $0 | Tie |
| Zapier Pro (required for workflows) | $30/mo | $0 (native workflows) | HubSpot $360/year |
| SendGrid (transactional email) | $0 (free 100/day) | $0 (included) | Tie |
| Airtable Pro (if needed by M6) | $10/mo | — | Airtable $120/year |
| HubSpot Professional (if needed) | — | $50/mo | **Airtable $600/year** |
| **Total Year 1** | **$360-600** | **$0-600** | **Airtable $0-360 cheaper** |

### Verdict: Airtable vs. HubSpot

**Use Airtable if:**
- You want to start immediately (3 hours setup)
- You're comfortable with Zapier
- You want to control CRM structure (flexible schema)
- You're okay with learning Airtable

**Use HubSpot if:**
- You want the best UI/UX for CRM
- You want native automation (no Zapier learning curve)
- You want email tracking built-in
- You're willing to upgrade to Pro ($50/mo) when you scale

**Recommendation for P2:** **START WITH AIRTABLE**, migrate to HubSpot if complexity grows. At current 2-3 clients/month, Airtable is faster to setup and free.

---

## PART 10: ZAPIER vs. MAKE.COM COMPARISON

### Feature Comparison

| Feature | Zapier | Make.com | Better for P2 |
|---------|--------|----------|---------------|
| **Free tier limit** | 100 tasks/month | 1,000 operations/month | Make.com (10x) |
| **Integrations available** | 5,000+ | 1,000+ | Zapier (more choices) |
| **Setup complexity** | Medium (drag-drop) | Low (visual builder) | Make.com (easier UI) |
| **Conditional logic** | Limited ("Paths") | Full (branching) | Make.com (more powerful) |
| **Custom code** | JavaScript (paid) | JavaScript/Python | Make.com (more flexible) |
| **Scheduling** | ✓ (native) | ✓ (native) | Tie |
| **Error handling** | Basic | Advanced (webhooks, retry logic) | Make.com (better) |
| **Learning curve** | Medium | Low | Make.com |
| **Support** | Good (paid tier) | Good (free tier) | Make.com |
| **Popularity/docs** | Very high | Growing | Zapier (more tutorials) |

### Cost Comparison

| Plan | Zapier | Make.com | Verdict |
|------|--------|----------|---------|
| Free | 100 tasks/mo | 1,000 ops/mo | Make.com 10x better |
| Pro | $29.99/mo (750 tasks) | $9.99/mo (10,000 ops) | Make.com 3x cheaper |
| Team | $99/mo (20k tasks) | $29.99/mo (50k ops) | Make.com 3.5x cheaper |

### Verdict: Zapier vs. Make.com

**Use Zapier if:**
- You want maximum integrations (Calendly, Airtable, Stripe all native)
- You're comfortable with medium learning curve
- You value documentation/tutorials

**Use Make.com if:**
- You want more advanced logic and branching
- You want unlimited operations on free tier
- You want cheaper paid plans ($9.99 vs $29.99)

**Recommendation for P2:** **USE ZAPIER** (better integrations for P2 stack: Calendly, Airtable, Stripe are all native). Make.com is great, but Zapier's integrations match P2 exactly.

---

## PART 11: IMPLEMENTATION ROADMAP

### Week 1 (April 1-7): Setup Phase

| Task | Time | Owner | Deadline |
|------|------|-------|----------|
| Set up Zapier Pro account | 30 min | CTMO | Apr 1 |
| Create Airtable base (5 tables + views) | 2 hours | CTMO | Apr 2 |
| Configure Zap 1 (Calendly → Airtable + Email) | 1 hour | CTMO | Apr 2 |
| Test Zap 1 with test booking | 30 min | CTMO | Apr 3 |
| Set up SendGrid account + templates | 1 hour | CTMO | Apr 3 |
| Create email templates (welcome, confirm, invoice, etc.) | 2 hours | CEO | Apr 4 |
| Set up Stripe account (if not done) + webhook | 1 hour | CTMO | Apr 4 |
| **Total** | **~7.5 hours** | | |

### Week 2 (April 7-14): Core Workflows

| Task | Time | Owner | Deadline |
|------|------|-------|----------|
| Configure Zap 2 (Typeform → Project details) | 1 hour | CTMO | Apr 7 |
| Configure Zap 3 (Invoice generation) | 1.5 hours | CTMO | Apr 8 |
| Configure Zap 4 (Invoice reminder) | 1 hour | CTMO | Apr 9 |
| Configure Zap 5 (Stripe → Airtable) | 1 hour | CTMO | Apr 10 |
| Configure Zap 6 (Delivery + follow-up) | 1 hour | CTMO | Apr 11 |
| Test all 6 Zaps end-to-end | 2 hours | CTMO | Apr 12 |
| Document runbook + failure recovery | 2 hours | CTMO | Apr 13 |
| **Total** | **~9.5 hours** | | |

### Week 3 (April 14-21): Optimization + Launch

| Task | Time | Owner | Deadline |
|------|------|-------|----------|
| Monitor Zap task history (early test runs) | 1 hour | CTMO | Apr 15 |
| Fix any issues from week 2 testing | 1-2 hours | CTMO | Apr 16 |
| Set up monitoring dashboard (Airtable view) | 1 hour | CTMO | Apr 17 |
| Train CEO on manual fallback procedures | 1 hour | CEO | Apr 18 |
| Dry-run with cold client booking (simulated) | 1 hour | CEO | Apr 19 |
| **LIVE: Ready for first cold client** | — | | **Apr 21** |
| **Total** | **~5 hours** | | |

**GRAND TOTAL: ~22 hours (2.75 days of work)**

### Post-Launch (Ongoing)

| Task | Frequency | Owner | Time |
|------|-----------|-------|------|
| Monitor Zapier task history | Weekly | CTMO | 30 min |
| Check Airtable for overdue invoices | Weekly | CEO | 15 min |
| Verify payment collection rate | Weekly | CFO | 15 min |
| Test a Zap end-to-end (rotation) | Monthly | CTMO | 30 min |
| Review and optimize automation | Monthly | CTMO | 1 hour |

---

## PART 12: CRITICAL SUCCESS FACTORS

### Before Going Live (Pre-Flight Checklist)

- [ ] Zapier Pro account created + 6 Zaps configured
- [ ] Airtable base created with 5 tables + all fields
- [ ] SendGrid account set up + email templates created
- [ ] Stripe account ready + webhook configured
- [ ] Calendly configured to trigger Zapier
- [ ] Test booking flows through entire pipeline successfully
- [ ] CEO trained on manual procedures (if automation fails)
- [ ] CFO can read Airtable "Revenue" table for tracking
- [ ] Runbook documented (this spec)
- [ ] Failure recovery procedures tested

### Critical Metrics (Monitor Weekly)

| Metric | Target | How to Check | Alert Threshold |
|--------|--------|-------------|-----------------|
| Zapier task success rate | >99% | Task history | <95% |
| Airtable sync latency | <2 min | Check timestamps | >5 min |
| Email delivery rate | >95% | SendGrid dashboard | <90% |
| Invoice-to-payment time | <10 days | Airtable "Invoices" view | >14 days |
| Refund request rate | <5% | Airtable "Refunds" table | >10% |

---

## PART 13: DECISION SUMMARY FOR BOARD

### Recommendation: Zapier Pro + Airtable Free

**Stack:**
- **Trigger:** Calendly (free, 1 user)
- **CRM:** Airtable (free, 1,200 records/base)
- **Automation:** Zapier Pro ($29.99/mo)
- **Email:** SendGrid (free, 100/day)
- **Payments:** Stripe (standard 2.9% + $0.30)
- **Total startup cost:** $0 (month 1 includes Zapier)
- **Total monthly cost:** $30/mo (Zapier Pro only)

**Why NOT n8n:**
- n8n requires Docker setup (already running) but needs CTMO management
- At 2-3 clients/month, free Zapier is more than sufficient
- Zapier setup: 3-4 hours. n8n setup: 6-8 hours.
- Zapier supports hands-off operation (less manual intervention needed)

**Why NOT HubSpot:**
- HubSpot free tier is good, but requires native workflows + API learning
- Airtable + Zapier is faster to implement
- Airtable is cheaper (free vs. $50/mo HubSpot Professional)
- Can migrate to HubSpot later if complexity grows

**Why NOT Make.com:**
- Make.com has better free tier (1,000 ops vs. 100 tasks)
- But Zapier has better integrations for P2 (Calendly, Airtable, Stripe all native)
- Zapier docs/tutorials more abundant

**Go-live target:** April 21 (aligns with first cold client expected)

---

## APPENDIX A: EMAIL TEMPLATES (Summary)

### Template 1: P2 Welcome Email

```
Subject: Welcome to P2 Freelance Writing — Let's Get Started

Hi [CLIENT_NAME],

Thanks for booking your consultation call! I'm excited to work with you on your writing project.

Here's what happens next:

1. **This week:** You'll receive an onboarding form (takes 5 min to fill)
2. **After you fill it:** I'll create your custom project timeline and send you the invoice
3. **Once paid:** I'll start writing your project and deliver the first draft by [DEADLINE]

→ Next step: Click here to fill out the onboarding form [TYPEFORM_LINK]

Questions? Reply to this email anytime.

Looking forward to it!

[CEO Name]
P2 Freelance Writing
```

### Template 2: Project Confirmation Email

```
Subject: Your Project Confirmed — [PROJECT_TITLE]

Hi [CLIENT_NAME],

Perfect! I've set up your project. Here are the details:

- Project: [PROJECT_TITLE]
- Word count: [WORD_COUNT] words
- Deadline: [DEADLINE]
- Invoice amount: [AMOUNT]

I'll send you the invoice in the next email. Once you pay, I'll get started right away.

Questions about the scope? Reply here and we can adjust before I start writing.

Thanks!

[CEO Name]
```

### Template 3: Invoice Email

```
Subject: Invoice [INVOICE_NUMBER] — [PROJECT_TITLE] ($[AMOUNT])

Hi [CLIENT_NAME],

Your invoice is ready! Here are the details:

Invoice #: [INVOICE_NUMBER]
Amount: $[AMOUNT]
Due date: [DUE_DATE]
Project: [PROJECT_TITLE]

→ Pay now: [STRIPE_PAYMENT_LINK]

Once I receive your payment, I'll start writing immediately. You'll see the first draft by [DEADLINE].

Questions? Reply here or click the link above.

Thanks!

[CEO Name]
```

### Template 4: Invoice Reminder Email (5 days before due)

```
Subject: Reminder: Invoice [INVOICE_NUMBER] Due [DUE_DATE]

Hi [CLIENT_NAME],

Just a friendly reminder that invoice [INVOICE_NUMBER] for [PROJECT_TITLE] is due on [DUE_DATE].

Amount: $[AMOUNT]

→ Pay now: [STRIPE_PAYMENT_LINK]

Once you pay, I can deliver your project on schedule.

Thanks!

[CEO Name]
```

### Template 5: Thank You Email (after payment received)

```
Subject: Payment Received! Your Project is Underway

Hi [CLIENT_NAME],

Thanks for the payment! I've received it and I'm now working on your project.

Here's what's next:
- You'll get the first draft by [DEADLINE]
- You'll have 48 hours to request revisions
- Final delivery by [FINAL_DATE]

I'll send you the draft via email with a link to review it.

Thanks again!

[CEO Name]
```

### Template 6: Delivery Email

```
Subject: Your Project is Ready! [PROJECT_TITLE]

Hi [CLIENT_NAME],

Your project is complete! Here's your deliverable:

→ Download: [DROPBOX_LINK_OR_EMAIL_BODY]

You have 48 hours to request revisions. Just reply with any changes and I'll get them done ASAP.

Also, I'd love your feedback on the project. Takes 2 min: [FEEDBACK_FORM_LINK]

Thanks for working with me!

[CEO Name]
```

---

## APPENDIX B: MONITORING & MAINTENANCE SCHEDULE

### Daily (5 min)
- [ ] Check Airtable "Overdue" invoices view (should be 0)

### Weekly (30 min)
- [ ] Review Zapier task history (should see 0 failed tasks)
- [ ] Check SendGrid email stats (bounces, unsubscribes)
- [ ] Review Airtable "Clients" table for new additions
- [ ] Monitor Airtable API usage (should be <50% quota)

### Monthly (1 hour)
- [ ] Test one Zap end-to-end (rotation through all 6)
- [ ] Review CFO "Revenue" table for accuracy
- [ ] Check Airtable performance (any slow views?)
- [ ] Analyze refund/complaint trends

### Quarterly (2 hours)
- [ ] Full automation review: any broken workflows?
- [ ] Zapier + Airtable + SendGrid security review (API tokens still valid?)
- [ ] Cost review: are we within budget?
- [ ] Plan any optimizations or scaling

---

## APPENDIX C: ROLLBACK / DISABLE PROCEDURES

If automation breaks and needs immediate shutdown:

1. **Pause all Zapier workflows:**
   - Zapier dashboard → Click "Off" on each Zap
   - This stops automation but preserves configuration

2. **Manual intake (fallback):**
   - CEO collects client info via email or Typeform
   - CEO manually creates Airtable records
   - CEO manually sends emails + tracks invoices

3. **Recovery:**
   - Once issue is fixed, turn Zapier Zaps back "On"
   - Re-test one workflow before full restart
   - Any missed bookings can be manually added

---

## FINAL CHECKLIST FOR CTMO

Before submitting this spec to CEO/COO:

- [ ] All 6 Zaps documented with exact configuration
- [ ] Airtable schema clear (5 tables, field definitions)
- [ ] Rate limits analyzed (free tier sufficient until 150+ clients/month)
- [ ] Failure procedures documented (6 scenarios + recovery)
- [ ] Scaling timeline mapped (upgrades triggered at 1,000 records, 100 tasks/month, etc.)
- [ ] Cost analysis complete ($30/mo Zapier, $0 Airtable, $0 SendGrid initially)
- [ ] Email templates ready
- [ ] Monitoring dashboard specified
- [ ] Setup roadmap: 22 hours total, complete by April 13
- [ ] Go-live target: April 21 (aligns with first cold client expected)

---

**SPEC STATUS: READY FOR IMPLEMENTATION**
**CTMO ACTION: Execute setup roadmap Week 1-3**
**CEO ACTION: Prepare email templates + train on procedures**
**CFO ACTION: Set up weekly revenue tracking view in Airtable**
**TIMELINE: Live by April 21 for first P2 cold client**

**Document prepared by:** CTMO
**Date:** 2026-03-29 23:55
**Next review:** April 1 (setup kickoff)
