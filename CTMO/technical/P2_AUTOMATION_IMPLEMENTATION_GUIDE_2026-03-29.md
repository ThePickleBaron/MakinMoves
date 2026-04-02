# P2 Automation: Technical Implementation Guide
**Date:** 2026-03-29
**For:** CTMO (Implementation Checklist)
**Status:** Ready to execute upon CEO approval

---

## OVERVIEW

This document provides step-by-step technical instructions for implementing P2 Freelance Writing automation under each option. CTMO should follow the section corresponding to CEO's approved choice.

---

## PART 1: ZAPIER PRO IMPLEMENTATION (4-6 hours)

### Prerequisites Checklist
- [ ] Zapier account created (free tier exists)
- [ ] Zapier Pro account activated ($50/mo approved)
- [ ] HubSpot free tier account active
- [ ] Calendly account active
- [ ] Stripe account active & tested
- [ ] ConvertKit account active
- [ ] Asana or Notion account active

### Setup Timeline
```
Hour 0-1:   Install Zapier integrations + auth all platforms
Hour 1-2:   Build Flow 1 (Calendly → HubSpot + welcome email)
Hour 2-3:   Build Flow 2 (Proposal email → Stripe invoice + payment link)
Hour 3-4:   Build Flow 3 (Stripe payment → HubSpot + delivery + task)
Hour 4-5:   Build Flow 4 (Weekly reporting → CEO dashboard)
Hour 5-6:   Testing + QA + documentation
```

### Step 1: Zapier Integration Setup (30 min)

**Action 1.1: Authenticate Calendly**
```
1. In Zapier, click "Make a Zap"
2. Search for Calendly
3. Choose trigger: "Event Scheduled"
4. Click "Sign in with Calendly"
5. Complete OAuth authentication
6. Test connection
```

**Action 1.2: Authenticate HubSpot**
```
1. Search for HubSpot in Zapier
2. Click "Connect HubSpot account"
3. Select "HubSpot Free Tier" from dropdown
4. Complete OAuth
5. Test connection
```

**Action 1.3: Authenticate ConvertKit**
```
1. Search ConvertKit
2. Click "Sign in"
3. Paste API key (from ConvertKit settings → API)
4. Test connection
```

**Action 1.4: Authenticate Stripe**
```
1. Search Stripe
2. Click "Sign in"
3. Copy Stripe API key (from Stripe Dashboard → Developers → API Keys)
4. Paste into Zapier
5. Test connection
```

**Action 1.5: Authenticate Asana/Notion**
```
Choose one (Asana recommended):
- Asana: OAuth via "Sign in" button
- Notion: Internal integration token from Notion settings
```

### Step 2: Build Flow 1 - Calendly Booking → HubSpot (30 min)

**Zap Name:** "P2-Flow-1-Booking-to-HubSpot"

**Trigger Setup:**
```
1. Trigger: Calendly → "Event Scheduled"
2. Select Calendly event: (choose the P2 consultation event)
3. Test trigger (use mock data or recent event)
```

**Action 1: Create HubSpot Contact**
```
1. Action: HubSpot → "Create or Update Contact"
2. Map fields:
   - Email: {{ calendly.email }}
   - First Name: {{ calendly.first_name }}
   - Last Name: {{ calendly.last_name }}
   - Phone: {{ calendly.phone }}
   - Tags: prospect, P2-consultation
3. Test action
```

**Action 2: Send Welcome Email (ConvertKit)**
```
1. Action: ConvertKit → "Add Subscriber"
2. Map:
   - Email: {{ calendly.email }}
   - First Name: {{ calendly.first_name }}
   - Tag: P2-prospect
3. Test
```

**Zap Status:** TURN ON

---

### Step 3: Build Flow 2 - Proposal → Stripe Invoice (1 hour)

**Zap Name:** "P2-Flow-2-Proposal-to-Invoice"

**Trigger Setup:**
```
1. Trigger: Email → "New Email Matching Search"
2. Or: Manual trigger for testing (click "Test")
3. Alternative: Use ConvertKit tag (when COO tags email as "proposal-sent")
```

