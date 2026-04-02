# P2 Freelance Writing Automation: Technical Specification
## Implementation Guide for Zapier Pro + ConvertKit + HubSpot + Calendly + Stripe

**Date:** 2026-03-29 20:00
**Status:** Ready for COO/CTMO Execution
**Approval Required:** CEO (YES/NO on P2 stream) + CFO (Budget $50/mo Zapier Pro)

---

## Architecture Overview

```
Calendly (booking)
    ↓
    [Zap 1: Calendly → HubSpot Contact + ConvertKit Welcome]
    ↓
HubSpot (prospect contact + deal created)
    ↓
    [MANUAL: COO sends proposal via email link, client reviews]
    ↓
    [Zap 2: HubSpot Deal (approved) → Stripe Invoice Creation]
    ↓
Stripe (invoice created, payment link generated)
    ↓
    [MANUAL: Client pays via Stripe payment link]
    ↓
Stripe Webhook (payment.success)
    ↓
    [Zap 3: Stripe Payment → HubSpot Deal Status Update]
    [Zap 4: Stripe Payment → ConvertKit Delivery Timeline Email]
    [Zap 5: Stripe Payment → Asana Task Creation (if using Asana)]
    ↓
HubSpot (deal marked "Won")
ConvertKit (delivery email sent to client)
Asana/Notion (project created for delivery tracking)
    ↓
    [WEEKLY: Zap 6: Aggregation → CEO Report Email]
    ↓
CEO (receives weekly summary of bookings + revenue + active projects)
```

**Total Zaps Required:** 5-6 (depending on task manager choice)
**Free Tier Capacity:** 5 Zaps (insufficient; requires Pro)
**Pro Tier Capacity:** Unlimited (sufficient)

---

## Detailed Zap Specifications

### Zap 1: Calendly → HubSpot Contact + ConvertKit Email
**Trigger:** Calendly event scheduled
**Actions:** Create HubSpot contact + add tag + send ConvertKit email

**Setup Steps:**

1. **Trigger: Calendly → Event Scheduled**
   - Event calendar: [P2 Consultation calendar URL]
   - Fields extracted: name, email, phone, custom Q&A (rate expectation, project type)
   - Scheduling link: `calendly.com/[username]/p2-consultation-30min`

2. **Step 1: Create HubSpot Contact**
   - API: HubSpot contacts API
   - Mapping:
     ```
     firstName: {{Calendly First Name}}
     lastName: {{Calendly Last Name}}
     email: {{Calendly Email}}
     phone: {{Calendly Phone}}
     customProperty_projectType: {{Calendly Custom Q: "What type of writing?"}}
     customProperty_budgetRange: {{Calendly Custom Q: "Budget range?"}}
     lifecycleStage: "subscriber"  // or "lead"
     ```
   - Error handling: If contact exists, update instead (prevent duplicates)

3. **Step 2: Create HubSpot Deal**
   - API: HubSpot deals API
   - Mapping:
     ```
     dealname: "P2 Project - {{Contact Name}}"
     dealstage: "negotiation"  // or "qualification"
     amount: {{Calendly Custom Q: Budget}} (if provided)
     closedate: {{Calendly Event Time + 7 days}}  // expected close date
     properties: {
       contact_email: {{Contact Email}},
       contact_phone: {{Contact Phone}},
       project_description: {{Custom Q answer}}
     }
     ```

4. **Step 3: Add Tag to Contact**
   - API: HubSpot contacts API
   - Tag: "P2-prospect"
   - Allows filtering in HubSpot deals board

5. **Step 4: Send ConvertKit Email**
   - API: ConvertKit broadcasts or sequences (free tier = broadcasts)
   - Template: "P2 Welcome Email" (pre-created in ConvertKit)
   - Recipient: {{Contact Email}}
   - Subject: "Your P2 Freelance Writing Consultation Confirmed - {{Contact Name}}"
   - Content:
     ```
     Hi {{firstName}},

     Thanks for booking your P2 consultation on [date at time]!

     Here's what to expect:
     - 30-min discovery call to discuss your project
     - You'll tell me about deliverables, timeline, rate expectations
     - I'll provide a custom proposal and contract
     - If we move forward, we'll start immediately

     Looking forward to our call!

     [Your name]
     P2 Freelance Writer
     ```

