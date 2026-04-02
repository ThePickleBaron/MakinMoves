# Trinity n8n Node Reference Card — Implementation Cheat Sheet

**Use during build:** Print or bookmark this page
**Updated:** 2026-03-29
**Workflows:** All 5 Trinity automations

---

## Quick Node Type Reference

### Trigger Nodes (Start workflow)
| Node Type | Used In | Config |
|-----------|---------|--------|
| **Webhook** | All 5 | Set path (e.g., `/gumroad/product-created`) |
| **Cron/Schedule** | Optional | Set interval (hourly, daily, specific time) |

### Logic Nodes (Transform data)
| Node Type | Used In | Config |
|-----------|---------|--------|
| **Code** | All 5 | JavaScript; input `$input.json`, output `return {...}` |
| **If/Then** | 3, 5 | Set condition; routes true/false paths |
| **Loop** | 2, 4, 5 | Set iterations; access current item in loop |
| **Set** | Reference | Map/rename fields before sending to API |

### API Nodes (Call external services)
| Node Type | Used In | Config |
|-----------|---------|--------|
| **HTTP Request** | 2, 3, 4 | Method, URL, auth headers, body |
| **PostgreSQL** | All 5 | Connection, query (SQL), params array |
| **Gmail** | 1, 2, 3, 4 | Recipient, subject, HTML body |
| **Slack** | 5 | Channel, message text |
| **HubSpot** | 2, 3 | Operation (create/update), properties |
| **Webhook Response** | All 5 | Status code, body JSON |

---

## Node Configuration Templates

### Webhook (Trigger)
```json
{
  "type": "webhook",
  "webhookPath": "/service/event",
  "httpMethod": "POST",
  "authentication": "headerAuth",
  "headerName": "X-Signature",
  "headerValue": "$env.WEBHOOK_SECRET"
}
```
**Test:** `curl -X POST https://n8n.io/webhook/service/event -d '{...}'`

### Code Node (Logic)
```javascript
// Input: $input.json (previous node output)
// Output: return { key: value }

const data = $input.json;
const result = {
  field1: data.property1,
  field2: data.property2 || 'default'
};

return result;
```
**Debug:** Click "Execute Node" to test; check output tab

### PostgreSQL Node (Database)
```json
{
  "type": "postgresDatabase",
  "operation": "executeQuery",
  "query": "SELECT * FROM table WHERE id = $1",
  "queryParams": ["{{ $input.json.id }}"]
}
```
**Params:** Array of values; $1, $2, $3 match array order

### HTTP Request (API Call)
```json
{
  "type": "httpRequest",
  "method": "POST",
  "url": "https://api.service.com/endpoint",
  "authentication": "headerAuth",
  "headers": {
    "Authorization": "Bearer {{ $env.API_KEY }}"
  },
  "body": {
    "field": "{{ $input.json.value }}"
  }
}
```
**Retry:** Set "Retry on fail: YES", max retries 3

### If/Then Node (Conditional)
```json
{
  "type": "ifThen",
  "condition": "{{ $input.json.status === 'success' }}"
}
```
**Routes:** True path (default) and false path (else)

### Loop Node (Iterate)
```json
{
  "type": "loop",
  "iterations": "{{ $input.json.items.length }}"
}
```
**Access in loop:** `$input.json.items[$loop.index]` or `$input.json.items[$loop.value]`

### Gmail Node (Send Email)
```json
{
  "type": "gmail",
  "operation": "send",
  "to": "{{ $input.json.recipient_email }}",
  "subject": "Subject line here",
  "html": "<h2>{{ $input.json.title }}</h2><p>Body text</p>"
}
```
**HTML:** Build in Code node, pass to Gmail node

### Slack Node (Send Message)
```json
{
  "type": "slack",
  "operation": "send",
  "channel": "#channel-name",
  "text": "🎉 Message text with {{ $input.json.value }}"
}
```
**Emojis:** Use in message text

### HubSpot Node (CRM)
```json
{
  "type": "hubspotCRM",
  "operation": "contacts.create",
  "properties": {
    "email": "{{ $input.json.email }}",
    "firstname": "{{ $input.json.first_name }}"
  }
}
```
**Operations:** contacts.create, contacts.update, deals.create, deals.update

