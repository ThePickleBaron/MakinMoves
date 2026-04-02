# CTMO Implementation Checklist: Infrastructure Scaling
**Date:** 2026-03-29
**Status:** Awaiting board decisions (CEO approval for Zapier/Bluehost)
**Owner:** CTMO
**Priority:** HIGH (blocks Month 1 execution)

---

## WAITING FOR BOARD DECISIONS

### [ ] Decision 1: Zapier vs n8n
**Status:** PENDING CEO APPROVAL
**Impact:** If not decided today, Month 1 workflows blocked

**What we're waiting for:**
- [ ] CEO sign-off on n8n migration (vs Zapier $29.99/mo)
- [ ] Confirmation that n8n budget is approved ($0 vs $360/year)

**Once Approved → Execute:**
- [ ] Audit current Zapier workflows (if any)
- [ ] List critical integrations needed in n8n
- [ ] Build n8n replacements (4-6 hours CTMO)
- [ ] Test end-to-end
- [ ] Remove Zapier from budget

---

### [ ] Decision 2: Bluehost VPS Upgrade Trigger
**Status:** PENDING CEO CONFIRMATION
**Impact:** Determines Month 3-4 cost and upgrade timing

**What we're waiting for:**
- [ ] CEO risk tolerance: Is 40k/mo acceptable trigger, or different?
- [ ] Confirmation that +$30-50/mo VPS cost is budgeted for Month 4

**Once Approved → Execute:**
- [ ] Document trigger: 40k combined visitors/month = upgrade decision
- [ ] Set Bluehost alerts (30k warning, 40k urgent)
- [ ] Create VPS upgrade SOP (steps, timing, vendor selection)
- [ ] Prepare quotes from Bluehost VPS, Kinsta, SiteGround VPS

---

## EXECUTE IMMEDIATELY (No approval needed)

### [ ] Bluehost Traffic Monitoring Setup
**Why:** Measure when we hit 40k/mo upgrade trigger
**Effort:** 30 minutes
**Steps:**
- [ ] Access Bluehost account dashboard
- [ ] Review current analytics setup (Google Analytics, cPanel)
- [ ] Create monitoring sheet: `ctmo/logs/bluehost_traffic_log_2026-03-29.csv`
  - Format: Date, Site Name, Monthly Visitors, Concurrent Users, Performance Notes
- [ ] Set reminder to check traffic weekly
- [ ] Create alerts: 12k (yellow flag), 20k (orange), 30k (red), 40k (upgrade trigger)

**Template:**
```
Date,Site_Name,Monthly_Visitors,Concurrent_Users,Performance_Notes
2026-03-29,site1.com,2500,5,normal
2026-03-29,site2.com,1800,3,normal
```

---

### [ ] PostgreSQL Baseline Documentation
**Why:** Establish baseline for transaction volume (for future scaling decisions)
**Effort:** 1 hour
**Steps:**
- [ ] Check current Docker PostgreSQL container
  - [ ] `docker ps | grep postgres`
  - [ ] Verify it's running and healthy
- [ ] Export current database schema:
  - [ ] `docker exec [postgres-container] pg_dump -U [user] --schema-only [db-name] > ctmo/technical/db_schema_baseline_2026-03-29.sql`
- [ ] Create transaction logging setup (optional, for later):
  - [ ] Document how to monitor pg_stat_statements if needed
- [ ] Store baseline in: `ctmo/technical/db_schema_baseline_2026-03-29.sql`

---

### [ ] HubSpot & ConvertKit Contact/Subscriber Tracking
**Why:** Establish baseline so we detect when limits are approaching
**Effort:** 30 minutes
**Steps:**
- [ ] Create tracking spreadsheet: `ctmo/logs/platform_limits_tracker_2026-03-29.csv`

**Template:**
```
Platform,Metric,Current,Limit,Percentage,Last_Checked,Notes
HubSpot,Contacts,0,1000,0%,2026-03-29,Starting fresh
ConvertKit,Subscribers,0,10000,0%,2026-03-29,Starting fresh
Bluehost,Combined_Visitors,4300,40000,11%,2026-03-29,M1 projection target
PostgreSQL,Transactions/Month,0,500000,0%,2026-03-29,Self-hosted sufficient
```

- [ ] Update this spreadsheet monthly
- [ ] Set alerts: 70% of limit = yellow flag, 85% = escalate to board

---

### [ ] Create Upgrade Playbooks (SOP Documents)

#### Playbook A: Bluehost VPS Upgrade
**File:** `ctmo/technical/playbook_bluehost_vps_upgrade.md`
**When:** Triggered at 40k/mo traffic
**Steps:**
1. [ ] Verify traffic threshold exceeded (40k+ combined visitors)
2. [ ] Alert CEO/CFO: "Bluehost VPS upgrade trigger hit"
3. [ ] Compare VPS options:
   - Bluehost VPS (in-place upgrade)
   - Kinsta (performance focus)
   - SiteGround VPS (balanced)
4. [ ] Execute upgrade:
   - Backup current sites
   - Migrate to VPS
   - Test all sites
   - Monitor for 1 week
5. [ ] Update budget tracking in CFO files

#### Playbook B: ConvertKit Upgrade
**File:** `ctmo/technical/playbook_convertkit_upgrade.md`
**When:** Approaching 8k+ subscribers (or if hitting 10k free tier limit)
**Steps:**
1. [ ] Verify subscriber count at 8k+
2. [ ] Alert CEO: "ConvertKit approaching free tier limit"
3. [ ] Calculate projected growth rate
4. [ ] Upgrade to Creator plan ($39/mo)
   - Verify payment method
   - Update billing
