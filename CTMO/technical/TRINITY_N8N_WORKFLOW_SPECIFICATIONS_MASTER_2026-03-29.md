# Trinity n8n Workflow Specifications — Complete Master Guide

**Date:** 2026-03-29
**Status:** Production-Ready Specifications
**Owner:** CTMO
**Build Duration:** 12-14 hours (all 5 workflows)
**Deployment Target:** Immediately after board approval

---

## Overview: Trinity's 5 Critical Automations

| # | Workflow | Trigger | Platform Chain | P-Level | Build Time |
|---|----------|---------|-----------------|---------|------------|
| 1 | **Gumroad Launch** | New product uploaded | Gumroad → DB → Email | P1 | 2h |
| 2 | **Client Intake Pipeline** | Calendly booking | Calendly → HubSpot → Wave → Email | P2 | 3h |
| 3 | **Payment Tracking** | Stripe webhook | Stripe → HubSpot → Email receipt | P2 | 2h |
| 4 | **Content Publishing** | WordPress post | WordPress → Affiliate inject → SEO → Email | P3 | 3h |
| 5 | **Affiliate Revenue** | Tracking pixel/API | Platform → DB → Alert | P3 | 2h |

**Total n8n task cost (estimated):** 150-200 tasks/month across all workflows

---

## WORKFLOW 1: P1 GUMROAD LAUNCH AUTOMATION

**Purpose:** Automate product detection, metadata extraction, database logging, and email notifications when new Gumroad products are uploaded.

**Trigger:** New Gumroad product uploaded (webhook or hourly poll)

**Build Duration:** 2 hours

### 1.1 Flow Diagram

```
┌─ Gumroad Webhook (Product Created)
│  └─ Payload: product_id, title, description, price, image_url
│
├─ Validate Webhook Signature (Security)
│
├─ Extract Metadata
│  ├─ Product title, description
│  ├─ Price (USD)
│  ├─ Product ID
│  └─ Image URL(s)
│
├─ PostgreSQL: Insert into digital_products table
│  └─ Store: product_id, title, description, price, status='launched', timestamp
│
├─ PostgreSQL: Update recovery_tracker
│  └─ potential_revenue += estimated_commission (if affiliate)
│
├─ Gmail: Send COO notification
│  ├─ Subject: "New Gumroad Product: [Title]"
│  ├─ Body: Product details, link to dashboard
│  └─ CTA: "Review & market" link
│
├─ PostgreSQL: Insert analytics_event
│  └─ Log: gumroad_product_launch, timestamp, product_id
│
└─ Response: 200 OK to Gumroad
```

### 1.2 Pseudo-Code (Human-Readable Logic)

```javascript
function onGumroadProductCreated(webhook_payload) {
  // STEP 1: Validate webhook signature
  if (!isValidGumroadSignature(webhook_payload)) {
    return { status: 400, error: "Invalid signature" };
  }

  // STEP 2: Parse webhook data
  const product = {
    gumroad_id: webhook_payload.product.id,
    title: webhook_payload.product.name,
    description: webhook_payload.product.description,
    price_usd: webhook_payload.product.price,
    url: webhook_payload.product.url,
    license_key: webhook_payload.product.license_key,
    created_at: webhook_payload.created_at
  };

  // STEP 3: Insert into PostgreSQL
  const insertResult = db.insert("digital_products", {
    gumroad_id: product.gumroad_id,
    title: product.title,
    description: product.description,
    price_usd: product.price_usd,
    gumroad_url: product.url,
    status: "launched",
    created_at: product.created_at,
    metadata: { license_key: product.license_key }
  });

  // STEP 4: Update recovery tracker
  const estimatedRevenue = product.price_usd * 0.5; // Conservative estimate
  db.updateRecoveryTracker({
    potential_revenue: estimatedRevenue,
    products_launched: +1
  });

  // STEP 5: Send notification to COO
  email.send({
    to: "coo@makinmoves.io",
    subject: `New Gumroad Product: ${product.title}`,
    html: `
      <h2>${product.title}</h2>
      <p><strong>Price:</strong> $${product.price_usd}</p>
      <p><strong>URL:</strong> <a href="${product.url}">${product.url}</a></p>
      <p>${product.description}</p>
      <p><a href="https://gumroad.com/dashboard">View in Gumroad Dashboard</a></p>
    `
  });

  // STEP 6: Log event
  db.insert("analytics_events", {
    event_type: "gumroad_product_launch",
    product_id: product.gumroad_id,
    timestamp: NOW()
  });

  // STEP 7: Return success
  return { status: 200, message: "Product logged", product_id: insertResult.id };
}
```

### 1.3 n8n Node Specifications

**Node 1: Webhook Trigger (Gumroad)**
```json
{
  "type": "webhook",
  "operation": "listen",
  "name": "Gumroad - Product Created",
  "webhookPath": "/gumroad/product-created",
  "httpMethod": "POST",
  "authentication": "headerAuth",
  "headerName": "X-Gumroad-Signature",
  "headerValue": "$env.GUMROAD_WEBHOOK_SECRET"
}
```

**Node 2: Code - Validate & Parse Webhook**
```javascript
// Input: Webhook payload from Gumroad
// Output: Validated product data

const payload = $input.json.body;

// Validate required fields
if (!payload.product || !payload.product.id || !payload.product.name) {
  throw new Error('Missing required product fields');
}

// Parse product metadata
const product = {
  gumroad_id: payload.product.id,
  title: payload.product.name,
  description: payload.product.description || '',
  price_usd: parseFloat(payload.product.price) || 0,
  gumroad_url: payload.product.url,
  license_key: payload.product.license_key,
  created_at: new Date(payload.created_at).toISOString()
};

// Estimate potential revenue
const estimated_revenue = product.price_usd * 0.5; // Conservative

return {
  product: product,
  estimated_revenue: estimated_revenue,
  timestamp: new Date().toISOString()
};
```

**Node 3: PostgreSQL - Insert Product**
```sql
INSERT INTO digital_products (
  gumroad_id,
  title,
  description,
  price_usd,
  gumroad_url,
  status,
  metadata,
  created_at,
  updated_at
) VALUES (
  '{{ $input.json.product.gumroad_id }}',
  '{{ $input.json.product.title }}',
  '{{ $input.json.product.description }}',
  {{ $input.json.product.price_usd }},
  '{{ $input.json.product.gumroad_url }}',
  'launched',
  '{"license_key": "{{ $input.json.product.license_key }}"}'::jsonb,
  '{{ $input.json.product.created_at }}',
  NOW()
)
RETURNING id, title, price_usd;
```

**Node 4: PostgreSQL - Update Recovery Tracker**
```sql
UPDATE recovery_tracker
SET
  potential_revenue = potential_revenue + {{ $input.json.estimated_revenue }},
  products_launched = products_launched + 1,
  updated_at = NOW()
WHERE goal_id = 'gumroad-recovery-goal'
RETURNING total_revenue, potential_revenue, products_launched;
```

**Node 5: Code - Build Email Body**
```javascript
const product = $input.json.product;
const estimatedRevenue = $input.json.estimated_revenue;

const emailHTML = `
<div style="font-family: Arial, sans-serif; max-width: 600px;">
  <h2>🚀 New Gumroad Product Launched</h2>

  <table style="width: 100%; border-collapse: collapse;">
    <tr style="background-color: #f5f5f5;">
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Title</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;">${product.title}</td>
    </tr>
    <tr>
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Price</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;">$${product.price_usd.toFixed(2)}</td>
    </tr>
    <tr style="background-color: #f5f5f5;">
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Est. Revenue (50% attach)</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;">$${estimatedRevenue.toFixed(2)}</td>
    </tr>
    <tr>
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>URL</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;"><a href="${product.gumroad_url}">${product.gumroad_url}</a></td>
    </tr>
  </table>

  <h3>Description</h3>
  <p>${product.description}</p>

  <p><a href="https://gumroad.com/dashboard" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">View in Gumroad Dashboard</a></p>

  <p style="color: #999; font-size: 12px;">Next: Market this product across social media & email list</p>
</div>
`;

return { email_html: emailHTML };
```

**Node 6: Gmail - Send Notification**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "{{ $env.COO_EMAIL }}",
  "cc": "{{ $env.CTMO_EMAIL }}",
  "subject": "🚀 New Gumroad Product: {{ $input.json.product.title }}",
  "html": "{{ $input.json.email_html }}"
}
```

**Node 7: PostgreSQL - Log Analytics Event**
```sql
INSERT INTO analytics_events (
  event_type,
  event_source,
  metadata,
  created_at
) VALUES (
  'gumroad_product_launch',
  'n8n_automation',
  '{"product_id": "{{ $input.json.product.gumroad_id }}", "price": {{ $input.json.product.price_usd }}}',
  NOW()
);
```

**Node 8: HTTP Response**
```json
{
  "statusCode": 200,
  "body": {
    "status": "success",
    "message": "Product logged and notifications sent",
    "product_id": "{{ $input.json.product.gumroad_id }}"
  }
}
```

### 1.4 Sample Test Data

```json
{
  "product": {
    "id": "ABC123DEF456",
    "name": "Email Marketing Automation Template",
    "description": "Pre-built Zapier workflow for ConvertKit email automation",
    "price": 29.99,
    "url": "https://gumroad.com/jsmcl/ABC123DEF456",
    "license_key": "GUMROAD-ABC123-DEF456"
  },
  "created_at": "2026-03-29T14:30:00Z"
}
```

**Expected outputs:**
- `digital_products` table: 1 new row inserted
- `recovery_tracker`: potential_revenue += $15 (50% of $29.99)
- Email sent to COO with product details
- `analytics_events` table: 1 event logged

### 1.5 Error Handling & Rollback

| Error | Detection | Rollback |
|-------|-----------|----------|
| **Invalid webhook signature** | Signature validation fails | Return 401, discard payload |
| **Missing product fields** | Parse error on product.id or name | Return 400, log error |
| **PostgreSQL insert fails** | DB connection timeout or constraint violation | Return 500, send CTMO alert |
| **Email send fails** | SMTP error | Retry 3x with exponential backoff (1s, 5s, 15s) |
| **Recovery tracker update fails** | DB constraint violation | Log error, continue (non-critical) |

**Failure Scenario 1: Database Unavailable**
```
1. PostgreSQL insert fails (connection timeout)
2. n8n catches error, retries 3x
3. On final failure, sends Slack alert: "CRITICAL: Gumroad DB sync failed"
4. Email to COO still sent (information is valuable even if DB fails)
5. Webhook returns 500 to Gumroad (Gumroad retries later)
6. Manual recovery: CTMO checks DB and re-runs workflow with saved webhook payload
```

**Failure Scenario 2: Invalid Signature**
```
1. Webhook arrives with invalid signature (possible attacker)
2. Validation node rejects
3. Returns 401 to Gumroad
4. No database insert (security)
5. No email sent
6. No logged event (security)
```

### 1.6 Testing Procedures

**Unit Tests (Per Node)**

1. **Webhook Validation**
   - Test with valid signature: Should pass ✓
   - Test with invalid signature: Should return 401 ✓
   - Test with missing fields: Should return 400 ✓

2. **Data Parsing**
   - Test with complete product object: Extract all fields ✓
   - Test with missing description: Should default to "" ✓
   - Test with non-numeric price: Should parse correctly ✓

3. **Database Insert**
   - Test insert: Row appears in digital_products ✓
   - Test with duplicate gumroad_id: Should fail (unique constraint) ✓
   - Test with null price: Should allow (nullable) ✓

4. **Email Sending**
   - Test with valid COO email: Email delivered ✓
   - Test with invalid COO email: Should return error ✓

**Integration Test (Full Workflow)**

```
Step 1: Prepare test webhook payload
  - Use sample data above

