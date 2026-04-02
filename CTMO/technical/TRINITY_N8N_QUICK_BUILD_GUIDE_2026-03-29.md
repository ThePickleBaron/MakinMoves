# Trinity n8n Quick Build Guide — Implementation Fast-Track

**Status:** Detailed specs + quick reference ready
**Target Audience:** CTMO building workflows
**Time to read:** 15 minutes
**Time to build all 5:** 12-14 hours

---

## TL;DR: What You're Building

5 automated workflows that connect Trinity's revenue streams:

1. **Gumroad Launch** → Detect new products, log to DB, notify COO
2. **Client Intake** → Calendly booking → HubSpot → Wave invoice → Payment link → Email
3. **Payment Tracking** → Stripe webhook → Mark paid in Wave → Update HubSpot deal
4. **Content Publishing** → WordPress post → Inject affiliate links → Submit to GSC → Email
5. **Affiliate Revenue** → Track clicks + commissions → Log to DB → Alert on big sales

**Total n8n monthly tasks:** ~1,600 (fits in paid tier at $50/mo)

---

## Build Order (Fastest Path)

### 1. Setup (30 min)
- [ ] Create PostgreSQL database
- [ ] Set up n8n instance
- [ ] Add credentials (Gumroad, HubSpot, Wave, Stripe, WordPress, Slack, Gmail)

### 2. Workflow 1: Gumroad Launch (2 hours)
**Nodes:** 8 (webhook → validate → extract → PostgreSQL → email)
**Complexity:** Low
**Dependencies:** None

### 3. Workflow 2: Client Intake (3 hours)
**Nodes:** 12 (webhook → HubSpot → Wave → Stripe link → emails)
**Complexity:** Medium
**Dependencies:** HubSpot + Wave accounts configured

### 4. Workflow 3: Payment Tracking (2 hours)
**Nodes:** 12 (webhook → PostgreSQL lookup → Wave/HubSpot update → emails)
**Complexity:** Medium
**Dependencies:** Workflow 2 complete (references client_intakes table)

### 5. Workflow 4: Content Publishing (3 hours)
**Nodes:** 16 (webhook → identify affiliates → update WP → GSC submit → email)
**Complexity:** High (most nodes)
**Dependencies:** None

### 6. Workflow 5: Affiliate Tracking (2 hours)
**Nodes:** 12 (webhook → lookup link → log click → check commission → alert)
**Complexity:** Medium
**Dependencies:** Workflow 4 complete (references affiliate_links table)

**Total: 12-14 hours**

---

## Quick Reference: Node Count Per Workflow

### Workflow 1: Gumroad (8 nodes)
```
Webhook → Code → PostgreSQL(2) → Code → Gmail → PostgreSQL → Response
```

### Workflow 2: Client Intake (12 nodes)
```
Webhook → Code → HubSpot(2) → Code → Wave → Code(2) → Gmail(2) → PostgreSQL → Response
```

### Workflow 3: Payment Tracking (12 nodes)
```
Webhook → Code → PostgreSQL → If/Then → PostgreSQL(2) → HTTP → HubSpot → Code → Gmail(2) → PostgreSQL → Response
```

### Workflow 4: Content Publishing (16 nodes)
```
Webhook → Code(3) → HTTP/WordPress → Code → HTTP/GSC → PostgreSQL → Code/Loop → PostgreSQL → Code → Gmail → PostgreSQL → Response
```

### Workflow 5: Affiliate Revenue (12 nodes)
```
Webhook → Code → PostgreSQL → If/Then → PostgreSQL(2) → If/Then → Code → Slack → PostgreSQL → Response
```

---

## Testing Each Workflow (5 minutes each)

### Workflow 1 Test
```bash
curl -X POST https://n8n-instance.com/webhook/gumroad/product-created \
  -H "X-Gumroad-Signature: test" \
  -d '{"product": {"id": "TEST123", "name": "Test Product", "price": 29.99}}'

Verify:
- [ ] n8n shows successful execution
- [ ] New row in digital_products table
- [ ] Email sent to COO
```

### Workflow 2 Test
```bash
curl -X POST https://n8n-instance.com/webhook/calendly/booking-created \
  -d '{"invitee": {"name": "Test Client", "email": "test@example.com"}, ...}'

Verify:
- [ ] HubSpot contact created
- [ ] HubSpot deal created
- [ ] Wave invoice generated
- [ ] Email sent to client with payment link
- [ ] Email sent to COO
```

