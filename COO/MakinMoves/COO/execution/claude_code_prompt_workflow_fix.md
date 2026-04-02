# Claude Code Prompt — Gumroad Workflow Fix & Publish

Paste this into Claude Code CLI:

---

I need you to fix and publish a Gumroad email workflow. Here's the context:

## Environment
- Gumroad access token: read from `.env` file in current directory (GUMROAD_ACCESS_TOKEN)
- Gumroad public API base: `https://api.gumroad.com/v2`
- The Gumroad dashboard UI is broken (SPA crashes on null workflow name)

## What exists
3 Gumroad products are live:
- AI Prompts for Freelancers ($24) — id: OxAI6JHVbBY4dl1o3SvheQ==, permalink: ai-prompts-freelancers
- Freelancer Invoice + Client Tracker ($39) — id: pOjCKwx79U5NIn4ciJu6ag==, permalink: notion-freelancer-tracker
- Freelance Starter Kit Bundle ($49) — id: CpCjZQ1npVJlSK3ioQqfag==, permalink: freelance-starter-kit

1 workflow exists but is UNPUBLISHED:
- Workflow ID: fL3ZYiqpuwjgyquiJ03TpA==
- Name field is NULL (causing UI crash)
- Has 3 emails configured (welcome, day-1 tips, day-5 cross-sell)
- published: false

## Tasks (in order)

### 1. Verify API access
Use curl to hit `https://api.gumroad.com/v2/products?access_token=TOKEN` and confirm products are returned.

### 2. Try to publish the workflow
The Gumroad v2 public API may not support workflows directly. Try these approaches:

**Approach A**: Check if there's an undocumented workflow endpoint:
```
curl -X PUT "https://api.gumroad.com/v2/workflows/fL3ZYiqpuwjgyquiJ03TpA==" \
  -d "access_token=TOKEN" \
  -d "published=true" \
  -d "name=P1 — AI Prompts Post-Purchase Sequence"
```

**Approach B**: Try the internal Gumroad dashboard API (may need session cookie from browser):
```
curl -X PATCH "https://gumroad.com/workflows/fL3ZYiqpuwjgyquiJ03TpA==" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"workflow":{"published":true,"name":"P1 — AI Prompts Post-Purchase Sequence"},"send_to_past_customers":false}'
```

**Approach C**: If API approaches fail, use Puppeteer or Playwright to:
1. Log into gumroad.com (credentials: j.s.mclarty@gmail.com — ask user for password)
2. Navigate to https://gumroad.com/workflows/fL3ZYiqpuwjgyquiJ03TpA==/emails
3. Inject JS to fix null names: patch JSON.parse before SPA renders
4. Click Publish → Publish now

### 3. Create P2 email workflow
If you can create workflows via API or browser automation, create a second workflow:
- Name: "P2 — Notion Template Post-Purchase Sequence"
- Trigger: Purchase of product permalink "mjgxpu" (Notion Template)
- Email 1 (0 hours): Subject "Your Notion Tracker is ready" — welcome + setup tips
- Email 2 (1 day): Subject "3 views to set up first" — Client Pipeline, Invoice Tracker, Revenue Dashboard
- Email 3 (5 days): Subject "The other half of the system" — cross-sell AI Prompts bundle

### 4. Build a sales monitoring script
Create a Python script `check_sales.py` that:
- Reads GUMROAD_ACCESS_TOKEN from .env
- Hits GET /v2/sales?access_token=TOKEN
- Prints a summary: total sales, revenue, per-product breakdown
- Can be run on demand or scheduled

Save all files to the current project directory.