**Action 1: Create Stripe Invoice**
```
1. Action: Stripe → "Create Invoice"
2. Map:
   - Customer: (search by email from HubSpot)
   - Description: "P2 Freelance Writing Project - [Project Name]"
   - Amount: {{ manual input or HubSpot deal value }}
   - Currency: USD
   - Custom Fields: Include project timeline, deliverables
3. Test action
```

**Action 2: Get Payment Link**
```
1. Action: Stripe → "Finalize Invoice"
2. Automatically generates shareable payment link
3. Format: https://invoice.stripe.com/i/...
```

**Action 3: Send Invoice via ConvertKit**
```
1. Action: ConvertKit → "Send Broadcast"
2. Map:
   - To: {{ calendly.email }}
   - Subject: "Your P2 Proposal & Invoice"
   - Body: Include project details + {{ stripe.payment_link }}
   - Template: (use COO's pre-written proposal template)
3. Test
```

**Zap Status:** TURN ON

---

### Step 4: Build Flow 3 - Payment Received → HubSpot + Delivery Task (45 min)

**Zap Name:** "P2-Flow-3-Payment-to-Delivery"

**Trigger Setup:**
```
1. Trigger: Stripe → "Invoice Paid"
2. Test trigger
```

**Action 1: Update HubSpot Deal**
```
1. Action: HubSpot → "Update Deal"
2. Find deal by: HubSpot deal ID or customer email
3. Set:
   - Deal Status: "Closed Won"
   - Deal Value: {{ stripe.amount }}
   - Closed Date: {{ stripe.date }}
4. Test
```

**Action 2: Create Asana Task**
```
1. Action: Asana → "Create Task"
2. Map:
   - Task Name: "Deliver P2 project for {{ customer.name }}"
   - Project: P2-Delivery
   - Assignee: {{ COO email }}
   - Due Date: {{ 14 days from today }}
   - Custom Fields: Customer name, project scope, payment amount
3. Test
```

**Action 3: Send Delivery Confirmation**
```
1. Action: ConvertKit → "Send Broadcast"
2. Map:
   - To: {{ customer.email }}
   - Subject: "P2 Project Started - Delivery Timeline"
   - Body: (pre-written delivery confirmation + timeline)
3. Test
```

**Zap Status:** TURN ON

---

### Step 5: Build Flow 4 - Weekly Reporting (30 min)

**Zap Name:** "P2-Flow-4-Weekly-Report"

**Trigger Setup:**
```
1. Trigger: Schedule → "Every Monday at 9am"
2. Timezone: Your timezone
```

**Action 1: Query HubSpot Deals**
```
1. Action: HubSpot → "Search Deals"
2. Search criteria:
   - Status: "Closed Won" (this week)
3. Output: List of closed deals
```

**Action 2: Query Stripe Payments**
```
1. Action: Stripe → "Search Invoices"
2. Filter: Paid in last 7 days
3. Output: Total revenue, number of transactions
```

**Action 3: Create Reporting Email**
```
1. Action: Gmail → "Send Email"
2. Map:
   - To: CEO email
   - Subject: "P2 Weekly Report - {{ date }}"
   - Body (formatted):
     ```
     This Week's P2 Metrics:
     - New bookings: {{ calendly.count }}
     - Proposals sent: {{ flow2.count }}
     - Revenue collected: ${{ stripe.total_amount }}
     - Active projects: {{ asana.task_count }}
     ```
3. Test
```

**Zap Status:** TURN ON

---

### Step 6: Testing & QA (1 hour)

**Test Each Flow:**
```
Flow 1 Test:
  1. Create test booking in Calendly
  2. Verify HubSpot contact created
  3. Check ConvertKit email sent

Flow 2 Test:
  1. Manually trigger (use "Test")
  2. Verify Stripe invoice created
  3. Check payment link in email

Flow 3 Test:
  1. Make test payment in Stripe (use test mode)
  2. Verify HubSpot deal updated
  3. Check Asana task created
  4. Check delivery email sent

Flow 4 Test:
  1. Run manually (click "Test")
  2. Verify email sent to CEO
```

**Documentation:**
- [ ] Screenshot all Zap configurations
- [ ] Document trigger/action mapping
- [ ] Create runbook for troubleshooting