**Zap Budget:** 1 of 5
**Setup Time:** 45 min
**Testing:** Send 1 test booking via Calendly; verify contact + email received

---

### Zap 2: HubSpot Deal Status Change → Stripe Invoice Creation
**Trigger:** HubSpot deal status changes to "proposal accepted"
**Actions:** Create Stripe invoice + send invoice link to client

**Setup Steps:**

1. **Trigger: HubSpot Deal Status**
   - Watch: deal stage changes
   - To stage: "proposal accepted" (you define this stage in HubSpot)
   - Filter: Only deals tagged "P2-prospect"

2. **Step 1: Create Stripe Invoice**
   - API: Stripe invoices endpoint
   - **WARNING:** Requires Zapier Pro (not available on free tier)
   - Mapping:
     ```
     customer_email: {{HubSpot Contact Email}}
     description: {{HubSpot Deal Name}}
     line_items: [
       {
         description: "{{HubSpot Custom Property: Project Description}}",
         amount_in_cents: {{HubSpot Deal Amount}} * 100,  // Convert $ to cents
         quantity: 1,
         currency: "usd"
       }
     ]
     due_date: {{Today + 7 days}}
     memo: "Due upon receipt. Payment via Stripe."
     custom_fields: {
       project_type: {{HubSpot Custom Property: Project Type}},
       delivery_timeline: {{HubSpot Custom Property: Delivery Date}}
     }
     ```
   - Error handling: Retry on rate limits (Stripe allows 100 req/sec)

3. **Step 2: Send Invoice to Client (via ConvertKit)**
   - API: ConvertKit broadcasts
   - Recipient: {{HubSpot Contact Email}}
   - Template: "P2 Invoice Ready"
   - Subject: "Your Invoice - {{HubSpot Deal Name}}"
   - Content:
     ```
     Hi {{firstName}},

     Your custom proposal has been approved! Here's your invoice:

     Invoice #: {{Stripe Invoice ID}}
     Amount: {{HubSpot Deal Amount}}
     Due date: {{Today + 7 days}}

     To pay: {{Stripe Invoice Payment Link}}

     Once payment is received, I'll send you the first deliverable.

     Questions? Reply to this email.
     ```

**Zap Budget:** 1 of 5 (Note: Could be split into 2 Zaps if Stripe invoice + email are separate)
**Setup Time:** 1 hour
**Testing:** Create test deal in HubSpot, change status to "proposal accepted", verify Stripe invoice created + email sent

**Important:** This is where Zapier Free breaks. Pro required for Stripe invoice action.

---

### Zap 3: Stripe Payment Received → HubSpot Deal Status
**Trigger:** Stripe payment received (webhook)
**Actions:** Update HubSpot deal status to "Won"

**Setup Steps:**

1. **Trigger: Stripe → Payment Received**
   - Event: payment_intent.succeeded
   - This webhook is automatically sent by Stripe when payment clears
   - Zapier listens on Stripe webhook endpoint

2. **Step 1: Update HubSpot Deal**
   - API: HubSpot deals API
   - Mapping:
     ```
     dealstage: "closedwon"  // Deal won!
     closedate: {{Today}}
     amount: {{Stripe Invoice Amount}} (if not already set)
     custom_properties: {
       payment_date: {{Today}},
       payment_method: "Stripe",
       stripe_invoice_id: {{Stripe Invoice ID}},
       stripe_payment_status: "paid"
     }
     ```
   - Lookup: Use Stripe invoice metadata (invoice.metadata.hubspot_deal_id) to find correct deal
   - **Prerequisite:** When creating Stripe invoice (Zap 2), add HubSpot deal ID to invoice metadata

3. **Error Handling:**
   - If deal not found: Log error to Zapier task history for CTMO review
   - Retry on HubSpot API timeout (max 3 retries)