Step 2: Send webhook to n8n endpoint
  curl -X POST https://n8n.makinmoves.io/webhook/gumroad/product-created \
    -H "X-Gumroad-Signature: valid-secret" \
    -H "Content-Type: application/json" \
    -d '{ ... webhook payload ... }'

Step 3: Verify database entry
  SELECT * FROM digital_products
  WHERE gumroad_id = 'ABC123DEF456';

Step 4: Verify email sent
  Check COO inbox for "New Gumroad Product: Email Marketing..."

Step 5: Verify analytics logged
  SELECT * FROM analytics_events
  WHERE event_type = 'gumroad_product_launch'
  ORDER BY created_at DESC LIMIT 1;

Step 6: Verify recovery tracker updated
  SELECT potential_revenue, products_launched
  FROM recovery_tracker
  WHERE goal_id = 'gumroad-recovery-goal';

Expected: All 4 checks pass, n8n execution time < 5s
```

### 1.7 Monitoring & Alerting

**What to Track:**
- Webhook arrival rate (should be > 0 when products uploaded)
- Database insert success rate (target: 100%)
- Email send latency (target: < 5s)
- End-to-end execution time (target: < 10s)

**Alerts (Send Slack to #critical-alerts):**
- If webhook validation fails 3+ times in 1 hour → "SECURITY: Possible webhook tampering"
- If database insert fails 2+ times → "CRITICAL: Gumroad DB sync failure"
- If email send fails 3+ times → "WARNING: Email delivery issue"

**Monitoring Dashboard (In n8n):**
```
Daily Workflow Stats:
- Total webhooks processed: X
- Success rate: Y%
- Avg execution time: Z seconds
- Errors: N
- Last error: [timestamp]
```

### 1.8 Cost Estimate (n8n)

**Tasks Per Execution:**
1. Webhook trigger: 1 task
2. Validation + parsing: 1 task
3. PostgreSQL insert: 1 task
4. Recovery tracker update: 1 task
5. Email send: 1 task
6. Analytics log: 1 task
Total: **6 tasks per workflow execution**

**Estimated Monthly Cost:**
- Assume 10 new Gumroad products/month
- 10 products × 6 tasks = 60 tasks/month
- n8n free tier: 100 tasks/month → **Fits in free tier**

---

## WORKFLOW 2: P2 CLIENT INTAKE PIPELINE

**Purpose:** Automate the full client intake flow: Calendly booking → HubSpot contact creation → Wave invoice generation → Email with payment link → Payment tracking.

**Trigger:** Calendly booking confirmation

**Build Duration:** 3 hours

### 2.1 Flow Diagram

```
┌─ Calendly Webhook (Booking Created)
│  └─ Payload: invitee (name, email), event_type, scheduled_event
│
├─ Extract Booking Details
│  ├─ Client name, email, phone
│  ├─ Booking date/time
│  ├─ Event type (e.g., "Writing Consultation")
│  └─ Custom fields (project scope, budget)
│
├─ HubSpot: Create Contact
│  ├─ First name, email, phone
│  ├─ Property: "booking_source" = "calendly"
│  └─ Create associated Company (if new business)
│
├─ HubSpot: Create Deal
│  ├─ Deal name: "[Client Name] - [Project Type]"
│  ├─ Deal stage: "Awaiting Proposal"
│  ├─ Deal value: [from custom field or default]
│  └─ Owner: Assign to COO
│
├─ Wave: Create Invoice
│  ├─ Customer: [Create or link to existing]
│  ├─ Line items: [Consultation fee + scope details]
│  ├─ Due date: [14 days from booking]
│  └─ Payment terms: "Net 14"
│
├─ Wave: Get Stripe Payment Link
│  └─ Link generated for client payment
│
├─ Code: Build Email with Payment Link
│  ├─ Personalized greeting
│  ├─ Project summary
│  ├─ Invoice details
│  ├─ Payment link (Stripe)
│  └─ CTA: "Confirm booking by paying invoice"
│
├─ Gmail: Send to Client
│  ├─ Subject: "Your [Project Type] Consultation - Payment & Next Steps"
│  ├─ Body: [Email from previous step]
│  └─ Attachment: PDF invoice (if Wave provides)
│
├─ Gmail: Send to COO (Notification)
│  ├─ Subject: "New Client Booking: [Name]"
│  ├─ Body: Booking details, HubSpot link, invoice link
│  └─ CTA: "Review in HubSpot"
│
├─ PostgreSQL: Log Booking
│  └─ Insert: client_intakes table with all details
│
├─ Stripe Webhook Setup (Next workflow)
│  └─ Payment confirmed → Update HubSpot deal to "Proposal Sent"
│
└─ Response: 200 OK to Calendly
```

### 2.2 Pseudo-Code

```javascript
function onCalendlyBookingCreated(webhook_payload) {
  // STEP 1: Extract booking details
  const booking = {
    client_name: webhook_payload.invitee.name,
    client_email: webhook_payload.invitee.email,
    client_phone: webhook_payload.invitee.phone || '',
    booking_datetime: webhook_payload.scheduled_event.start_time,
    event_type: webhook_payload.scheduled_event.title,
    custom_fields: webhook_payload.invitee.custom_fields || {}
  };

  // STEP 2: Create HubSpot contact
  const hubspotContact = hubspot.contacts.create({
    email: booking.client_email,
    firstname: booking.client_name.split(' ')[0],
    lastname: booking.client_name.split(' ')[1] || '',
    phone: booking.client_phone,
    source: 'calendly',
    booking_date: booking.booking_datetime
  });

  // STEP 3: Create HubSpot deal
  const hubspotDeal = hubspot.deals.create({
    dealname: `${booking.client_name} - ${booking.event_type}`,
    dealstage: 'awaiting_proposal',
    amount: booking.custom_fields.budget || 500, // Default $500
    hubspot_owner_id: COO_HUBSPOT_ID,
    contact_id: hubspotContact.id
  });

  // STEP 4: Create Wave invoice
  const waveInvoice = wave.invoices.create({
    customer_id: booking.client_email, // Or create new customer
    line_items: [
      {
        description: `${booking.event_type} Consultation`,
        quantity: 1,
        unit_price: booking.custom_fields.budget || 500
      }
    ],
    due_date: addDays(today(), 14),
    payment_terms: 'NET_14'
  });

  // STEP 5: Generate payment link
  const stripePaymentLink = wave.stripe.generatePaymentLink(waveInvoice.id);

  // STEP 6: Build and send client email
  const emailBody = buildClientEmailWithPaymentLink(
    booking.client_name,
    booking.event_type,
    waveInvoice,
    stripePaymentLink
  );

  email.send({
    to: booking.client_email,
    subject: `Your ${booking.event_type} Consultation - Payment & Next Steps`,
    html: emailBody
  });

  // STEP 7: Send COO notification
  email.send({
    to: COO_EMAIL,
    subject: `New Client Booking: ${booking.client_name}`,
    html: buildCOONotificationEmail(booking, hubspotDeal, waveInvoice)
  });

  // STEP 8: Log in PostgreSQL
  db.insert('client_intakes', {
    client_name: booking.client_name,
    client_email: booking.client_email,
    event_type: booking.event_type,
    booking_datetime: booking.booking_datetime,
    hubspot_deal_id: hubspotDeal.id,
    wave_invoice_id: waveInvoice.id,
    stripe_payment_link: stripePaymentLink,
    status: 'awaiting_payment',
    created_at: NOW()
  });

  // STEP 9: Return success
  return {
    status: 200,
    message: 'Client intake created',
    hubspot_deal_id: hubspotDeal.id,
    invoice_id: waveInvoice.id,
    payment_link: stripePaymentLink
  };
}
```

### 2.3 n8n Node Specifications

**Node 1: Webhook Trigger (Calendly)**
```json
{
  "type": "webhook",
  "operation": "listen",
  "name": "Calendly - Booking Created",
  "webhookPath": "/calendly/booking-created",
  "httpMethod": "POST"
}
```

**Node 2: Code - Extract Booking Details**
```javascript
// Input: Calendly webhook payload
// Output: Normalized booking object

const payload = $input.json.body;
const invitee = payload.payload.invitee;
const event = payload.payload.scheduled_event;

// Parse custom fields
const customFields = {};
if (payload.payload.questions_and_answers) {
  payload.payload.questions_and_answers.forEach(qa => {
    customFields[qa.question] = qa.answer;
  });
}