---

## PART 2: n8n HYBRID IMPLEMENTATION (12-16 hours)

### Prerequisites
- [ ] n8n Cloud account active ($50/mo)
- [ ] All tool integrations available (HubSpot, Calendly, Stripe, etc.)
- [ ] n8n workflow environment ready

### Setup Timeline
```
Hour 0-2:   Design workflow architecture (map flows)
Hour 2-6:   Build Flow 1-2 (booking + proposal)
Hour 6-10:  Build Flow 3 (payment + sync)
Hour 10-14: Build Flow 4 (reporting) + error handling
Hour 14-16: Testing + documentation + runbook
```

### Step 1: Workflow Architecture Design (2 hours)

**Define n8n Nodes:**

```
Workflow 1: P2-Flow-1-Booking
  Node 1: Calendly Webhook (trigger)
  Node 2: HTTP Request → HubSpot API (create contact)
  Node 3: Merge (combine data)
  Node 4: ConvertKit Email Node (send welcome)
  Node 5: Webhook Response (confirm)

Workflow 2: P2-Flow-2-Proposal
  Node 1: Manual Trigger (COO sends proposal)
  Node 2: HubSpot Lookup (find customer)
  Node 3: Stripe Create Invoice (API call)
  Node 4: Stripe Get Payment Link (extract URL)
  Node 5: Gmail Send (send invoice email)

Workflow 3: P2-Flow-3-Payment
  Node 1: Stripe Webhook (payment.succeeded)
  Node 2: HubSpot Update Deal (API call)
  Node 3: Asana Create Task (API call)
  Node 4: ConvertKit Send Email (delivery confirmation)

Workflow 4: P2-Flow-4-Reporting
  Node 1: Cron Trigger (Monday 9am)
  Node 2: HubSpot Query Deals (API)
  Node 3: Stripe Query Invoices (API)
  Node 4: Function Node (format report)
  Node 5: Gmail Send (to CEO)
```

### Step 2: Implement Workflow 1 (Booking) (2 hours)

**Node Setup:**

```javascript
// Node 1: Calendly Webhook
Trigger Type: Webhook
URL: {{ n8n generates URL }}
Method: POST
Body parser: JSON

// Node 2: HubSpot API Call
Type: HTTP Request
Method: POST
URL: https://api.hubapi.com/crm/v3/objects/contacts
Headers:
  Authorization: Bearer {{ HUBSPOT_API_KEY }}
  Content-Type: application/json

Body:
{
  "properties": {
    "email": "{{ $node.Calendly.json.email }}",
    "firstname": "{{ $node.Calendly.json.first_name }}",
    "lastname": "{{ $node.Calendly.json.last_name }}",
    "phone": "{{ $node.Calendly.json.phone }}",
    "hs_lead_status": "PROSPECT"
  }
}

// Node 3: ConvertKit Email
Type: Function (custom JS)
Code:
return {
  email: "{{ $node.Calendly.json.email }}",
  subject: "Welcome to P2",
  body: `Hi {{ $node.Calendly.json.first_name }}, thanks for booking!`
};
```

### Step 3: Implement Workflow 2 (Proposal → Invoice) (2 hours)

```javascript
// Node 1: Manual Trigger
Wait for user to click "Execute Workflow"

// Node 2: HubSpot Lookup
HTTP POST to /crm/v3/objects/contacts/search
Body:
{
  "filterGroups": [
    {
      "filters": [
        {
          "propertyName": "email",
          "operator": "EQ",
          "value": "{{ $node.ManualTrigger.json.email }}"
        }
      ]
    }
  ]
}

// Node 3: Stripe Invoice Creation
HTTP POST to https://api.stripe.com/v1/invoices
Headers: Authorization: Bearer {{ STRIPE_API_KEY }}
Body:
{
  "customer": "{{ $node.HubSpot.json.results[0].id }}",
  "description": "P2 Project - {{ $node.ManualTrigger.json.project_name }}",
  "collection_method": "send_invoice"
}

// Node 4: Extract Payment Link
Function Node:
return {
  invoice_id: "{{ $node.Stripe.json.id }}",
  payment_link: "https://invoice.stripe.com/i/..." // Stripe generates
};

// Node 5: Gmail Send
Uses Gmail SMTP:
To: {{ $node.ManualTrigger.json.email }}
Subject: "Your P2 Invoice"
Body: HTML template with {{ payment_link }}
```

