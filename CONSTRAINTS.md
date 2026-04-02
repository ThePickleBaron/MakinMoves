# Financial Constraints & Boundaries

## Cost Limits (Hard Constraints)

### Monthly Infrastructure Budget
- **Maximum:** $100/month (all services combined)
- **Current allocation:**
  - Docker/PostgreSQL: ~$0 (self-hosted locally)
  - n8n (open-source): ~$0
  - Hosting (when SaaS ships): ~$20–50/mo max (Railway.app)
  - Tools/integrations: ~$20–30/mo max
- **Buffer:** Always maintain 20% budget cushion

### Upfront Costs (One-Time)
- **Maximum per stream:** $50
- **Total across all streams:** $150 max
- **Approved for:** Domain registration, small tool trials
- **NOT approved for:** Paid courses, ads, inventory

### Spending Rules

**TIER 1 — No Cost (Required First)**
- All free tiers of services (Google Analytics, Netlify free, TradingView free)
- Open-source tools (Backtrader, n8n open-source)
- Self-hosted services (Docker/PostgreSQL locally)

**TIER 2 — <$20/month (Approved if Revenue Justifies)**
- Gumroad: Free to list, 10% on sales (no cost)
- Stripe: 2.9% + $0.30 per transaction (only pay on sales)
- SendGrid: $10/mo only if SaaS has 50+ users
- Basic Ghost hosting: $29/mo only after $500/month revenue

**TIER 3 — $20–50/month (Only if Cash Flow Positive)**
- Railway.app for SaaS: Only if SaaS has recurring revenue
- Advanced tool subscriptions: Only if ROI is clear

**TIER 4 — $50+/month (Forbidden Until Profitable)**
- Paid ads/marketing
- Premium tool tiers
- Consultant/agency services
- Anything not directly generating revenue

---

## Revenue Requirements Before Spending

| Spending Level | Revenue Threshold | Who Approves |
|---|---|---|
| Free tier | Always allowed | CEO/CFO |
| <$20/mo | $0 (no revenue needed) | CEO/CFO |
| $20–50/mo | $500+/month combined revenue | CEO + CFO approval |
| $50–100/mo | $1000+/month combined revenue | CEO + CFO approval |
| >$100/mo | Profitability first (revenue > costs) | CEO + CFO approval |

---

## Recovery Timeline Constraints

### Mission-Critical Deadline
- **Recovery date:** [USER TO SET] (e.g., "must be cash-flow positive by end of Q2")
- **Monthly revenue target:** [USER TO SET] (e.g., "$500–1000/month by month 3")
- **Implications for spending:**
  - If deadline is <3 months: Minimize ALL non-essential spending
  - If deadline is 6+ months: Can allocate more to growth tools
  - If no deadline: Default to break-even by month 6

### Burn Rate Tolerance
- **Maximum monthly burn (negative cash flow):** [USER TO SET]
  - Example: "Max $50/month loss for first 3 months, then must be positive"
  - Default (recommended): Must be positive by month 4

---

## Budget Approval Workflow (CFO Enforces)

When CEO or COO requests spending approval:

```
Spending Request
  ↓
CFO Checks:
  1. Is it within tier and approval level?
  2. Is revenue threshold met?
  3. Does it conflict with recovery timeline?
  4. What's the ROI/payback period?
  ↓
CFO Responds:
  - APPROVED with reasoning
  - DENIED with reasoning
  - HOLD (ask for more data)
```

### Examples

**Request:** "Can we spend $50/mo on Ghost hosting for content site?"
- Revenue: $0 (not shipping yet)
- CFO: **DENIED** — Wait until content site generates $500+/month

**Request:** "Can we pay $15/mo for SendGrid email service?"
- Revenue: $0 (SaaS not live)
- CFO: **APPROVED** — Under $20 tier, no revenue needed, minimal cost

**Request:** "Can we run $500 Facebook ad campaign?"
- Revenue: $200/month (digital products)
- CFO: **DENIED** — Ads tier requires $1000+/month revenue and CEO approval

---

## Tracking Rules

### CFO Tracks Everything:
- All costs by category (infrastructure, tools, payment fees, etc.)
- Revenue vs. costs comparison (weekly)
- Burn rate (cost trend)
- Runway (months until out of money, if negative)

### CEO Sets Strategy:
- Spending approval based on revenue targets
- Timeline enforcement (are we on track to recovery date?)
- Trade-offs ("spend $30 more to ship faster?" vs. "minimize costs")

### COO Follows Constraints:
- Can't spend without CFO approval
- Can request budget but must provide ROI reasoning
- Must prioritize free/cheap solutions first

---

## Decision Matrix (CFO Reference)

| Situation | CFO Decision | CEO Involved? |
|---|---|---|
| <$20/mo, has revenue threshold met | APPROVE | No |
| <$20/mo, no revenue threshold | APPROVE | No |
| $20–50/mo, revenue threshold met | APPROVE | Yes |
| $20–50/mo, revenue threshold NOT met | DENY | Notify CEO |
| >$50/mo | DENY unless cash-flow positive | Yes, always |
| Conflicts with recovery deadline | DENY | Yes, escalate |

---

## Current Financial State

**Initialization (Day 1):**
- Revenue: $0
- Monthly costs: $0 (everything free/self-hosted)
- Burn rate: $0
- Runway: Unlimited (positive cash flow already)
- Recovery progress: 0%

**Budget allocation for first month:**
- Infrastructure: $0 (Docker locally)
- Domain registration: $0–15 (if needed)
- Tools: $0 (free tiers only)
- Ads/marketing: $0 (forbidden until revenue)
- **Total: $0–15/month to start**

---

## Flexibility & Review

- **Weekly:** CFO reviews spending vs. revenue
- **Monthly:** CEO + CFO review budget allocation
- **Quarterly:** Reassess constraints based on recovery progress
- **If recovery accelerating:** Can increase spending allocation
- **If recovery slowing:** Must tighten constraints further

---

## Explicit Constraints (Fill In Below)

**User to confirm:**

- [ ] Recovery deadline: __________ (date)
- [ ] Monthly revenue target: $__________ by __________
- [ ] Maximum monthly burn rate (negative cash flow): $__________ per month
- [ ] Maximum upfront per-stream cost: $__________
- [ ] Total upfront budget: $__________
- [ ] Infrastructure budget ceiling: $__________ per month

Once filled in, CFO will enforce these constraints in all budget decisions.

---

**Status:** Awaiting user input on financial boundaries
**Last Updated:** 2026-03-29
**Enforcer:** CFO (via CFO/outbox/)