const booking = {
  client_name: invitee.name,
  client_email: invitee.email,
  client_phone: invitee.phone || '',
  booking_datetime: event.start_time,
  booking_end_time: event.end_time,
  event_type: event.title,
  event_duration_minutes: event.duration_minutes || 60,
  custom_fields: customFields,
  calendly_event_id: event.event_uri
};

// Determine project scope and budget from custom fields
const budget = customFields['What is your budget?'] || 500;
const scope = customFields['Describe your project'] || 'Consultation';

return {
  booking: booking,
  budget: parseFloat(budget.replace('$', '')),
  scope: scope
};
```

**Node 3: HubSpot - Create Contact**
```json
{
  "type": "hubspot",
  "operation": "contacts.create",
  "properties": {
    "firstname": "{{ $input.json.booking.client_name.split(' ')[0] }}",
    "lastname": "{{ $input.json.booking.client_name.split(' ')[1] || '' }}",
    "email": "{{ $input.json.booking.client_email }}",
    "phone": "{{ $input.json.booking.client_phone }}",
    "hs_lead_status": "SUBSCRIBER",
    "source": "calendly"
  }
}
```

**Node 4: HubSpot - Create Deal**
```json
{
  "type": "hubspot",
  "operation": "deals.create",
  "properties": {
    "dealname": "{{ $input.json.booking.client_name }} - {{ $input.json.booking.event_type }}",
    "dealstage": "awaiting_proposal",
    "amount": {{ $input.json.budget }},
    "dealtype": "consultation",
    "hubspot_owner_id": "{{ $env.HUBSPOT_COO_OWNER_ID }}"
  },
  "associations": {
    "contact": "{{ $node['HubSpot - Create Contact'].json.id }}"
  }
}
```

**Node 5: Code - Prepare Wave Invoice Data**
```javascript
// Input: Booking details, budget
// Output: Invoice creation payload

const booking = $input.json.booking;
const budget = $input.json.budget;

const dueDate = new Date();
dueDate.setDate(dueDate.getDate() + 14); // 14 days from now

const invoiceData = {
  customer_email: booking.client_email,
  customer_name: booking.client_name,
  line_items: [
    {
      description: `${booking.event_type} - ${booking.scope || 'Consultation'}`,
      quantity: 1,
      unit_price: budget
    }
  ],
  due_date: dueDate.toISOString().split('T')[0],
  notes: `Thank you for booking your ${booking.event_type}. Please confirm payment to secure your spot.`,
  currency: 'USD'
};

return { invoice_data: invoiceData };
```

**Node 6: HTTP Request - Wave Create Invoice**
```json
{
  "type": "http",
  "method": "POST",
  "url": "https://api.waveapps.com/graphql",
  "authentication": "headerAuth",
  "headers": {
    "Authorization": "Bearer {{ $env.WAVE_API_KEY }}",
    "Content-Type": "application/json"
  },
  "body": {
    "query": "mutation { invoiceCreate(input: { customerId: \"...\", lineItems: [...] }) { invoice { id, invoiceNumber } } }"
  }
}
```

**Node 7: Code - Build Client Email**
```javascript
const booking = $input.json.booking;
const invoiceData = $input.json.invoice_data;
const budget = $input.json.budget;

const emailHTML = `
<div style="font-family: Arial, sans-serif; max-width: 600px;">
  <h2>Hi ${booking.client_name.split(' ')[0]},</h2>

  <p>Thanks for booking your <strong>${booking.event_type}</strong>!</p>

  <h3>Next Steps:</h3>
  <ol>
    <li><strong>Confirm Payment:</strong> Pay the invoice below to secure your booking</li>
    <li><strong>Our Meeting:</strong> Scheduled for ${new Date(booking.booking_datetime).toLocaleString()}</li>
    <li><strong>What to Expect:</strong> We'll discuss your project and create a proposal</li>
  </ol>

  <h3>Invoice Details</h3>
  <table style="width: 100%; border-collapse: collapse;">
    <tr style="background-color: #f5f5f5;">
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Description</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;">${invoiceData.line_items[0].description}</td>
    </tr>
    <tr>
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Amount Due</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>$${budget.toFixed(2)}</strong></td>
    </tr>
    <tr style="background-color: #f5f5f5;">
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Due Date</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;">${invoiceData.due_date}</td>
    </tr>
  </table>

  <p style="margin-top: 30px;">
    <a href="{{ $input.json.payment_link }}" style="background-color: #4CAF50; color: white; padding: 12px 30px; text-decoration: none; border-radius: 4px; font-weight: bold; display: inline-block;">
      Pay Invoice Now
    </a>
  </p>

  <p style="color: #999; font-size: 12px; margin-top: 30px;">
    Questions? Reply to this email or call us.
  </p>
</div>
`;

return { email_html: emailHTML };
```

**Node 8: Gmail - Send to Client**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "{{ $input.json.booking.client_email }}",
  "subject": "Your {{ $input.json.booking.event_type }} Consultation - Payment & Next Steps",
  "html": "{{ $input.json.email_html }}"
}
```

**Node 9: Code - Build COO Notification**
```javascript
const booking = $input.json.booking;
const hubspotDealId = $node['HubSpot - Create Deal'].json.id;
const budget = $input.json.budget;

const emailHTML = `
<div style="font-family: Arial, sans-serif; max-width: 600px;">
  <h2>📅 New Client Booking: ${booking.client_name}</h2>

  <h3>Client Info</h3>
  <ul>
    <li><strong>Name:</strong> ${booking.client_name}</li>
    <li><strong>Email:</strong> ${booking.client_email}</li>
    <li><strong>Phone:</strong> ${booking.client_phone || 'Not provided'}</li>
  </ul>

  <h3>Booking Details</h3>
  <ul>
    <li><strong>Event:</strong> ${booking.event_type}</li>
    <li><strong>Date/Time:</strong> ${new Date(booking.booking_datetime).toLocaleString()}</li>
    <li><strong>Duration:</strong> ${booking.event_duration_minutes} minutes</li>
    <li><strong>Budget:</strong> $${budget.toFixed(2)}</li>
  </ul>

  <h3>Quick Links</h3>
  <ul>
    <li><a href="https://app.hubspot.com/deals/${hubspotDealId}">View Deal in HubSpot</a></li>
    <li><a href="https://app.waveapps.com/invoices">View Invoice in Wave</a></li>
  </ul>

  <p style="color: #999; font-size: 12px;">
    Awaiting client payment. Invoice sent to ${booking.client_email}
  </p>
</div>
`;

return { email_html: emailHTML };
```

**Node 10: Gmail - Send to COO**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "{{ $env.COO_EMAIL }}",
  "subject": "📅 New Client Booking: {{ $input.json.booking.client_name }}",
  "html": "{{ $input.json.email_html }}"
}
```

**Node 11: PostgreSQL - Log Client Intake**
```sql
INSERT INTO client_intakes (
  client_name,
  client_email,
  client_phone,
  event_type,
  booking_datetime,
  budget_usd,
  hubspot_deal_id,
  wave_invoice_id,
  status,
  created_at
) VALUES (
  '{{ $input.json.booking.client_name }}',
  '{{ $input.json.booking.client_email }}',
  '{{ $input.json.booking.client_phone }}',
  '{{ $input.json.booking.event_type }}',
  '{{ $input.json.booking.booking_datetime }}',
  {{ $input.json.budget }},
  '{{ $node['HubSpot - Create Deal'].json.id }}',
  '{{ $node['Wave Create Invoice'].json.invoiceId }}',
  'awaiting_payment',
  NOW()
)
RETURNING id, client_name;
```

**Node 12: HTTP Response**
```json
{
  "statusCode": 200,
  "body": {
    "status": "success",
    "message": "Client intake created and email sent",
    "deal_id": "{{ $node['HubSpot - Create Deal'].json.id }}",
    "invoice_id": "{{ $node['Wave Create Invoice'].json.invoiceId }}"
  }
}
```

### 2.4 Sample Test Data

```json
{
  "payload": {
    "invitee": {
      "name": "Sarah Johnson",
      "email": "sarah@company.com",
      "phone": "+1-415-555-0123"
    },
    "scheduled_event": {
      "event_uri": "https://calendly.com/event/ABC123",
      "title": "Content Writing Consultation",
      "start_time": "2026-03-30T14:00:00Z",
      "end_time": "2026-03-30T15:00:00Z",
      "duration_minutes": 60
    },
    "questions_and_answers": [
      {
        "question": "What is your budget?",
        "answer": "$750"
      },
      {
        "question": "Describe your project",
        "answer": "Blog content for SaaS product launch"
      }
    ]
  }
}
```

**Expected outputs:**
- HubSpot: New contact and deal created
- Wave: New invoice generated
- PostgreSQL: Row inserted into client_intakes
- Emails: Sent to client (with payment link) and COO

### 2.5 Error Handling

| Error | Detection | Recovery |
|-------|-----------|----------|
| **Invalid email address** | Email format validation fails | Return 400, notify CTMO |
| **HubSpot API fails** | HTTP 4xx/5xx from HubSpot | Retry 3x, then create local-only entry |
| **Wave invoice creation fails** | HTTP error from Wave | Retry 3x, send manual invoice via email |
| **Email send fails** | SMTP error | Retry 3x, notify COO to send manually |
| **Webhook signature invalid** | Calendly signature check fails | Return 401, log security event |

**Critical Path:** If any step fails critically:
1. Log full details to PostgreSQL (`client_intake_errors` table)
2. Send Slack alert to #critical-alerts with recovery steps
3. CTMO reviews and re-triggers with corrected data

### 2.6 Testing Procedures

**Mock Calendly Webhook Test:**
```bash
curl -X POST https://n8n.makinmoves.io/webhook/calendly/booking-created \
  -H "Content-Type: application/json" \
  -d '{
    "payload": {
      "invitee": {
        "name": "Test Client",
        "email": "test@example.com",
        "phone": "+1-555-0000"
      },
      "scheduled_event": {
        "title": "Test Consultation",
        "start_time": "2026-04-01T10:00:00Z",
        "end_time": "2026-04-01T11:00:00Z"
      }
    }
  }'