### Workflow 3 Test
```bash
# Simulate Stripe webhook
curl -X POST https://n8n-instance.com/webhook/stripe/charge-succeeded \
  -H "Stripe-Signature: test" \
  -d '{"data": {"object": {"id": "ch_123", "amount": 75000, ...}}}'

Verify:
- [ ] client_intakes.status updated to "payment_received"
- [ ] Wave invoice marked paid
- [ ] HubSpot deal stage updated
- [ ] Receipt email sent to client
- [ ] Confirmation email sent to COO
```

### Workflow 4 Test
```bash
curl -X POST https://n8n-instance.com/webhook/wordpress/post-published \
  -d '{"post_id": 123, "title": "Test Article", "content": "...mentions Zapier..."}'

Verify:
- [ ] WordPress post updated with affiliate links
- [ ] published_articles row inserted
- [ ] affiliate_links rows inserted (1 per link)
- [ ] Email announcement sent
- [ ] Google Search Console has URL
```

### Workflow 5 Test
```bash
curl -X POST https://n8n-instance.com/webhook/affiliate/webhook \
  -d '{"event_type": "commission", "amount": 150, "click_id": "CLK123"}'

Verify:
- [ ] affiliate_links.total_commission updated
- [ ] commissions row inserted
- [ ] recovery_tracker.affiliate_revenue updated
- [ ] Slack alert sent (amount > $100)
```

---

## Credential Setup Checklist

### Gumroad
- [ ] API key: `$env.GUMROAD_API_KEY`
- [ ] Webhook secret: `$env.GUMROAD_WEBHOOK_SECRET`
- [ ] Test: Can list products via API

### HubSpot
- [ ] Private app token: `$env.HUBSPOT_API_KEY`
- [ ] COO owner ID: `$env.HUBSPOT_COO_OWNER_ID`
- [ ] Test: Can create contact

### Wave
- [ ] API key: `$env.WAVE_API_KEY`
- [ ] Account ID: `$env.WAVE_ACCOUNT_ID`
- [ ] Test: Can list invoices

### Stripe
- [ ] API key: `$env.STRIPE_API_KEY`
- [ ] Webhook secret: `$env.STRIPE_WEBHOOK_SECRET`
- [ ] Test: Can retrieve charges

### WordPress
- [ ] API user: `$env.WP_API_USER`
- [ ] App password: `$env.WP_API_PASSWORD`
- [ ] Site URL: `https://makinmoves.io`
- [ ] Test: Can list posts

### Google Search Console
- [ ] API key: `$env.GOOGLE_API_KEY`
- [ ] Test: Can submit URL

### Gmail
- [ ] Service account JSON: `$env.GMAIL_SERVICE_ACCOUNT`
- [ ] COO email: `$env.COO_EMAIL`
- [ ] CTMO email: `$env.CTMO_EMAIL`
- [ ] Test: Can send email

### Slack
- [ ] Webhook URL: `$env.SLACK_WEBHOOK`
- [ ] Test: Can post message

### Database (PostgreSQL)
- [ ] Host: `$env.POSTGRES_HOST`
- [ ] User: `$env.POSTGRES_USER`
- [ ] Password: `$env.POSTGRES_PASSWORD`
- [ ] Database: `$env.POSTGRES_DB`
- [ ] Test: Can connect and query

---

## Common Issues & Quick Fixes

### "Webhook returns 401 Unauthorized"
**Cause:** Invalid signature or missing secret
**Fix:**
- [ ] Verify webhook secret in n8n environment
- [ ] Check header name matches (X-Gumroad-Signature vs Stripe-Signature)
- [ ] Test with hardcoded test signature first

### "PostgreSQL column count mismatch"
**Cause:** Query params don't match column count
**Fix:**
- [ ] Count columns in INSERT statement
- [ ] Count params in VALUES clause
- [ ] Ensure order matches table schema

### "HubSpot returns 401 Unauthorized"
**Cause:** API key invalid or expired
**Fix:**
- [ ] Regenerate API key in HubSpot settings
- [ ] Update `$env.HUBSPOT_API_KEY`
- [ ] Test connection immediately after updating

### "Email not sending"
**Cause:** Gmail credentials, SMTP settings, or rate limits
**Fix:**
- [ ] Verify Gmail app password is correct (not regular password)
- [ ] Check recipient email is not in spam (test with different email)
- [ ] If rate limited, add delay between email sends (use Sleep node)

### "Wave API returns 429 (rate limited)"
**Cause:** Too many requests in short time
**Fix:**
- [ ] Add retry logic in HTTP node (3 retries, exponential backoff)
- [ ] Increase batch interval to 1000ms
- [ ] Stagger invoice creation if bulk importing