### Webhook Response (End)
```json
{
  "type": "respondToWebhook",
  "statusCode": 200,
  "body": {
    "status": "success",
    "message": "Processing complete"
  }
}
```
**Status codes:** 200 (success), 400 (bad request), 401 (unauthorized), 500 (error)

---

## Workflow Structure Template

Every workflow should follow this pattern:

```
1. TRIGGER
   ├─ Webhook or Cron

2. VALIDATE
   ├─ Code node: Check for required fields
   └─ Return error if invalid

3. EXTRACT
   ├─ Code node: Parse and normalize data
   └─ Return clean object

4. LOOKUP (if needed)
   ├─ PostgreSQL: Query existing record
   └─ Use If/Then to route based on result

5. PROCESS
   ├─ Code node: Transform or calculate
   ├─ API call: Create/update record
   └─ PostgreSQL: Log event

6. NOTIFY
   ├─ Email: Send to recipient
   ├─ Slack: Send to channel
   └─ PostgreSQL: Log notification

7. RESPOND
   └─ Webhook response: Confirm to caller
```

---

## Common Code Patterns

### Parse JSON String
```javascript
const data = JSON.parse($input.json.body_string);
return data;
```

### Extract Array Item
```javascript
const items = $input.json.results;
const firstItem = items[0];
return { item: firstItem };
```

### Format Date
```javascript
const date = new Date($input.json.timestamp);
return { formatted: date.toISOString().split('T')[0] };
```

### String Interpolation in Template
```
"field": "{{ $input.json.first_name }} {{ $input.json.last_name }}"
```

### Conditional Value
```
"field": "{{ $input.json.status === 'active' ? 'yes' : 'no' }}"
```

### Loop Index
```javascript
// Inside loop node:
const current = $input.json.items[$loop.index];
return { item: current };
```

### Build HTML Email
```javascript
const html = `
  <h2>${$input.json.title}</h2>
  <p>Amount: $${$input.json.amount.toFixed(2)}</p>
  <a href="${$input.json.link}">Click here</a>
`;
return { html: html };
```

---

## Connection String Reference

### PostgreSQL
```
Host: {{ $env.POSTGRES_HOST }}
Port: 5432
User: {{ $env.POSTGRES_USER }}
Password: {{ $env.POSTGRES_PASSWORD }}
Database: {{ $env.POSTGRES_DB }}
```

### Gmail
```
OAuth2 flow or Service Account JSON
From: noreply@makinmoves.io
```

### Slack
```
Webhook URL: {{ $env.SLACK_WEBHOOK }}
Or: Bot token + channel ID
```

### HubSpot
```
API Key: {{ $env.HUBSPOT_API_KEY }}
Base URL: https://api.hubapi.com
```

### Wave
```
API Key: {{ $env.WAVE_API_KEY }}
GraphQL endpoint: https://api.waveapps.com/graphql
```

### Stripe
```
API Key: {{ $env.STRIPE_API_KEY }}
Webhook Secret: {{ $env.STRIPE_WEBHOOK_SECRET }}
Base URL: https://api.stripe.com/v1
```

---

## Debugging Checklist

| Issue | Check |
|-------|-------|
| Webhook not triggering | Is path correct? Check n8n webhook settings |
| Code node error | Check JavaScript syntax; console.log in browser |
| API returns 401 | Check API key in environment; test token validity |
| PostgreSQL fails | Check connection; verify table/column names |
| Email not sent | Check recipient; test with your own email first |
| Conditional not routing | Check condition syntax; use Expression builder |
| Loop not iterating | Verify iterations > 0; check array is not empty |
| Data missing in output | Check input format; log intermediate values |

---

## Error Handling Pattern

Every critical workflow should have:

```
Main workflow
    ↓
Error occurs
    ↓
Error trigger (separate workflow or error catch)
    ↓
Log error to PostgreSQL
    ↓
Send Slack alert
    ↓
Send email to CTMO
```

**In node:** Set "Continue on error" if error is non-critical
**At workflow level:** Add error workflow trigger

---

## Performance Tips

### Reduce Task Count
1. **Combine nodes:** Don't split logic across 3 Code nodes; use 1
2. **Avoid loops:** Use SQL batch INSERT instead of loop
3. **Skip unnecessary steps:** Use If/Then to skip optional processes