```

**Verification Checklist:**
- [ ] HubSpot contact created (search by email)
- [ ] HubSpot deal created (visible in pipeline)
- [ ] Wave invoice generated (visible in Wave dashboard)
- [ ] Client email sent (check recipient inbox, verify payment link works)
- [ ] COO notification sent (check inbox)
- [ ] PostgreSQL entry created (query `client_intakes`)

### 2.7 Monitoring & Alerting

**Metrics to Track:**
- Booking → Email latency (target: < 30s)
- Invoice creation success rate (target: 100%)
- Email delivery success rate (target: > 99%)
- Payment confirmation within 7 days (target: 80%)

**Alerts:**
- If HubSpot fails 2+ times → Slack: "WARNING: HubSpot sync issue"
- If Wave fails 2+ times → Slack: "WARNING: Invoice creation issue"
- If email fails 3+ times → Slack: "CRITICAL: Email delivery failure"

### 2.8 Cost Estimate (n8n)

**Tasks Per Execution:**
1. Webhook: 1
2. Code (extract + build emails): 3
3. HubSpot create contact: 1
4. HubSpot create deal: 1
5. Wave invoice: 1
6. Gmail send (client): 1
7. Gmail send (COO): 1
8. PostgreSQL log: 1
Total: **10 tasks per workflow execution**

**Estimated Monthly Cost:**
- Assume 30 client bookings/month
- 30 × 10 = 300 tasks/month
- n8n free tier: 100 tasks → **Requires upgrade to paid ($50/mo)**
- OR: Use Zapier Pro ($50/mo) as alternative

---

## WORKFLOW 3: P2 PAYMENT TRACKING (STRIPE WEBHOOK)

**Purpose:** Capture Stripe payments, mark Wave invoices as paid, update HubSpot deal stage, send receipt emails.

**Trigger:** Stripe payment webhook (charge.succeeded)

**Build Duration:** 2 hours

### 3.1 Flow Diagram

```
┌─ Stripe Webhook (charge.succeeded)
│  └─ Payload: charge_id, amount, customer_email, description
│
├─ Validate Stripe Signature (Security)
│
├─ Extract Payment Data
│  ├─ Charge ID, amount, currency
│  ├─ Customer email
│  ├─ Invoice/order ID (from description or metadata)
│  └─ Timestamp
│
├─ PostgreSQL: Lookup client intake
│  └─ Match by email or invoice ID
│
├─ IF client found:
│   ├─ PostgreSQL: Mark as "payment_received"
│   │
│   ├─ Wave: Mark invoice as paid
│   │  └─ Update invoice status to "PAID"
│   │
│   ├─ HubSpot: Update deal stage
│   │  └─ Stage: "Awaiting Proposal" → "Proposal Sent"
│   │
│   ├─ Code: Generate receipt
│   │  └─ Build receipt HTML with payment details
│   │
│   ├─ Gmail: Send receipt to client
│   │  ├─ Subject: "Payment Confirmed - Your Consultation is Booked"
│   │  ├─ Body: Receipt + next steps
│   │  └─ Attachment: PDF receipt
│   │
│   ├─ Gmail: Send confirmation to COO
│   │  ├─ Subject: "Payment Received: [Client Name] - $X.XX"
│   │  └─ Ready to proceed with project
│   │
│   └─ PostgreSQL: Log payment event
│
├─ IF client NOT found:
│   ├─ PostgreSQL: Insert orphan_payment
│   │
│   └─ Gmail: Alert CTMO
│       └─ Subject: "MANUAL: Orphan payment received - $X.XX"
│
└─ Response: 200 OK to Stripe
```

### 3.2 Pseudo-Code

```javascript
function onStripeChargeSucceeded(webhook_payload) {
  // STEP 1: Validate Stripe signature
  if (!isValidStripeSignature(webhook_payload, REQUEST_HEADERS['stripe-signature'])) {
    return { status: 401, error: "Invalid signature" };
  }

  // STEP 2: Extract payment data
  const charge = webhook_payload.data.object;
  const payment = {
    charge_id: charge.id,
    amount_usd: charge.amount / 100, // Stripe uses cents
    customer_email: charge.billing_details?.email,
    invoice_id: charge.description || charge.metadata?.invoice_id,
    timestamp: new Date(charge.created * 1000).toISOString(),
    currency: charge.currency.toUpperCase()
  };

  // STEP 3: Lookup client intake
  const clientIntake = db.query(
    "SELECT * FROM client_intakes WHERE client_email = ? OR wave_invoice_id = ?",
    [payment.customer_email, payment.invoice_id]
  );

  if (!clientIntake) {
    // Orphan payment - store for manual review
    db.insert('orphan_payments', {
      charge_id: payment.charge_id,
      amount: payment.amount_usd,
      customer_email: payment.customer_email,
      timestamp: payment.timestamp,
      status: 'unmatched'
    });

    email.send({
      to: CTMO_EMAIL,
      subject: `MANUAL: Orphan payment received - $${payment.amount_usd}`,
      body: `Payment of $${payment.amount_usd} received but client not found in system.
             Email: ${payment.customer_email}
             Charge ID: ${payment.charge_id}`
    });

    return { status: 200, message: "Orphan payment logged" };
  }

  // STEP 4: Update client intake status
  db.update('client_intakes',
    { status: 'payment_received', payment_timestamp: payment.timestamp },
    { id: clientIntake.id }
  );

  // STEP 5: Mark Wave invoice as paid
  wave.invoices.markPaid(clientIntake.wave_invoice_id, {
    payment_date: payment.timestamp,
    payment_method: 'stripe'
  });

  // STEP 6: Update HubSpot deal
  hubspot.deals.update(clientIntake.hubspot_deal_id, {
    dealstage: 'proposal_sent',
    payment_received_date: payment.timestamp,
    amount_paid: payment.amount_usd
  });

  // STEP 7: Generate and send receipt
  const receiptHTML = buildReceipt(clientIntake, payment);
  email.send({
    to: clientIntake.client_email,
    subject: "Payment Confirmed - Your Consultation is Booked",
    html: receiptHTML,
    attachments: [{ filename: "receipt.pdf", content: generatePDF(receiptHTML) }]
  });

  // STEP 8: Notify COO
  email.send({
    to: COO_EMAIL,
    subject: `Payment Received: ${clientIntake.client_name} - $${payment.amount_usd}`,
    body: `Client ${clientIntake.client_name} has paid $${payment.amount_usd}.
           Consultation: ${clientIntake.event_type}
           Ready to proceed. View in HubSpot: [link]`
  });

  // STEP 9: Log payment event
  db.insert('payment_events', {
    charge_id: payment.charge_id,
    client_intake_id: clientIntake.id,
    amount: payment.amount_usd,
    currency: payment.currency,
    status: 'completed',
    timestamp: payment.timestamp
  });

  return {
    status: 200,
    message: "Payment processed and receipts sent",
    client_name: clientIntake.client_name,
    amount: payment.amount_usd
  };
}
```

### 3.3 n8n Node Specifications

**Node 1: Webhook Trigger (Stripe)**
```json
{
  "type": "webhook",
  "operation": "listen",
  "name": "Stripe - Charge Succeeded",
  "webhookPath": "/stripe/charge-succeeded",
  "httpMethod": "POST",
  "authentication": "headerAuth",
  "headerName": "Stripe-Signature",
  "headerValue": "$env.STRIPE_WEBHOOK_SECRET"
}
```

**Node 2: Code - Validate & Parse Stripe Webhook**
```javascript
// Input: Stripe webhook payload
// Output: Normalized payment data

const payload = $input.json.body;

// Validate required fields
if (!payload.data?.object?.id || !payload.data?.object?.amount) {
  throw new Error('Invalid Stripe payload');
}

const charge = payload.data.object;

const payment = {
  charge_id: charge.id,
  amount_usd: (charge.amount / 100).toFixed(2), // Convert from cents
  currency: charge.currency.toUpperCase(),
  customer_email: charge.billing_details?.email || charge.receipt_email || '',
  invoice_id: charge.description || charge.metadata?.invoice_id || '',
  payment_method: charge.payment_method_details?.type || 'unknown',
  timestamp: new Date(charge.created * 1000).toISOString()
};

if (!payment.customer_email && !payment.invoice_id) {
  throw new Error('Neither email nor invoice ID found in charge');
}

return { payment: payment };
```

**Node 3: PostgreSQL - Lookup Client Intake**
```sql
SELECT
  id,
  client_name,
  client_email,
  event_type,
  budget_usd,
  wave_invoice_id,
  hubspot_deal_id,
  status
FROM client_intakes
WHERE client_email = '{{ $input.json.payment.customer_email }}'
OR wave_invoice_id = '{{ $input.json.payment.invoice_id }}'
LIMIT 1;
```

**Node 4: If/Then - Check if Client Found**
```json
{
  "type": "if",
  "condition": "{{ $node['PostgreSQL - Lookup Client Intake'].json.rows.length > 0 }}"
}
```

**Node 5A: PostgreSQL - Update Client Intake Status (IF Found)**
```sql
UPDATE client_intakes
SET
  status = 'payment_received',
  payment_timestamp = '{{ $input.json.payment.timestamp }}',
  stripe_charge_id = '{{ $input.json.payment.charge_id }}',
  updated_at = NOW()
WHERE id = {{ $node['PostgreSQL - Lookup Client Intake'].json.rows[0].id }}
RETURNING id, client_name, client_email;
```

**Node 5B: PostgreSQL - Insert Orphan Payment (IF NOT Found)**
```sql
INSERT INTO orphan_payments (
  charge_id,
  amount_usd,
  currency,
  customer_email,
  invoice_id,
  timestamp,
  status,
  created_at
) VALUES (
  '{{ $input.json.payment.charge_id }}',
  {{ $input.json.payment.amount_usd }},
  '{{ $input.json.payment.currency }}',
  '{{ $input.json.payment.customer_email }}',
  '{{ $input.json.payment.invoice_id }}',
  '{{ $input.json.payment.timestamp }}',
  'unmatched',
  NOW()
)
RETURNING id;
```

**Node 5C: Gmail - Alert CTMO on Orphan Payment (IF NOT Found)**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "{{ $env.CTMO_EMAIL }}",
  "subject": "MANUAL: Orphan payment received - ${{ $input.json.payment.amount_usd }}",
  "html": "<p><strong>Payment received but client not found.</strong></p><ul><li>Amount: ${{ $input.json.payment.amount_usd }}</li><li>Email: {{ $input.json.payment.customer_email }}</li><li>Charge ID: {{ $input.json.payment.charge_id }}</li></ul><p>Action: Manually match or contact customer.</p>"
}
```