### Step 4: Implement Workflow 3 (Payment) (2 hours)

```javascript
// Node 1: Stripe Webhook
Trigger: payment_intent.succeeded
Webhook URL: {{ n8n generates }}

// Node 2: HubSpot Update
HTTP PATCH /crm/v3/objects/deals/{{ deal_id }}
Body:
{
  "properties": {
    "dealstage": "closedwon",
    "amount": "{{ $node.Stripe.json.amount }}"
  }
}

// Node 3: Asana Task
HTTP POST https://api.asana.com/1.0/tasks
Body:
{
  "data": {
    "name": "Deliver P2 for {{ customer_name }}",
    "projects": ["{{ ASANA_PROJECT_ID }}"],
    "assignee": "{{ COO_ASANA_ID }}",
    "due_on": "{{ add 14 days }}"
  }
}

// Node 4: ConvertKit Email
Same structure as Workflow 1
```

### Step 5: Implement Workflow 4 (Reporting) (2 hours)

```javascript
// Node 1: Cron Trigger
Schedule: 0 9 * * 1 (Monday 9am)

// Node 2: HubSpot Query
HTTP GET /crm/v3/objects/deals
Query: filterGroups[0][filters][0][propertyName]=dealstage&value=closedwon
Filter by date (this week)

// Node 3: Stripe Query
HTTP GET https://api.stripe.com/v1/invoices
Query: created[gte]={{ week_start_timestamp }}&status=paid

// Node 4: Format Report (Function Node)
function formatReport() {
  const deals = $node.HubSpot.json.results;
  const invoices = $node.Stripe.json.data;

  return {
    bookings: deals.length,
    revenue: invoices.reduce((sum, inv) => sum + inv.amount_paid, 0),
    html: `<h2>P2 Weekly Report</h2>
           <p>Revenue: $${revenue}</p>
           <p>Projects: ${deals.length}</p>`
  };
}

// Node 5: Gmail Send
To: CEO email
Subject: "P2 Weekly Report - {{ DATE }}"
Body: {{ $node.Format.json.html }}
```

### Step 6: Deploy & Test (2 hours)

```
[ ] Activate all workflows
[ ] Test each trigger (manual + webhook)
[ ] Verify data flows correctly
[ ] Check error handling
[ ] Document API endpoints used
[ ] Create runbook for troubleshooting
```

---

## PART 3: MAKE.COM IMPLEMENTATION (6-8 hours)

### Prerequisites
- [ ] Make.com account created (free tier or paid $10/mo)
- [ ] All integrations authorized (HubSpot, Calendly, Stripe)

### Setup Timeline
```
Hour 0-1:   Create Make.com scenarios (workflows)
Hour 1-3:   Build Flow 1-2 (booking + proposal)
Hour 3-5:   Build Flow 3 (payment)
Hour 5-7:   Build Flow 4 (reporting) + testing
Hour 7-8:   Documentation
```

### Step 1: Create Scenario 1 - Booking (1 hour)

**In Make.com:**
```
1. Click "Create new scenario"
2. Name: "P2-Flow-1-Booking"

3. Add Trigger: Calendly → "Watch Events"
   - Select event: P2 Consultation
   - Test: Click "Run once"

4. Add Module: HubSpot → "Create a Contact"
   - Email: {{ Calendly.email }}
   - First Name: {{ Calendly.first_name }}
   - Last Name: {{ Calendly.last_name }}
   - Tags: prospect, P2

5. Add Module: ConvertKit → "Add Subscriber"
   - Email: {{ Calendly.email }}
   - Name: {{ Calendly.first_name }}

6. Test entire scenario
7. Click "Activate"
```

### Step 2: Create Scenario 2 - Proposal (1.5 hours)