### Reduce Execution Time
1. **Parallel API calls:** Use multiple HTTP nodes together (not sequential)
2. **Cache lookups:** Load data once, pass through workflow (don't re-query)
3. **Batch operations:** Group 10 inserts into 1 query instead of 10 queries

### Monitor & Alert
1. **Execution time:** Should be < 30s for all workflows
2. **Task count:** Should be < 2,000/month for $50/mo plan
3. **Failure rate:** Should be < 1% (99% success)

---

## Quick Reference: n8n Expression Syntax

| Expression | Returns | Example |
|-----------|---------|---------|
| `{{ $input.json.field }}` | Field value | `{{ $input.json.email }}` |
| `{{ $input.json.field.toUpperCase() }}` | Uppercase | `{{ $input.json.name.toUpperCase() }}` |
| `{{ $input.json.created | formatDate('YYYY-MM-DD') }}` | Formatted date | (in Set node) |
| `{{ $input.json.amount ? 'yes' : 'no' }}` | Conditional | `{{ $input.json.status === 'paid' ? 'confirmed' : 'pending' }}` |
| `{{ $input.json.items.length }}` | Array length | `{{ $input.json.results.length }}` |
| `{{ $now.toISOString() }}` | Current timestamp | `{{ $now.toISOString() }}` |
| `{{ $env.API_KEY }}` | Environment variable | `{{ $env.STRIPE_API_KEY }}` |
| `{{ JSON.stringify($input.json) }}` | JSON string | For API body |

---

## Webhook Testing Commands

### Test Gumroad Webhook
```bash
curl -X POST https://n8n-instance.com/webhook/gumroad/product-created \
  -H "X-Gumroad-Signature: test-sig" \
  -H "Content-Type: application/json" \
  -d '{"product": {"id": "TEST", "name": "Product", "price": 29.99}}'
```

### Test Calendly Webhook
```bash
curl -X POST https://n8n-instance.com/webhook/calendly/booking-created \
  -H "Content-Type: application/json" \
  -d '{"invitee": {"name": "Test", "email": "test@test.com"}, "scheduled_event": {"title": "Consultation"}}'
```

### Test Stripe Webhook
```bash
curl -X POST https://n8n-instance.com/webhook/stripe/charge-succeeded \
  -H "Stripe-Signature: test-sig" \
  -H "Content-Type: application/json" \
  -d '{"data": {"object": {"id": "ch_123", "amount": 5000}}}'
```

### Test WordPress Webhook
```bash
curl -X POST https://n8n-instance.com/webhook/wordpress/post-published \
  -H "Content-Type: application/json" \
  -d '{"post_id": 123, "title": "Test Post", "content": "Post content"}'
```

### Test Affiliate Webhook
```bash
curl -X POST https://n8n-instance.com/webhook/affiliate/webhook \
  -H "Content-Type: application/json" \
  -d '{"event_type": "commission", "amount": 150, "click_id": "CLK123"}'
```

---

## Common Task Count Calculations

**For cost estimation:**
- 1 webhook trigger = 1 task
- 1 Code node = 1 task
- 1 API call (HTTP, PostgreSQL, Gmail, etc.) = 1 task
- 1 conditional branch = 0.5 task
- 1 loop iteration = 1 task per iteration

**Example:** Workflow with webhook → 3 Code nodes → 2 API calls → response = 7 tasks

---

## Success Checklist Before Deploying

- [ ] All 5 workflows created in n8n
- [ ] All workflows tested with sample data
- [ ] All error paths tested
- [ ] Email notifications working
- [ ] Slack alerts working
- [ ] PostgreSQL inserts verified
- [ ] Webhook URLs registered in platforms
- [ ] Environment variables set in n8n
- [ ] Log retention configured
- [ ] Backups enabled
- [ ] COO trained on monitoring

---

## Emergency Pause Procedure

If something goes wrong in production:

1. **In n8n:** Disable workflow (toggle off)
2. **In platform:** Disable webhook sending (if possible)
3. **Notify team:** Slack alert in #critical-alerts
4. **Diagnose:** Check error logs
5. **Fix:** Make changes to workflow
6. **Test:** Run test execution
7. **Redeploy:** Enable workflow + re-enable webhooks
8. **Monitor:** Watch for new errors

---

**Print this page. Keep it near your desk during build.**

**Questions? See the full specifications in TRINITY_N8N_WORKFLOW_SPECIFICATIONS_MASTER_2026-03-29.md**