**Node 6: HTTP Request - Wave Mark Invoice Paid (IF Found)**
```json
{
  "type": "http",
  "method": "POST",
  "url": "https://api.waveapps.com/graphql",
  "authentication": "headerAuth",
  "headers": {
    "Authorization": "Bearer {{ $env.WAVE_API_KEY }}",
    "Content-Type": "application/json"
  },
  "body": {
    "query": "mutation { invoiceMarkPaid(input: { invoiceId: \"{{ $node['PostgreSQL - Lookup Client Intake'].json.rows[0].wave_invoice_id }}\", paidAt: \"{{ $input.json.payment.timestamp }}\" }) { invoice { status } } }"
  }
}
```

**Node 7: HubSpot - Update Deal (IF Found)**
```json
{
  "type": "hubspot",
  "operation": "deals.update",
  "dealId": "{{ $node['PostgreSQL - Lookup Client Intake'].json.rows[0].hubspot_deal_id }}",
  "properties": {
    "dealstage": "proposal_sent",
    "payment_received_date": "{{ $input.json.payment.timestamp }}",
    "amount_paid": "{{ $input.json.payment.amount_usd }}"
  }
}
```

**Node 8: Code - Build Receipt Email (IF Found)**
```javascript
const clientIntake = $node['PostgreSQL - Lookup Client Intake'].json.rows[0];
const payment = $input.json.payment;

const receiptHTML = `
<div style="font-family: Arial, sans-serif; max-width: 600px;">
  <h2>✅ Payment Confirmed</h2>

  <p>Hi ${clientIntake.client_name.split(' ')[0]},</p>
  <p>Thank you! We've received your payment. Your ${clientIntake.event_type} consultation is now confirmed.</p>

  <h3>Receipt</h3>
  <table style="width: 100%; border-collapse: collapse;">
    <tr style="background-color: #f5f5f5;">
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Transaction ID</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;">${payment.charge_id}</td>
    </tr>
    <tr>
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Amount Paid</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>$${payment.amount_usd}</strong></td>
    </tr>
    <tr style="background-color: #f5f5f5;">
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Payment Method</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;">${payment.payment_method}</td>
    </tr>
    <tr>
      <td style="padding: 10px; border: 1px solid #ddd;"><strong>Date</strong></td>
      <td style="padding: 10px; border: 1px solid #ddd;">${new Date(payment.timestamp).toLocaleDateString()}</td>
    </tr>
  </table>

  <h3>Next Steps</h3>
  <ol>
    <li>We'll send you a proposal within 24 hours</li>
    <li>You'll have the chance to approve before we start</li>
    <li>Once approved, we'll begin your project immediately</li>
  </ol>

  <p style="margin-top: 30px; color: #999; font-size: 12px;">
    Questions? Reply to this email.
  </p>
</div>
`;

return { receipt_html: receiptHTML };
```

**Node 9: Gmail - Send Receipt to Client (IF Found)**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "{{ $node['PostgreSQL - Lookup Client Intake'].json.rows[0].client_email }}",
  "subject": "✅ Payment Confirmed - Your {{ $node['PostgreSQL - Lookup Client Intake'].json.rows[0].event_type }} Consultation is Booked",
  "html": "{{ $input.json.receipt_html }}"
}
```

**Node 10: Code - Build COO Notification (IF Found)**
```javascript
const clientIntake = $node['PostgreSQL - Lookup Client Intake'].json.rows[0];
const payment = $input.json.payment;

const emailHTML = `
<div style="font-family: Arial, sans-serif; max-width: 600px;">
  <h2>💰 Payment Received</h2>

  <h3>${clientIntake.client_name}</h3>
  <ul>
    <li><strong>Service:</strong> ${clientIntake.event_type}</li>
    <li><strong>Amount:</strong> $${payment.amount_usd}</li>
    <li><strong>Transaction ID:</strong> ${payment.charge_id}</li>
  </ul>

  <p><strong>Status:</strong> Ready to proceed with project</p>

  <p><a href="https://app.hubspot.com/deals/${clientIntake.hubspot_deal_id}" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 4px;">View Deal in HubSpot</a></p>
</div>
`;

return { email_html: emailHTML };
```

**Node 11: Gmail - Send Confirmation to COO (IF Found)**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "{{ $env.COO_EMAIL }}",
  "subject": "💰 Payment Received: {{ $node['PostgreSQL - Lookup Client Intake'].json.rows[0].client_name }} - ${{ $input.json.payment.amount_usd }}",
  "html": "{{ $input.json.email_html }}"
}
```

**Node 12: PostgreSQL - Log Payment Event (IF Found)**
```sql
INSERT INTO payment_events (
  charge_id,
  client_intake_id,
  amount_usd,
  currency,
  payment_method,
  status,
  timestamp,
  created_at
) VALUES (
  '{{ $input.json.payment.charge_id }}',
  {{ $node['PostgreSQL - Lookup Client Intake'].json.rows[0].id }},
  {{ $input.json.payment.amount_usd }},
  '{{ $input.json.payment.currency }}',
  '{{ $input.json.payment.payment_method }}',
  'completed',
  '{{ $input.json.payment.timestamp }}',
  NOW()
);
```

**Node 13: HTTP Response**
```json
{
  "statusCode": 200,
  "body": {
    "status": "success",
    "message": "Payment processed successfully",
    "charge_id": "{{ $input.json.payment.charge_id }}",
    "amount": "{{ $input.json.payment.amount_usd }}"
  }
}
```

### 3.4 Sample Test Data

```json
{
  "data": {
    "object": {
      "id": "ch_1234567890",
      "object": "charge",
      "amount": 75000,
      "currency": "usd",
      "created": 1711814400,
      "receipt_email": "sarah@company.com",
      "description": "CLT-2026-03-30",
      "billing_details": {
        "email": "sarah@company.com"
      },
      "payment_method_details": {
        "type": "card"
      },
      "metadata": {
        "invoice_id": "INV-2026-03-30"
      }
    }
  }
}
```

**Expected outputs:**
- client_intakes: Status updated to "payment_received"
- Wave: Invoice marked as paid
- HubSpot: Deal stage updated to "proposal_sent"
- Emails: Receipt sent to client, confirmation to COO
- payment_events: Row inserted

### 3.5 Cost Estimate (n8n)

**Tasks Per Execution (Success Path):**
1. Webhook: 1
2. Validation + parsing: 1
3. PostgreSQL lookup: 1
4. PostgreSQL update: 1
5. Wave API call: 1
6. HubSpot API call: 1
7. Code (build receipts): 2
8. Gmail (2 emails): 2
9. PostgreSQL log: 1
Total: **11 tasks**

**Estimated Monthly Cost:**
- Assume 30 payments/month
- 30 × 11 = 330 tasks/month
- Requires n8n paid tier ($50/mo)

---

## WORKFLOW 4: P3 CONTENT PUBLISHING (WordPress → Affiliate Injection → Email)

**Purpose:** Detect WordPress blog post publication, inject affiliate links, setup SEO metadata, submit to Google Search Console, and email announcement.

**Trigger:** WordPress post published (API webhook)

**Build Duration:** 3 hours

### 4.1 Flow Diagram

```
┌─ WordPress Webhook (Post Published)
│  └─ Payload: post_id, title, content, author, publish_date
│
├─ Extract Post Data
│  ├─ Post ID, title, slug
│  ├─ Content
│  ├─ Category/tags
│  └─ Featured image
│
├─ Code: Identify Affiliate Link Opportunities
│  ├─ Parse content for product mentions
│  ├─ Match against affiliate catalog
│  ├─ Insert affiliate links (Amazon Associates, etc.)
│  └─ Flag manual review items
│
├─ WordPress API: Update Post
│  ├─ Inject affiliate links into content
│  ├─ Add SEO title (if missing)
│  ├─ Add meta description
│  └─ Add canonical URL
│
├─ Code: Extract SEO metadata
│  ├─ Target keyword (from title/content)
│  ├─ Focus keyphrase
│  └─ Readability score
│
├─ Google Search Console: Submit URL
│  └─ Queue for crawling
│
├─ PostgreSQL: Log Post & Affiliate Links
│  ├─ Insert: published_articles table
│  ├─ Insert: affiliate_links_in_post table
│  └─ Track: potential commission opportunities
│
├─ Code: Build Email Announcement
│  ├─ Post title + excerpt
│  ├─ Direct link to post
│  ├─ Affiliate disclosure
│  └─ CTA: "Share this article"
│
├─ Gmail: Send to Email List
│  ├─ Subject: "[Topic] - New article"
│  └─ Body: [Email from previous step]
│
└─ Response: 200 OK to WordPress
```

### 4.2 Pseudo-Code

