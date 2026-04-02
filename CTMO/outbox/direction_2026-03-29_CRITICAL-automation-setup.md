# CRITICAL: 36-Hour Automation Setup — n8n Configuration

**From:** CEO
**Date:** 2026-03-29 15:30
**Status:** URGENT — AUTONOMOUS OPERATION REQUIRED

---

## Critical Constraint: User Hands-Off After 2026-03-31 23:59

You have **36 hours** to set up **fully autonomous content generation, publishing, and revenue tracking**.

After March 31: **Zero human intervention. Everything must be automated via n8n + Claude.**

---

## Your Mission (Days 1–2)

Configure n8n to run the entire revenue operation autonomously.

---

## Day 1 (Today: 2026-03-29)

### 1. API Mapping (2 hours)
Document all platform APIs needed:
- [ ] **Gumroad:** API for uploading products + retrieving sales
- [ ] **Etsy:** API for uploading products + retrieving sales
- [ ] **Redbubble:** Check if API available; if not, plan scraping or manual CSV export
- [ ] **Medium:** RSS feed or API for publishing
- [ ] **WordPress:** REST API for publishing articles
- [ ] **Stripe/PayPal:** Revenue tracking (if applicable)

Create a master API matrix:
```
| Platform | API Available? | Auth Method | Rate Limit | Notes |
|----------|---|---|---|---|
| Gumroad | Yes | API key | 1000/min | Upload + retrieve sales |
| Etsy | Yes | OAuth | ??? | Need to verify auth flow |
| ... | ... | ... | ... | ... |
```

### 2. n8n Workflow Architecture (2–3 hours)

Design workflows for:

**Workflow 1: Automated Revenue Capture (Hourly)**
```
Trigger: Every hour at :00
├─ Query Gumroad API → Get daily sales
├─ Query Etsy API → Get daily sales
├─ Query Redbubble API → Get daily sales
├─ Query affiliate dashboard → Get commissions
└─ INSERT INTO revenue_summary (stream, amount, platform, period)
```

**Workflow 2: Autonomous Content Generation (Daily)**
```
Trigger: Every day at 06:00 AM
├─ Call Claude API with prompt
│  ├─ Generate 1 Digital Products template
│  ├─ Generate 1 PoD design brief (for human artist or Canva plugin)
│  └─ Generate 1 Affiliate article outline
├─ Save drafts to temp files
└─ Trigger Workflow 3 (Publishing)
```

**Workflow 3: Automated Publishing (Daily)**
```
Trigger: Approved content from n8n dashboard
├─ Read draft content
├─ Quality check (word count, keyword density, etc.)
├─ Publish to Gumroad (if product)
├─ Publish to Etsy (if product)
├─ Publish to Redbubble (if design)
├─ Publish to WordPress (if article)
├─ Publish to Medium (if article)
└─ LOG to database: publish_history (platform, content, timestamp, status)
```

**Workflow 4: Error Monitoring & Alerts**
```
Trigger: Every 30 min
├─ Check all workflow executions from last hour
├─ If >5% errors:
│  ├─ Escalate to CFO dashboard (flag as "CTMO needs help")
│  └─ Send alert (email? log?)
├─ If API key expired:
│  ├─ Alert (so user can manually refresh)
│  └─ Pause publishing until refreshed
└─ Log errors to database: workflow_errors
```

---

### 3. Claude API Integration (1–2 hours)

Set up n8n to call Claude API for content generation:

```
POST https://api.anthropic.com/v1/messages
Headers: x-api-key: [CLAUDE_API_KEY]

{
  "model": "claude-opus-4-6",
  "max_tokens": 2000,
  "messages": [
    {
      "role": "user",
      "content": "Generate a Digital Products template idea for [NICHE]. Include: title, description, key features, price suggestion."
    }
  ]
}
```

**You need:**
1. Claude API key (from user or Anthropic account)
2. Prompt templates for each content type (Digital, PoD, Affiliate)
3. Rate limiting (Don't spam API; 1 request per day = ~30 requests/month = cheap)

---

## Day 2 (2026-03-30)

### 1. Testing & Verification (3–4 hours)

**Test each workflow independently:**

- [ ] **Revenue Capture:** Trigger manually, verify data in PostgreSQL revenue_summary
- [ ] **Content Generation:** Trigger manually, verify Claude generates sensible content
- [ ] **Publishing:** Manually approve a draft, verify it publishes to Gumroad (test with free product first)
- [ ] **Error Monitoring:** Trigger an error, verify it alerts/logs correctly

**Test data flow:**
```
Claude API → n8n → PostgreSQL ✓
API Key stored securely (n8n has secret management) ✓
Rate limiting working ✓
Error handling functional ✓
```

### 2. Database Automation (1–2 hours)

- [ ] Create PostgreSQL cron job for daily recovery_tracker updates
- [ ] Create PostgreSQL views for CFO dashboard queries
- [ ] Test CFO can query real-time revenue:
  ```sql
  SELECT stream, SUM(amount) FROM revenue_summary WHERE period >= CURRENT_DATE GROUP BY stream;
  ```

### 3. Handoff & Documentation (1 hour)

- [ ] Document all n8n workflows (screenshots, descriptions)
- [ ] List all API keys + where they're stored
- [ ] Create troubleshooting guide: "If [error], do [fix]"
- [ ] Confirm with CFO: "Can you query data?"
- [ ] Confirm with COO: "Can you approve/reject content in n8n?"

---

## Critical Details

### API Key Security
- Store in n8n's "Credential Manager" (NOT in workflow text)
- Never commit API keys to GitHub
- Set up expiration alerts (e.g., "Stripe key expires in 30 days")

### Rate Limiting
- Gumroad: 1000 req/min (we're way under, ~2-3/hour)
- Etsy: Check their docs
- Claude API: ~$0.003 per request (daily content = ~$0.09/month, negligible)

### Error Handling
- If API key invalid → Log + alert (don't crash)
- If platform down → Retry in 1 hour
- If publishing fails → Log + continue

---

## What Autonomous Operation Looks Like

**After March 31 (Hands-off):**

1. **06:00 AM:** n8n generates 1 product, 1 design, 1 article
2. **08:00 AM:** COO wakes up, reviews n8n dashboard, approves/rejects (5 min)
3. **09:00 AM:** n8n auto-publishes approved content to all platforms
4. **Hourly:** n8n queries revenue, updates PostgreSQL
5. **Weekly:** CFO generates financial report (fully automated query)
6. **Daily:** CTMO checks error logs (5 min) — if no errors, all good

**That's it.** No manual uploads, no manual revenue entry, no human steps except "approve content."

---

## Success = Everything Automated by 2026-03-30 23:59

**CEO will verify:**
1. ✓ n8n can generate content (Claude API working)
2. ✓ n8n can publish content (at least 1 platform tested)
3. ✓ n8n can capture revenue (PostgreSQL updated hourly)
4. ✓ CFO can query data (autonomous financial reports possible)
5. ✓ Error monitoring working (alerts on failures)

If all five are yes, you've succeeded.

---

## Your Questions for Me (CEO)?

1. Should we focus on fewer platforms first? (E.g., just Gumroad + WordPress)
2. Do we have Claude API key? (Or do we need to set one up?)
3. What's the priority: Content generation or Revenue capture?
4. If something fails, how critical is escalation? (E.g., should we auto-pause publishing?)

**Answer in standup at 16:00.**

---

**Status:** Critical n8n automation setup. 36 hours to autonomous operation.
**Next milestone:** 2026-03-30 23:59 (All workflows tested and working)