### "Affiliate link injection not working"
**Cause:** Regex doesn't match keyword in content
**Fix:**
- [ ] Test regex with sample content (use online regex tester)
- [ ] Ensure keyword appears in content (not truncated)
- [ ] Case-insensitive flag: `/keyword/gi` not `/keyword/`

---

## Performance Tuning

### Reduce Execution Time
1. **Parallel execution:** Use Loop node with `Batch Size: 10` instead of sequential
2. **Batch database inserts:** Use single INSERT with multiple rows instead of loop
3. **Cache lookups:** Use PostgreSQL JOIN instead of separate query + code node

### Reduce Task Count
1. **Combine nodes:** Use single Code node for multiple transformations
2. **Avoid unnecessary loops:** Check if you really need to iterate
3. **Conditional logic:** Use If/Then to skip unnecessary steps

### Example: Batch Insert Instead of Loop
```javascript
// BAD: Loop over 100 links, insert one at a time = 100 queries
FOR item IN items:
  INSERT INTO affiliate_links VALUES (item)

// GOOD: Single INSERT with multiple rows = 1 query
INSERT INTO affiliate_links VALUES
  (item1),
  (item2),
  ...
  (item100)
```

---

## Monitoring & Maintenance (Monthly Checklist)

- [ ] Check n8n error logs (should have < 5% failure rate)
- [ ] Verify webhook endpoints are still active (no 404s)
- [ ] Check database disk usage (should be < 80%)
- [ ] Review PostgreSQL query performance (any slow queries?)
- [ ] Test end-to-end workflow with real data
- [ ] Verify email deliverability (check spam folder)
- [ ] Confirm Slack alerts are working
- [ ] Review recovery_tracker totals match manual accounting

---

## Deployment Checklist

Before going live:

- [ ] All 5 workflows created and tested
- [ ] All environment variables set
- [ ] Database tables created and schema verified
- [ ] Webhook URLs registered in each platform
- [ ] Error handling configured (workflows have error catches)
- [ ] Email templates reviewed and approved
- [ ] Slack channels created and tested
- [ ] COO trained on monitoring dashboard
- [ ] CTMO has runbook for common issues
- [ ] Database backups enabled
- [ ] Log retention configured
- [ ] Performance baseline captured

---

## Files to Reference During Build

1. **Main specification:** `TRINITY_N8N_WORKFLOW_SPECIFICATIONS_MASTER_2026-03-29.md`
   - Complete pseudo-code for each workflow
   - Node-by-node JSON configuration
   - Sample test data
   - Error handling details

2. **Database schema:** See CTMO technical folder for `autonomous-cfo-schema.sql`
   - All tables defined with indices
   - Relationships between tables
   - Sample data inserts

3. **Node reference:** `n8n-node-configuration-reference.md`
   - Common node types and settings
   - Authentication methods
   - Example configurations

---

## Build Timeline (Realistic Estimates)

| Phase | Task | Duration | Cumulative |
|-------|------|----------|-----------|
| Setup | PostgreSQL + n8n + credentials | 30 min | 30 min |
| Workflow 1 | Gumroad Launch (8 nodes) | 2 hours | 2h 30m |
| Workflow 2 | Client Intake (12 nodes) | 3 hours | 5h 30m |
| Workflow 3 | Payment Tracking (12 nodes) | 2 hours | 7h 30m |
| Workflow 4 | Content Publishing (16 nodes) | 3 hours | 10h 30m |
| Workflow 5 | Affiliate Revenue (12 nodes) | 2 hours | 12h 30m |
| Testing | End-to-end tests + fixes | 1 hour | 13h 30m |
| Deployment | Register webhooks, go live | 30 min | 14 hours |

**With debugging, breaks, and unexpected issues: 16-18 hours total**

---

## Success Criteria

After building all 5 workflows:

✅ All webhooks fire without errors
✅ Database inserts succeed (query tables to verify)
✅ Emails are sent (check inbox)
✅ Integration between workflows works (e.g., Workflow 2 creates deal that Workflow 3 updates)
✅ Error handling catches and logs errors
✅ Slack alerts fire when conditions met
✅ Monthly task count < 2,000 (fits in $50/mo n8n plan)
✅ Average execution time < 30 seconds per workflow
✅ Workflow failure rate < 1%

---

## Next Steps After Build

1. **Day 1:** Deploy and monitor (no live traffic, just testing)
2. **Day 2:** Small traffic test (10% of expected volume)
3. **Day 3:** Full production (100% live traffic)
4. **Week 1:** Daily monitoring, catch edge cases
5. **Week 2+:** Weekly review, optimize based on metrics

---

**Ready to build. Let's go.**