```javascript
function onWordPressPostPublished(webhook_payload) {
  // STEP 1: Extract post data
  const post = {
    post_id: webhook_payload.post_id,
    title: webhook_payload.title,
    slug: webhook_payload.slug,
    content: webhook_payload.content,
    category: webhook_payload.category,
    tags: webhook_payload.tags || [],
    featured_image: webhook_payload.featured_image,
    publish_date: webhook_payload.publish_date
  };

  // STEP 2: Identify affiliate opportunities
  const affiliateLinks = identifyAffiliateOpportunities(post.content);
  // Returns: [{ text: "product name", link: "affiliate_url", program: "amazon", commission_rate: 0.05 }]

  // STEP 3: Update WordPress post with affiliate links
  const updatedContent = injectAffiliateLinks(post.content, affiliateLinks);
  wp.posts.update(post.post_id, {
    content: updatedContent,
    meta: {
      yoast_seo_title: generateSEOTitle(post.title),
      yoast_meta_description: generateMetaDescription(post.content),
      affiliate_links_count: affiliateLinks.length
    }
  });

  // STEP 4: Get SEO metrics
  const seoMetrics = {
    target_keyword: extractKeyword(post.title),
    focus_keyphrase: extractKeyphrase(post.content),
    word_count: post.content.split(' ').length,
    readability_score: calculateReadability(post.content)
  };

  // STEP 5: Submit to Google Search Console
  gsc.submitUrl(post.slug);

  // STEP 6: Log post and affiliate links
  const postRecord = db.insert('published_articles', {
    post_id: post.post_id,
    title: post.title,
    slug: post.slug,
    content: updatedContent,
    category: post.category,
    affiliate_links_count: affiliateLinks.length,
    publish_date: post.publish_date,
    seo_metrics: JSON.stringify(seoMetrics),
    status: 'published'
  });

  // Log each affiliate link
  affiliateLinks.forEach(link => {
    db.insert('affiliate_links', {
      article_id: postRecord.id,
      product_name: link.text,
      program: link.program,
      url: link.url,
      commission_rate: link.commission_rate,
      estimated_commission: 0, // Will update when clicks tracked
      status: 'active'
    });
  });

  // STEP 7: Send announcement email
  const emailBody = buildAnnouncement(post, affiliateLinks);
  email.send({
    to: EMAIL_LIST,
    subject: `${post.category}: ${post.title}`,
    html: emailBody
  });

  // STEP 8: Update recovery tracker
  db.update('recovery_tracker', {
    content_published: +1,
    potential_affiliate_revenue: affiliateLinks.length * AVERAGE_COMMISSION_PER_LINK
  });

  return {
    status: 200,
    message: "Post published and shared",
    post_id: post.post_id,
    affiliate_links: affiliateLinks.length
  };
}
```

### 4.3 n8n Node Specifications

**Node 1: Webhook Trigger (WordPress)**
```json
{
  "type": "webhook",
  "operation": "listen",
  "name": "WordPress - Post Published",
  "webhookPath": "/wordpress/post-published",
  "httpMethod": "POST"
}
```

**Node 2: Code - Extract Post Data**
```javascript
// Input: WordPress webhook payload
// Output: Normalized post data

const payload = $input.json.body;

const post = {
  post_id: payload.post_id,
  title: payload.title,
  slug: payload.slug || payload.title.toLowerCase().replace(/\s+/g, '-'),
  content: payload.content,
  category: payload.category || 'uncategorized',
  tags: payload.tags || [],
  featured_image: payload.featured_image || '',
  author: payload.author || 'unknown',
  publish_date: payload.publish_date || new Date().toISOString(),
  permalink: payload.link || `https://makinmoves.io/${payload.slug}`
};

// Extract word count
const wordCount = post.content.split(/\s+/).length;

return {
  post: post,
  word_count: wordCount,
  publication_timestamp: new Date().toISOString()
};
```

**Node 3: Code - Identify Affiliate Opportunities**
```javascript
// Input: Post content
// Output: Array of affiliate links to insert

const post = $input.json.post;
const content = post.content;

// Define affiliate program keywords
const affiliatePrograms = {
  'amazon': {
    keywords: ['amazon', 'kindle', 'alexa'],
    domain: 'amazon.com',
    program_id: 'makinmoves-20'
  },
  'notion': {
    keywords: ['notion', 'database', 'template'],
    domain: 'notion.so',
    program_id: 'notion_affiliate'
  },
  'zapier': {
    keywords: ['zapier', 'automation', 'workflow'],
    domain: 'zapier.com',
    commission_rate: 0.30
  },
  'webflow': {
    keywords: ['webflow', 'website', 'design'],
    domain: 'webflow.com'
  }
};

// Scan content for product mentions
const opportunities = [];
Object.entries(affiliatePrograms).forEach(([program, details]) => {
  details.keywords.forEach(keyword => {
    const regex = new RegExp(`\\b${keyword}\\b`, 'gi');
    if (regex.test(content)) {
      opportunities.push({
        program: program,
        keyword: keyword,
        commission_rate: details.commission_rate || 0.05,
        requires_manual_review: false
      });
    }
  });
});

return { affiliate_opportunities: opportunities };
```

**Node 4: Code - Generate Affiliate Links**
```javascript
// Input: Affiliate opportunities, post slug
// Output: List of formatted affiliate links ready for injection

const opportunities = $input.json.affiliate_opportunities;
const postSlug = $input.json.post.slug;

const affiliateLinks = opportunities.map(opp => {
  let affiliateUrl;

  switch(opp.program) {
    case 'amazon':
      affiliateUrl = `https://amazon.com/s?k=${opp.keyword}&tag=makinmoves-20`;
      break;
    case 'zapier':
      affiliateUrl = `https://zapier.com/signup/?utm_source=makinmoves&utm_campaign=${postSlug}`;
      break;
    case 'webflow':
      affiliateUrl = `https://webflow.com?utm_source=makinmoves&utm_medium=blog&utm_campaign=${postSlug}`;
      break;
    default:
      affiliateUrl = `https://${opp.program}.com`;
  }

  return {
    program: opp.program,
    keyword: opp.keyword,
    url: affiliateUrl,
    commission_rate: opp.commission_rate,
    anchor_text: `[${opp.keyword}](${affiliateUrl})`
  };
});

return { affiliate_links: affiliateLinks };
```

**Node 5: Code - Build Updated Content with Affiliate Links**
```javascript
// Input: Original content, affiliate links
// Output: Updated content with affiliate links injected

const post = $input.json.post;
let content = post.content;
const affiliateLinks = $input.json.affiliate_links;

// Inject affiliate links where keywords appear
affiliateLinks.forEach(link => {
  // Find keyword mentions and replace with affiliate links
  const regex = new RegExp(`\\b(${link.keyword})\\b`, 'gi');

  // Only replace first mention to avoid over-linking
  if (regex.test(content)) {
    content = content.replace(
      regex,
      `[${link.keyword}](${link.url})`
    );
  }
});

// Add FTC disclosure before first link
if (affiliateLinks.length > 0) {
  const disclosure = `
<div style="background-color: #f9f9f9; border-left: 4px solid #4CAF50; padding: 10px; margin: 20px 0;">
  <strong>Disclosure:</strong> This article contains affiliate links. I earn a commission if you purchase through these links at no extra cost to you.
</div>`;

  content = disclosure + '\n\n' + content;
}

return { updated_content: content };
```

**Node 6: HTTP Request - WordPress Update Post**
```json
{
  "type": "http",
  "method": "POST",
  "url": "https://makinmoves.io/wp-json/wp/v2/posts/{{ $input.json.post.post_id }}",
  "authentication": "basicAuth",
  "username": "{{ $env.WP_API_USER }}",
  "password": "{{ $env.WP_API_PASSWORD }}",
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "content": "{{ $input.json.updated_content }}",
    "meta": {
      "_yoast_wpseo_title": "{{ $input.json.post.title }} - MakinMoves",
      "_yoast_wpseo_metadesc": "{{ $input.json.post.content.substring(0, 160) }}...",
      "affiliate_links_count": "{{ $input.json.affiliate_links.length }}"
    }
  }
}
```

**Node 7: Code - Extract SEO Metrics**
```javascript
const post = $input.json.post;
const content = $input.json.updated_content;

// Extract primary keyword (usually first significant word in title)
const titleWords = post.title.split(' ').filter(w => w.length > 4);
const targetKeyword = titleWords[0]?.toLowerCase() || 'blog';