**Zap Budget:** 1 of 5
**Setup Time:** 30 min
**Testing:** Create test Stripe invoice, process test payment, verify HubSpot deal status changes to "Won"

---

### Zap 4: Stripe Payment → Delivery Timeline Email
**Trigger:** Stripe payment received (same webhook as Zap 3)
**Actions:** Send delivery timeline email via ConvertKit

**Setup Steps:**

1. **Trigger: Stripe → Payment Received**
   - Same as Zap 3 (payment_intent.succeeded webhook)

2. **Step 1: Send Delivery Timeline Email**
   - API: ConvertKit broadcasts
   - Recipient: {{Stripe Customer Email}} (from payment metadata)
   - Template: "P2 Delivery Timeline"
   - Subject: "Payment Received - Your {{Project Type}} Project Timeline"
   - Content:
     ```
     Hi {{firstName}},

     Payment received! Your project is now active.

     Here's your delivery timeline:
     - Deliverable 1: {{Delivery Date 1}}
     - Deliverable 2: {{Delivery Date 2}}
     - [etc.]
     - Final delivery: {{Final Delivery Date}}

     You'll receive each deliverable via email. You can request revisions until final approval.

     I'll reach out by EOD tomorrow with the first draft.
     ```
   - Lookup: Pull delivery dates from HubSpot deal custom properties using customer email

**Zap Budget:** 1 of 5 (separate from Zap 3, as this is email-triggered)
**Setup Time:** 30 min
**Testing:** Same as Zap 3; verify delivery email sent after payment

**Note:** Zap 3 + Zap 4 both listen to same Stripe webhook, but perform different actions. Zapier allows multiple Zaps per trigger.

---

### Zap 5: Stripe Payment → Asana Task Creation
**Trigger:** Stripe payment received (webhook)
**Actions:** Create project + tasks in Asana for delivery tracking

**Setup Steps:**

1. **Trigger: Stripe → Payment Received**
   - Same webhook as Zap 3 & 4

2. **Step 1: Create Asana Project**
   - API: Asana projects API
   - **WARNING:** Requires Zapier Pro (not available on free tier)
   - Mapping:
     ```
     name: "{{Stripe Customer Name}} - {{Stripe Invoice Description}}"
     notes: "Client: {{Customer Email}}, Invoice: {{Invoice ID}}, Amount: {{Invoice Amount}}"
     team_id: {{Your Asana Team ID}} (set in Zapier action)
     ```

3. **Step 2: Create Deliverable Tasks**
   - API: Asana tasks API
   - For each deliverable (1-N):
     ```
     name: "Deliverable {{N}}: [description]"
     description: "Due: {{Delivery Date N}}, Approved: {{Approval Date N}}"
     assignee_id: {{Your Asana User ID}}
     due_on: {{Delivery Date N}}
     projects: {{Asana Project ID from Step 1}}
     custom_fields: {
       client_email: {{Customer Email}},
       project_type: {{HubSpot Project Type}}
     }
     ```
   - Repeat for each deliverable; use Zapier looping (Formatter → Create Table from Text)

4. **Error Handling:**
   - If Asana project creation fails: Log to Zapier history
   - Retry on rate limits

**Zap Budget:** 1 of 5 (Asana creation)
**Setup Time:** 1 hour
**Testing:** Trigger payment, verify Asana project + tasks created

**Note:** If using Notion instead of Asana:
- Notion integration also requires Zapier Pro
- Similar spec, but use Notion database API instead of Asana

---

### Zap 6: Weekly Reporting → CEO Dashboard Email
**Trigger:** Weekly schedule (every Monday 9 AM)
**Actions:** Aggregate Calendly + HubSpot + Stripe + Asana → CSV email to CEO

**Setup Steps:**

1. **Trigger: Schedule**
   - Frequency: Every Monday 9 AM (or your preferred day)
   - Timezone: {{Your timezone}}

2. **Step 1: Query Calendly API**
   - Get all bookings from past 7 days
   - Extract: Date, client name, duration, status (completed/scheduled)
   - Output: List of events