```
1. Create new scenario: "P2-Flow-2-Proposal"

2. Add Trigger: Manual (user executes)
   - Inputs: email, project_name, amount

3. Add Module: Stripe → "Create Invoice"
   - Customer Email: {{ manual.email }}
   - Description: "{{ manual.project_name }}"
   - Amount: {{ manual.amount }}

4. Add Module: Gmail → "Send Email"
   - To: {{ manual.email }}
   - Subject: "Your P2 Invoice"
   - Body: Include {{ stripe.invoice_url }}

5. Test and activate
```

### Step 3: Create Scenario 3 - Payment (1.5 hours)

```
1. Create scenario: "P2-Flow-3-Payment"

2. Add Trigger: Stripe → "Watch Invoice Events"
   - Event: Invoice paid

3. Add Module: HubSpot → "Update a Deal"
   - Deal ID: (search by email)
   - Stage: Closed Won
   - Amount: {{ stripe.amount }}

4. Add Module: Asana → "Create a Task"
   - Task Name: "Deliver P2 for {{ customer.name }}"
   - Project: P2-Delivery
   - Assignee: COO email

5. Add Module: Gmail → "Send Email"
   - To: {{ stripe.customer_email }}
   - Subject: "P2 Project Started"

6. Test and activate
```

### Step 4: Create Scenario 4 - Reporting (1 hour)

```
1. Create scenario: "P2-Flow-4-Reporting"

2. Add Trigger: Schedule → "Every Monday 9am"

3. Add Module: HubSpot → "Search (Advanced)"
   - Object: Deals
   - Filter: Stage = Closed Won, Date this week

4. Add Module: Stripe → "Get Invoices"
   - Filter: Paid, created >= week start

5. Add Module: Aggregator
   - Aggregate: Revenue from Stripe
   - Sum amounts

6. Add Module: Gmail → "Send Email"
   - To: CEO email
   - Body: "Weekly P2 Revenue: ${{ total }}"

7. Test and activate
```

### Step 5: Testing & Documentation (1 hour)

```
[ ] Test each scenario
[ ] Verify integrations working
[ ] Document Make.com account settings
[ ] Create runbook
```

---

## PART 4: MANUAL HYBRID SETUP (2 hours)

### Setup Steps

1. **HubSpot Free Tier Automation (1 hour)**
   - Create contact form
   - Set up deal pipeline
   - Create automated email sequences

2. **Stripe Dashboard Setup (30 min)**
   - Create P2 product in Stripe
   - Enable payment links
   - Set up email notifications

3. **Calendly Integration (15 min)**
   - Link to HubSpot contacts
   - Auto-create HubSpot deals

4. **COO Manual Steps Documentation (15 min)**
   - Invoice creation: 5 min per project
   - Task creation: 5 min per project
   - Weekly reporting: 15 min/week

### Monthly Maintenance
- COO spends ~4 hours/month on manual tasks
- Financial cost: ~$200/mo in labor (at $50/hr)
- Revenue loss from friction: ~$2,000+/mo

---

## DEPLOYMENT CHECKLIST (ALL OPTIONS)

Once implementation is complete:

- [ ] All integrations authenticated and tested
- [ ] Workflows trigger correctly on test data
- [ ] Data flows to all downstream systems
- [ ] Error handling configured (notifications if failure)
- [ ] Documentation complete (runbooks + screenshots)
- [ ] COO trained on workflow (how to use + troubleshoot)
- [ ] Monitoring configured (check logs daily)
- [ ] Fallback manual process documented (if automation breaks)

---

## TROUBLESHOOTING GUIDE

### Common Issues

**Problem:** Zapier/n8n/Make.com not triggering
**Solution:** Check webhook URLs, verify integrations authenticated, test manually

**Problem:** Invoice not creating in Stripe
**Solution:** Verify Stripe API key, check customer exists, ensure amount is valid

**Problem:** Email not sending
**Solution:** Check email template, verify recipient email valid, check spam folder

**Problem:** HubSpot contact not updating
**Solution:** Verify contact exists, check API key permissions, check field mapping

---

**Status: Ready for CTMO implementation**
**Timeline: 2-16 hours depending on chosen option**
**Next Step: CEO approves → CTMO begins implementation**