// Calculate SEO metrics
const seoMetrics = {
  target_keyword: targetKeyword,
  word_count: content.split(/\s+/).length,
  headings: (content.match(/<h[2-4]/g) || []).length,
  links: (content.match(/\[.*?\]\(/g) || []).length,
  images: (content.match(/<img/g) || []).length,
  readability_score: calculateReadability(content)
};

return { seo_metrics: seoMetrics };
```

**Node 8: HTTP Request - Google Search Console Submit**
```json
{
  "type": "http",
  "method": "POST",
  "url": "https://www.google.com/ping?sitemap={{ $input.json.post.permalink }}",
  "headers": {
    "User-Agent": "n8n-automation"
  }
}
```

**Node 9: PostgreSQL - Log Published Article**
```sql
INSERT INTO published_articles (
  post_id,
  title,
  slug,
  category,
  content_preview,
  word_count,
  affiliate_links_count,
  seo_metrics,
  published_at,
  published_url,
  status
) VALUES (
  {{ $input.json.post.post_id }},
  '{{ $input.json.post.title }}',
  '{{ $input.json.post.slug }}',
  '{{ $input.json.post.category }}',
  '{{ $input.json.post.content.substring(0, 300) }}',
  {{ $input.json.seo_metrics.word_count }},
  {{ $input.json.affiliate_links.length }},
  '{{ JSON.stringify($input.json.seo_metrics) }}'::jsonb,
  '{{ $input.json.post.publish_date }}',
  '{{ $input.json.post.permalink }}',
  'published'
)
RETURNING id;
```

**Node 10: Code - Log Affiliate Links (Loop Over Each Link)**
```javascript
// Set up loop to iterate over affiliate_links
return {
  iterations: $input.json.affiliate_links.length,
  article_id: $node['PostgreSQL - Log Article'].json.rows[0].id,
  links: $input.json.affiliate_links
};
```

**Node 11: Loop Node**
```json
{
  "type": "loop",
  "iterations": "{{ $input.json.iterations }}"
}
```

**Node 12: PostgreSQL - Insert Each Affiliate Link (Inside Loop)**
```sql
INSERT INTO affiliate_links (
  article_id,
  program,
  keyword,
  url,
  commission_rate,
  status
) VALUES (
  {{ $input.json.article_id }},
  '{{ $input.json.links[$loop.index].program }}',
  '{{ $input.json.links[$loop.index].keyword }}',
  '{{ $input.json.links[$loop.index].url }}',
  {{ $input.json.links[$loop.index].commission_rate }},
  'active'
);
```

**Node 13: Code - Build Announcement Email**
```javascript
const post = $input.json.post;
const affiliateLinks = $input.json.affiliate_links;

const emailHTML = `
<div style="font-family: Arial, sans-serif; max-width: 600px;">
  <h2>📝 New Article: ${post.title}</h2>

  <p><strong>Category:</strong> ${post.category}</p>
  <p><strong>Reading Time:</strong> ~${Math.ceil($input.json.seo_metrics.word_count / 200)} min</p>

  <h3>Summary</h3>
  <p>${post.content.substring(0, 300)}...</p>

  <p><a href="${post.permalink}" style="background-color: #4CAF50; color: white; padding: 12px 30px; text-decoration: none; border-radius: 4px; display: inline-block;">Read Full Article</a></p>

  <h3>What You'll Learn</h3>
  <ul>
    <li>Key insights about ${post.category}</li>
    <li>Practical strategies you can use today</li>
    <li>Tools and resources to get started</li>
  </ul>

  <div style="background-color: #f9f9f9; border-left: 4px solid #999; padding: 10px; margin: 20px 0; font-size: 12px;">
    <strong>Disclosure:</strong> This article contains affiliate links. I earn a commission if you purchase through these links at no extra cost to you.
  </div>

  <p style="margin-top: 30px;">
    <a href="${post.permalink}#share" style="text-decoration: none;">👉 Share this article with your network</a>
  </p>
</div>
`;

return { email_html: emailHTML };
```

**Node 14: Gmail - Send Announcement**
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "{{ $env.EMAIL_LIST_ADDRESS }}",
  "subject": "📝 New Article: {{ $input.json.post.title }}",
  "html": "{{ $input.json.email_html }}"
}
```

**Node 15: PostgreSQL - Update Recovery Tracker**
```sql
UPDATE recovery_tracker
SET
  content_published = content_published + 1,
  potential_affiliate_revenue = potential_affiliate_revenue + ({{ $input.json.affiliate_links.length }} * 5),
  updated_at = NOW()
WHERE goal_id = 'content-recovery-goal';
```

**Node 16: HTTP Response**
```json
{
  "statusCode": 200,
  "body": {
    "status": "success",
    "message": "Article published and shared",
    "post_id": "{{ $input.json.post.post_id }}",
    "affiliate_links": "{{ $input.json.affiliate_links.length }}"
  }
}
```

### 4.4 Sample Test Data

```json
{
  "post_id": 12345,
  "title": "How to Automate Your Email Marketing with Zapier",
  "slug": "automate-email-marketing-zapier",
  "content": "In this guide, we'll show you how to set up Zapier workflows for email marketing...",
  "category": "automation",
  "tags": ["zapier", "email", "marketing"],
  "link": "https://makinmoves.io/automate-email-marketing-zapier",
  "publish_date": "2026-03-29T10:00:00Z"
}
```

**Expected outputs:**
- WordPress: Post updated with affiliate links injected
- PostgreSQL: Article and affiliate links logged
- Google: URL submitted for crawling
- Email: Announcement sent to subscribers

### 4.5 Cost Estimate (n8n)

**Tasks Per Execution:**
1. Webhook: 1
2. Post extraction: 1
3. Affiliate identification: 1
4. Affiliate link generation: 1
5. Content update + injection: 1
6. WordPress API call: 1
7. SEO metrics: 1
8. GSC submit: 1
9. PostgreSQL inserts (article + loop for links): 2 + N (where N = affiliate links)
10. Email build: 1
11. Email send: 1
12. Recovery tracker update: 1
Total: **14 + N tasks**

**Estimated Monthly Cost:**
- Assume 4 posts/month, avg 3 affiliate links per post
- (14 + 3) × 4 = 68 tasks/month
- n8n free tier: 100 tasks → **Fits in free tier**

---

## WORKFLOW 5: P3 AFFILIATE REVENUE TRACKING

**Purpose:** Track affiliate clicks and commissions from multiple programs, update database, identify high-value opportunities, send alerts.

**Trigger:** Affiliate webhook (click/commission received) or hourly polling

**Build Duration:** 2 hours

### 5.1 Flow Diagram

```
┌─ Affiliate Program Webhook (Click/Commission)
│  └─ Payload: affiliate_id, click_id, amount, status, timestamp
│
├─ Extract Click/Commission Data
│  ├─ Click ID, timestamp
│  ├─ Amount (if commission)
│  ├─ Program source
│  └─ Link/product clicked
│
├─ PostgreSQL: Lookup Link
│  └─ Match click_id to affiliate_links table
│
├─ IF link found:
│   ├─ PostgreSQL: Log click
│   │  └─ Insert into clicks table
│   │
│   ├─ IF commission_received:
│   │   ├─ PostgreSQL: Log commission
│   │   │  └─ Update affiliate_links.total_commission
│   │   │
│   │   ├─ PostgreSQL: Update revenue tracker
│   │   │  └─ recovery_tracker.affiliate_revenue += amount
│   │   │
│   │   ├─ Code: Check if high-value commission (>$100)
│   │   │
│   │   └─ IF high-value:
│   │       └─ Slack: Send alert to #revenue
│   │           └─ "🎉 High-value commission: $X from [Product]"
│   │
│   └─ PostgreSQL: Update click_to_commission ratio
│
├─ IF link NOT found:
│   └─ PostgreSQL: Log orphan_click
│       └─ Manual review needed
│
├─ PostgreSQL: Daily aggregation (if needed)
│  └─ Summarize: clicks, commissions, top performers
│
└─ Response: 200 OK to Affiliate Program
```

### 5.2 Pseudo-Code

```javascript
function onAffiliateWebhookReceived(webhook_payload) {
  // STEP 1: Extract webhook data
  const event = {
    event_type: webhook_payload.event_type, // 'click' or 'commission'
    click_id: webhook_payload.click_id,
    affiliate_id: webhook_payload.affiliate_id,
    amount: webhook_payload.amount || 0,
    program: webhook_payload.program,
    timestamp: webhook_payload.timestamp,
    status: webhook_payload.status // 'pending', 'approved', 'declined'
  };

  // STEP 2: Lookup affiliate link
  const affiliateLink = db.query(
    "SELECT * FROM affiliate_links WHERE affiliate_id = ?",
    [event.affiliate_id]
  );

  if (!affiliateLink) {
    // Orphan click - store for investigation
    db.insert('orphan_clicks', {
      affiliate_id: event.affiliate_id,
      click_id: event.click_id,
      program: event.program,
      timestamp: event.timestamp
    });
    return { status: 200, message: "Orphan click logged" };
  }

  // STEP 3: Log click
  db.insert('clicks', {
    affiliate_link_id: affiliateLink.id,
    click_id: event.click_id,
    timestamp: event.timestamp,
    program: event.program
  });

  // STEP 4: If commission, update revenue
  if (event.event_type === 'commission' && event.amount > 0) {
    // Update affiliate link totals
    db.update('affiliate_links',
      {
        total_commission: db.raw('total_commission + ?', [event.amount]),
        last_commission_date: event.timestamp
      },
      { id: affiliateLink.id }
    );

    // Update recovery tracker
    db.update('recovery_tracker', {
      affiliate_revenue: db.raw('affiliate_revenue + ?', [event.amount]),
      updated_at: NOW()
    });

    // Check if high-value commission
    if (event.amount > 100) {
      slack.send('#revenue', {
        text: `🎉 High-value commission: $${event.amount.toFixed(2)} from ${affiliateLink.program} - ${affiliateLink.keyword}`
      });
    }

    // Log commission event
    db.insert('commissions', {
      affiliate_link_id: affiliateLink.id,
      amount: event.amount,
      program: event.program,
      status: event.status,
      timestamp: event.timestamp
    });
  }

  return {
    status: 200,
    message: event.event_type === 'click' ? "Click logged" : "Commission recorded",
    link_id: affiliateLink.id
  };
}
```

### 5.3 n8n Node Specifications

**Node 1: Webhook Trigger (Affiliate Programs)**
```json
{
  "type": "webhook",
  "operation": "listen",
  "name": "Affiliate Programs - Click/Commission Webhook",
  "webhookPath": "/affiliate/webhook",
  "httpMethod": "POST"
}
```

**Node 2: Code - Extract Event Data**
```javascript
// Input: Affiliate webhook payload (varies by program)
// Output: Normalized event data

const payload = $input.json.body;

// Normalize based on program (Amazon, Zapier, Notion, etc.)
const event = {
  event_type: payload.event_type || (payload.amount ? 'commission' : 'click'),
  click_id: payload.click_id || payload.tracking_id || payload.id,
  affiliate_id: payload.affiliate_id || payload.link_id,
  amount: payload.amount ? parseFloat(payload.amount) : 0,
  currency: payload.currency || 'USD',
  program: payload.program || 'unknown',
  timestamp: new Date(payload.timestamp || payload.created_at).toISOString(),
  status: payload.status || 'pending'
};

// Validate required fields
if (!event.click_id || !event.affiliate_id) {
  throw new Error('Missing required fields: click_id or affiliate_id');
}

return { event: event };
```

**Node 3: PostgreSQL - Lookup Affiliate Link**
```sql
SELECT
  id,
  article_id,
  program,
  keyword,
  url,
  commission_rate,
  total_clicks,
  total_commission
FROM affiliate_links
WHERE affiliate_id = '{{ $input.json.event.affiliate_id }}'
LIMIT 1;
```

**Node 4: If/Then - Check if Link Found**
```json
{
  "type": "if",
  "condition": "{{ $node['PostgreSQL - Lookup Link'].json.rows.length > 0 }}"
}
```

**Node 5A: PostgreSQL - Log Click (IF Found)**
```sql
INSERT INTO clicks (
  affiliate_link_id,
  click_id,
  program,
  timestamp,
  created_at
) VALUES (
  {{ $node['PostgreSQL - Lookup Link'].json.rows[0].id }},
  '{{ $input.json.event.click_id }}',
  '{{ $input.json.event.program }}',
  '{{ $input.json.event.timestamp }}',
  NOW()
)
ON CONFLICT (click_id) DO NOTHING;
```

**Node 5B: PostgreSQL - Log Orphan Click (IF NOT Found)**
```sql
INSERT INTO orphan_clicks (
  click_id,
  affiliate_id,
  program,
  amount,
  timestamp,
  status
) VALUES (
  '{{ $input.json.event.click_id }}',
  '{{ $input.json.event.affiliate_id }}',
  '{{ $input.json.event.program }}',
  {{ $input.json.event.amount }},
  '{{ $input.json.event.timestamp }}',
  'unmatched'
);
```

**Node 6: If/Then - Check if Commission (IF Found)**
```json
{
  "type": "if",
  "condition": "{{ $input.json.event.event_type === 'commission' && $input.json.event.amount > 0 }}"
}
```

**Node 7A: PostgreSQL - Update Link Totals (IF Commission)**
```sql
UPDATE affiliate_links
SET
  total_clicks = total_clicks + 1,
  total_commission = total_commission + {{ $input.json.event.amount }},
  last_commission_date = '{{ $input.json.event.timestamp }}',
  updated_at = NOW()
WHERE id = {{ $node['PostgreSQL - Lookup Link'].json.rows[0].id }};
```

**Node 7B: PostgreSQL - Update Recovery Tracker (IF Commission)**
```sql
UPDATE recovery_tracker
SET
  affiliate_revenue = affiliate_revenue + {{ $input.json.event.amount }},
  updated_at = NOW()
WHERE goal_id = 'affiliate-recovery-goal';
```

**Node 8: Code - Check if High-Value Commission (IF Commission)**
```javascript
const amount = $input.json.event.amount;
const program = $input.json.event.program;
const keyword = $node['PostgreSQL - Lookup Link'].json.rows[0]?.keyword;

const isHighValue = amount > 100;

return {
  is_high_value: isHighValue,
  alert_message: isHighValue
    ? `🎉 High-value commission: $${amount.toFixed(2)} from ${program} - ${keyword}`
    : null
};
```

**Node 9: If/Then - High-Value Check**
```json
{
  "type": "if",
  "condition": "{{ $input.json.is_high_value }}"
}
```

**Node 10: Slack - Send High-Value Alert (IF High-Value)**
```json
{
  "type": "slack",
  "operation": "send",
  "channel": "#revenue",
  "text": "{{ $input.json.alert_message }}"
}
```

**Node 11: PostgreSQL - Log Commission (IF Commission)**
```sql
INSERT INTO commissions (
  affiliate_link_id,
  click_id,
  program,
  amount,
  currency,
  status,
  timestamp,
  created_at
) VALUES (
  {{ $node['PostgreSQL - Lookup Link'].json.rows[0].id }},
  '{{ $input.json.event.click_id }}',
  '{{ $input.json.event.program }}',
  {{ $input.json.event.amount }},
  '{{ $input.json.event.currency }}',
  '{{ $input.json.event.status }}',
  '{{ $input.json.event.timestamp }}',
  NOW()
);
```

**Node 12: HTTP Response**
```json
{
  "statusCode": 200,
  "body": {
    "status": "success",
    "message": "{{ $input.json.event.event_type }} recorded",
    "link_id": "{{ $node['PostgreSQL - Lookup Link'].json.rows[0].id }}",
    "amount": "{{ $input.json.event.amount }}"
  }
}
```

### 5.4 Sample Test Data (Commission Webhook)

```json
{
  "event_type": "commission",
  "click_id": "CLK-2026-03-29-001",
  "affiliate_id": "AFF-ZAPIER-001",
  "amount": 125.50,
  "currency": "USD",
  "program": "zapier",
  "status": "approved",
  "timestamp": "2026-03-29T15:30:00Z"
}
```

**Expected outputs:**
- clicks table: Row inserted
- affiliate_links: total_clicks incremented, total_commission updated
- commissions: Row inserted
- recovery_tracker: affiliate_revenue updated
- Slack: Alert sent (since amount > $100)

### 5.5 Cost Estimate (n8n)

**Tasks Per Execution (Commission Path):**
1. Webhook: 1
2. Event extraction: 1
3. PostgreSQL lookup: 1
4. Conditional check: 0.5
5. Click logging: 1
6. Commission check: 0.5
7. Link update: 1
8. Recovery tracker update: 1
9. High-value check: 0.5
10. Slack alert (if high-value): 0.5-1
11. Commission logging: 1
Total: **~10 tasks**

**Estimated Monthly Cost (P3 Traffic):**
- Assume 30k/mo traffic → ~500 affiliate clicks/mo
- Assume 2% commission rate → ~10 commissions/mo
- Clicks: 500 × 1.5 tasks = 750 tasks
- Commissions: 10 × 10 tasks = 100 tasks
- **Total: ~850 tasks/month → Requires n8n paid tier ($50/mo)**

---

## OVERALL Trinity IMPLEMENTATION SUMMARY

### Task Count Summary (All 5 Workflows)

| Workflow | Tasks/Execution | Monthly Volume | Monthly Tasks | Tier |
|----------|---|---|---|---|
| 1. Gumroad Launch | 6 | 10 products | 60 | FREE |
| 2. Client Intake | 10 | 30 bookings | 300 | PAID |
| 3. Payment Tracking | 11 | 30 payments | 330 | PAID |
| 4. Content Publishing | 14+N | 4 posts (3 links ea) | 68 | FREE |
| 5. Affiliate Revenue | 10 | 510 clicks + 10 commissions | 850 | PAID |
| **TOTAL** | — | — | **~1,608 tasks/mo** | **PAID** |

### Implementation Timeline

**Phase 1 (2 hours):**
- [ ] Workflow 1: Gumroad Launch
- [ ] Database schema setup
- [ ] Test with sample webhook

**Phase 2 (3 hours):**
- [ ] Workflow 2: Client Intake Pipeline
- [ ] Setup HubSpot, Wave, Stripe integrations
- [ ] Email templates

**Phase 3 (2 hours):**
- [ ] Workflow 3: Payment Tracking
- [ ] Test end-to-end with mock Stripe event
- [ ] Error handling for orphan payments

**Phase 4 (3 hours):**
- [ ] Workflow 4: Content Publishing
- [ ] WordPress integration test
- [ ] Affiliate link injection test

**Phase 5 (2 hours):**
- [ ] Workflow 5: Affiliate Revenue Tracking
- [ ] Test with mock affiliate webhooks
- [ ] Slack alert configuration

**Total Build Time: 12 hours**

### Database Tables Required

```sql
-- Revenue & Financial
CREATE TABLE revenue_log (...)
CREATE TABLE payment_events (...)
CREATE TABLE commissions (...)
CREATE TABLE recovery_tracker (...)

-- Content & Products
CREATE TABLE digital_products (...)
CREATE TABLE published_articles (...)
CREATE TABLE affiliate_links (...)

-- Client Management
CREATE TABLE client_intakes (...)
CREATE TABLE client_intake_errors (...)

-- Tracking
CREATE TABLE clicks (...)
CREATE TABLE analytics_events (...)
CREATE TABLE orphan_payments (...)
CREATE TABLE orphan_clicks (...)

-- Workflow Monitoring
CREATE TABLE workflow_executions (...)
CREATE TABLE workflow_errors (...)
```

### Critical Path for Launch

1. **Setup PostgreSQL schema** (30 min)
2. **Setup n8n instance** with credentials (30 min)
3. **Build & test Workflow 1** (Gumroad) (2 hours)
4. **Build & test Workflow 2** (Client Intake) (3 hours)
5. **Build & test Workflow 3** (Payment Tracking) (2 hours)
6. **Build & test Workflow 4** (Content Publishing) (3 hours)
7. **Build & test Workflow 5** (Affiliate Tracking) (2 hours)
8. **Integration test** (full end-to-end) (1 hour)
9. **Deploy to production** (30 min)

**Total: ~14 hours start to finish**

### Go-Live Checklist

- [ ] All 5 workflows built and tested
- [ ] Webhook endpoints configured in platforms (Gumroad, Calendly, Stripe, WordPress, Affiliate programs)
- [ ] Slack #critical-alerts channel setup
- [ ] Email credentials validated
- [ ] Database backups enabled
- [ ] Error monitoring dashboard created
- [ ] COO trained on monitoring dashboard
- [ ] CTMO on-call for first 48 hours
- [ ] Recovery tracker accessible to CFO

---

**Status:** COMPLETE SPECIFICATIONS READY FOR BUILD

**Owner:** CTMO

**Next Step:** Approval from CEO/COO, then begin Phase 1 implementation

---

## BONUS: SCALING ANALYSIS

### Scaling Scenario 1: 10 P2 Clients/Month

**Current Load:**
- Client Intake: 30 bookings × 10 tasks = 300 tasks
- Payment Tracking: 30 payments × 11 tasks = 330 tasks
- Subtotal: 630 tasks

**Scaling to 10 clients/month:**
- 100 bookings × 10 tasks = 1,000 tasks
- 100 payments × 11 tasks = 1,100 tasks
- **New subtotal: 2,100 tasks/month → Requires paid tier ($50/mo)**

### Scaling Scenario 2: 30k Visitors/Month (P3 Traffic)

**Current Load:**
- Affiliate Revenue: 500 clicks + 10 commissions = 850 tasks

**At 30k visitors/month:**
- ~1,500 clicks × 1.5 tasks = 2,250 tasks
- ~30 commissions × 10 tasks = 300 tasks
- **New subtotal: 2,550 tasks/month → Requires paid tier**

### Capacity Limits

**n8n Paid Tier ($50/mo):**
- Execution time: Unlimited
- Workflows: Unlimited
- Tasks: 50,000/month (plenty of headroom)
- Concurrent executions: 20
- Max execution time: 1 hour

**At Trinity scale (1,600 tasks/month):**
- 3% of paid tier capacity → Still under free tier with room to grow

### Cost Projection

| Scenario | Tasks/Month | n8n Cost | Other Costs | Total |
|----------|---|---|---|---|
| Current (P1+P2+P3) | 1,600 | $50 | $0 | $50 |
| 2x P2 (100 clients) | 3,000 | $50 | $0 | $50 |
| 3x P3 (100k visitors) | 5,000 | $50 | $0 | $50 |
| All 3x scale | 7,000 | $50 | $0 | $50 |

**Conclusion:** n8n paid tier ($50/mo) is sufficient for at least 10x revenue growth. Next upgrade needed at ~500k tasks/month (enterprise tier).

---

**END OF SPECIFICATIONS**

**Ready for implementation. Awaiting board approval.**