3. **Step 2: Query HubSpot API**
   - Get all deals with tag "P2-prospect" created in past 7 days
   - Extract: Deal name, stage, amount, close date
   - Group by stage (qualified, proposal, accepted, won, lost)

4. **Step 3: Query Stripe API**
   - Get all invoices + payments from past 7 days
   - Extract: Invoice ID, customer, amount, status (draft, sent, paid, failed)
   - Sum total revenue (paid invoices)

5. **Step 4: Query Asana API**
   - Get all projects created in past 7 days
   - Extract: Project name, task count, assigned to
   - On-time delivery status (tasks completed on schedule)

6. **Step 5: Format CSV**
   - Use Zapier Formatter step to create CSV from aggregated data
   - Format:
     ```
     P2 Weekly Report - [Date]

     Calendly Bookings (past 7 days):
     Date | Client | Duration | Status
     [rows from Step 1]

     HubSpot Deals (past 7 days):
     Deal Name | Stage | Amount | Close Date
     [rows from Step 2]

     Stripe Revenue (past 7 days):
     Invoice # | Customer | Amount | Status
     [rows from Step 3]
     Total Revenue: $[sum]

     Active Projects (Asana):
     Project | Tasks | Assigned | On-Time?
     [rows from Step 4]
     ```

7. **Step 6: Send Email to CEO**
   - API: Gmail or ConvertKit
   - Recipient: {{CEO email}}
   - Subject: "P2 Weekly Report - [Week of Date]"
   - Attachment: CSV file from Step 5

**Zap Budget:** 1 of 5 (weekly aggregation)
**Setup Time:** 1.5 hours (complex queries + formatting)
**Testing:** Run manually once to verify data aggregation + formatting

**Alternative (Free Tier Hack):** If not using Zapier Pro:
- Remove Asana query (Step 4)
- Remove database aggregation
- Just email CSV of Calendly + HubSpot + Stripe bookings/deals/revenue
- COO manually pastes into Google Sheets for CEO view
- **Not ideal, but technically possible on free tier**

---

## ConvertKit Email Templates (To Be Pre-Created)

### Template 1: P2 Welcome Email
```
Subject: Your P2 Consultation Confirmed - {{firstName}}

Hi {{firstName}},

Thanks for booking your P2 consultation!

Appointment Details:
Date: [Calendar will auto-populate if using Zapier dynamic fields]
Time: [Auto-populated]
Duration: 30 min

What to expect:
- We'll discuss your writing project (scope, audience, timeline)
- I'll ask about your ideal deliverables and any special requirements
- We'll talk about rate expectations and next steps
- If we're a good fit, I'll send a custom proposal

Come prepared with:
- Project details (type, length, target audience)
- Your timeline and budget range
- Any examples of style/tone you like

See you soon!

[Your name]
P2 Freelance Writer
```

### Template 2: P2 Invoice Ready
```
Subject: Your Proposal Approved - Invoice Ready to Pay

Hi {{firstName}},

Great news! Your proposal has been approved, and your invoice is ready.

Invoice Details:
- Invoice #: {{invoice_id}}
- Amount: {{amount}}
- Due: {{due_date}}

To Pay:
[{{payment_link}}](payment link)

Once payment clears, I'll send you the first deliverable by {{first_delivery_date}}.

Questions? Reply to this email.

Looking forward to working with you!

[Your name]
```

### Template 3: P2 Delivery Timeline
```
Subject: Payment Received - Your Project Is Live!

Hi {{firstName}},

Payment confirmed! Your project is now active and I'm getting started.

Your Delivery Timeline:
- [Date 1]: Deliverable 1 ({{description}})
- [Date 2]: Deliverable 2 ({{description}})
- [Final Date]: Final delivery & approval

I'll deliver each item via email. You'll have time to request revisions before final approval.

First draft coming by [tomorrow/specific date].

Any questions before we kick off? Let me know!

[Your name]
```

---

## HubSpot Setup Checklist