5. [ ] Monitor subscriber growth toward next tier (3k limit on Creator)

#### Playbook C: Zapier Downgrade (if switching to n8n)
**File:** `ctmo/technical/playbook_zapier_exit.md`
**When:** Approved to switch to n8n
**Steps:**
1. [ ] Export all Zapier workflows (if any exist)
2. [ ] Audit integrations: Which are used?
3. [ ] Map each Zapier workflow to n8n equivalent
4. [ ] Build n8n replacements (4-6 hours)
5. [ ] Test thoroughly before killing Zapier
6. [ ] Cancel Zapier account
7. [ ] Save $360/year

---

### [ ] Documentation Updates
**Why:** Make future scaling decisions faster
**Effort:** 2 hours (once decisions made)

- [ ] Add decision summary to CTMO/CLAUDE.md: "Infrastructure decisions made 2026-03-29"
- [ ] Link to scaling_limits_audit in technical docs
- [ ] Create "When to Upgrade" decision tree (for next CTMO or COO reference)
- [ ] Update infrastructure cost projections (CFO will need this)

---

### [ ] Board Communication Template
**Why:** Keep CEO/COO/CFO updated on scaling metrics
**File:** `ctmo/technical/board_monthly_infrastructure_report_template.md`

**Use monthly for:**
```markdown
# Infrastructure Report — [Month]

## Traffic & Usage
- Bluehost combined traffic: X visitors/month (Y% toward 40k trigger)
- HubSpot contacts: X (Y% toward 1k limit)
- ConvertKit subscribers: X (Y% toward 10k limit)
- PostgreSQL transactions: X/month (trivial load)

## Status
- All systems: HEALTHY / CAUTION / ACTION REQUIRED
- Upgrade triggers hit: NONE / [List which ones]

## Recommendations
- Continue as-is OR
- Prepare for [Platform] upgrade next month

## Costs
- Current monthly: $X
- Projected after upgrades: $Y
```

**Schedule:** First of each month (e.g., April 1, May 1, etc.)

---

## LONG-TERM OPTIMIZATIONS (Not urgent, plan for M2+)

### [ ] CDN for Bluehost (to reduce load)
**Why:** Cloudflare Free can improve performance and reduce Bluehost I/O load
**Effort:** 2-3 hours setup per site
**When:** If Bluehost performance is marginal (M2-3)
**Cost:** Free (Cloudflare free tier)

### [ ] Database Connection Pooling (for PostgreSQL)
**Why:** Reduce transaction overhead as load increases
**Effort:** 2 hours
**When:** Only if PostgreSQL queries start showing slowdowns (unlikely M1-6)
**Tool:** PgBouncer (free, self-hosted)

### [ ] Caching Layer (Redis)
**Why:** If n8n workflows or API calls get slow
**Effort:** 4-6 hours
**When:** Only if seeing performance issues (unlikely M1-6)
**Cost:** Included in Docker setup ($0)

### [ ] Database Replication
**Why:** Scale reads beyond single node
**Effort:** 8+ hours
**When:** Only if PostgreSQL hitting 100k+/month transactions (unlikely)
**Cost:** Minimal (self-hosted replication)

---

## Timeline

### TODAY (2026-03-29, After Board Approval)
- [ ] Get CEO sign-offs on Zapier & Bluehost decisions
- [ ] Set up Bluehost traffic monitoring
- [ ] Create HubSpot/ConvertKit/PostgreSQL baseline tracking
- [ ] Create upgrade playbooks (documents)

### WEEK 1 (By 2026-04-05)
- [ ] If n8n approved: Build n8n workflows (4-6 hours)
- [ ] Test all automations end-to-end
- [ ] Brief COO on workflow status
- [ ] Archive or cancel Zapier if not used

### MONTH 1 (Apr-May)
- [ ] Monitor all metrics weekly
- [ ] No upgrades needed (unless traffic explodes)
- [ ] First monthly infrastructure report (May 1)

### MONTH 3-4 (Jun-Jul)
- [ ] Decide on Bluehost VPS upgrade (based on 40k trigger)
- [ ] Prepare quotes and migration plan
- [ ] Execute upgrade if needed
- [ ] Monitor VPS performance

### MONTH 6+ (Aug+)
- [ ] Review all infrastructure scaling decisions
- [ ] Evaluate cost vs. revenue performance
- [ ] Plan next 6 months of infrastructure investment

---

## Success Metrics

By end of Month 1, CTMO will have:
- [ ] Zapier decision implemented (either upgraded or migrated to n8n)
- [ ] Bluehost traffic monitoring live and reporting weekly
- [ ] HubSpot/ConvertKit/PostgreSQL limits tracked
- [ ] Upgrade playbooks documented and ready
- [ ] Zero unplanned infrastructure outages

By end of Month 6, CTMO will have:
- [ ] Successfully handled all infrastructure scaling decisions
- [ ] Bluehost VPS upgraded (if 40k traffic trigger hit)
- [ ] All platforms operating under limits with 20%+ headroom
- [ ] Infrastructure cost tracking accurate and on-budget
- [ ] No surprise scaling costs

---

## CTMO Sign-Off

**Ready to execute upon board approvals.**

**Blockers:**
1. CEO approval: Zapier vs n8n decision
2. CEO confirmation: Bluehost 40k/mo VPS trigger

**Can start immediately:**
1. Bluehost traffic monitoring
2. Baseline documentation
3. Playbook creation

---

**Last Updated:** 2026-03-29, 2:30 PM
**Next Update:** After board meeting (approval)