### Contacts
- [ ] Standard properties: firstName, lastName, email, phone
- [ ] Custom properties (5 max in free tier):
  - `project_type` (text: "Article", "Ebook", "Blog Post", etc.)
  - `budget_range` (text: "$X-Y")
  - `delivery_date` (date)
  - `rate_negotiated` (number: final rate agreed)
  - `notes` (long text: any special requirements)

### Deals
- [ ] Deal pipeline stages:
  - Qualification (initial contact)
  - Negotiation (discussing terms)
  - Proposal Sent (waiting for approval)
  - Proposal Accepted (client approved, ready for invoice)
  - Contract Signed (optional, if using contracts)
  - Active (payment received, delivery in progress)
  - Closed Won (project complete)
  - Closed Lost (didn't move forward)
- [ ] Deal properties:
  - `dealname` (text)
  - `amount` (number: project value)
  - `closedate` (date: expected close)
  - `hubspotownerid` (owner: you)
  - Custom: `payment_received_date`, `stripe_invoice_id`, `stripe_payment_status`

### Automation
- [ ] Workflows: Not available on free tier; use Zapier instead
- [ ] Saved views: Filter by "P2-prospect" tag for quick access

---

## Stripe Configuration

### Invoice Setup
- [ ] Invoice defaults:
  - [ ] Logo/branding
  - [ ] Due date: 7 days from invoice date
  - [ ] Payment methods: Credit card + ACH
  - [ ] Metadata fields: Add custom field for `hubspot_deal_id` (so Zapier can link back)

### Webhook Configuration
- [ ] Event subscriptions:
  - [ ] `payment_intent.succeeded` (triggers Zap 3, 4, 5)
  - [ ] `invoice.payment_succeeded` (alternative trigger)
  - [ ] Endpoint: {{Zapier webhook URL}}

### Testing
- [ ] Use Stripe test mode (toggle in dashboard)
- [ ] Test card: 4242 4242 4242 4242 (exp any future date, any CVC)
- [ ] Verify webhook delivery in Stripe dashboard

---

## Calendly Configuration

### Calendar Setup
- [ ] Create new event type: "P2 Consultation - 30 min"
  - [ ] Duration: 30 min
  - [ ] Location: Video (Zoom/Google Meet auto-generated)
  - [ ] Invitee questions:
    - [ ] "What type of writing project are you interested in?" (required)
    - [ ] "What's your ideal budget range?" (required)
    - [ ] "Do you have any examples of style/tone you like?" (optional)
  - [ ] Confirmation: "Thank you for booking!"
  - [ ] Timezone: {{Your timezone}}
  - [ ] Hours available: [Your availability]

### Webhook Setup
- [ ] Enable webhooks in Calendly settings
- [ ] Subscribe to `scheduled_event.created` event
- [ ] Endpoint: {{Zapier webhook URL}}

### Testing
- [ ] Book a test event via your Calendly link
- [ ] Verify webhook is received in Zapier (check task history)

---

## Zapier Account Setup

### Prerequisites
- [ ] Upgrade to Zapier Pro ($50/month)
- [ ] Connect accounts:
  - [ ] Calendly (API key)
  - [ ] HubSpot (OAuth: allows data read/write)
  - [ ] ConvertKit (API key)
  - [ ] Stripe (OAuth: allows invoice creation + webhook access)
  - [ ] Asana (OAuth: allows project/task creation) [if using Asana]
  - [ ] Notion (OAuth: allows database write) [if using Notion]

### Zap Checklist
- [ ] Zap 1: Calendly → HubSpot + Email (✅ done)
- [ ] Zap 2: HubSpot → Stripe Invoice + Email (✅ done)
- [ ] Zap 3: Stripe → HubSpot Deal Update (✅ done)
- [ ] Zap 4: Stripe → Delivery Email (✅ done)
- [ ] Zap 5: Stripe → Asana Project (✅ done)
- [ ] Zap 6: Weekly Report Aggregation (✅ done)

### Error Handling
- [ ] Enable error alerts in Zapier (email on Zap failure)
- [ ] Monitor task history weekly (check for failed runs)
- [ ] Document any API rate limits encountered

---

## Testing Plan (COO + CTMO)

### Stage 1: Individual Zap Testing (30 min each)
1. **Zap 1 Test:**
   - Book a test event via Calendly
   - Verify HubSpot contact created
   - Verify welcome email sent
   - Check: Correct name, email, custom fields

2. **Zap 2 Test:**
   - Create test HubSpot deal
   - Mark stage "proposal accepted"
   - Verify Stripe invoice created
   - Verify invoice email sent
   - Check: Correct amount, due date, payment link

3. **Zap 3 & 4 Test:**
   - Process test Stripe payment (use test card)
   - Verify HubSpot deal marked "Won"
   - Verify delivery email sent
   - Check: Correct delivery dates, timeline

4. **Zap 5 Test:**
   - Trigger Asana project creation
   - Verify project + tasks created
   - Check: Correct project name, task descriptions, due dates

5. **Zap 6 Test:**
   - Run aggregation Zap manually (don't wait for Monday)
   - Verify CSV generated
   - Verify email sent to CEO
   - Check: Correct data, formatting, CSV attachment

### Stage 2: End-to-End Flow Testing (1 hour)
1. **Full Client Journey:**
   - Book real consulting call via Calendly
   - Receive welcome email
   - Approve proposal in HubSpot (stage change)
   - Receive invoice email
   - Process payment in Stripe
   - Verify all downstream automations trigger
   - Check Asana project created
   - Verify CEO receives weekly report

2. **Edge Cases:**
   - What if client books but doesn't show up? (deal → "lost")
   - What if payment fails? (Stripe webhook not received)
   - What if HubSpot contact already exists? (duplicate handling)
   - What if Asana is down? (error handling)

---

## Maintenance Checklist (Post-Launch)

### Weekly (Zapier)
- [ ] Check Zapier task history for errors
- [ ] Verify all 6 Zaps ran successfully
- [ ] Check email open/click rates for ConvertKit templates
- [ ] Review Stripe failed payments

### Monthly (Zapier + Integrations)
- [ ] Review Calendly bookings → confirm accurate data capture
- [ ] Audit HubSpot deals → verify deal lifecycle accuracy
- [ ] Check Asana projects → are deliverables tracking correctly?
- [ ] Review Stripe invoices → payment success rate

### Quarterly
- [ ] Evaluate P2 revenue vs. automation costs ($50/mo Zapier)
- [ ] Consider scaling: More Calendly calendars? Multiple team members?
- [ ] Assess: Should we move to n8n for unified platform?

---

## Fallback / Troubleshooting

**If Calendly webhook fails:**
- Manually copy booking details into HubSpot contact form
- Trigger remaining Zaps manually in HubSpot

**If Stripe invoice creation fails:**
- Create invoice manually in Stripe UI
- Copy payment link + email to client via ConvertKit broadcast
- Still triggers downstream Zaps (payment webhook) once paid

**If Asana integration goes down:**
- Zap will error (logged in Zapier)
- Create project manually in Asana
- COO tracks deliverables manually

**If HubSpot deal workflow breaks:**
- Manually update deal stage in HubSpot UI
- Stripe payment still triggers email + Asana task

---

## Cost & Timeline

**Setup Time:** 4-6 hours (all 6 Zaps + template creation + testing)
**Maintenance:** 15 min/week (monitor Zapier health + ConvertKit templates)
**Cost:** $50/month (Zapier Pro only; other tools are free tier)

**Revenue Potential (assuming 4 projects/month):**
- Avg project value: $1,500-3,000
- Monthly revenue: $6,000-12,000
- Zapier cost as % of revenue: 0.4%-0.8%

**ROI:** Automation saves 8+ hours/month manual work → $400+ value. Pays for itself 8x over.

---

**Status: Ready for implementation upon CEO approval**
**Timeline: Can be live by March 31, 2026**
**Next: CEO decides YES/NO on P2 revenue stream → CTMO builds Zaps**

