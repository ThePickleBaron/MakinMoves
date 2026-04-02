# Architecture Decision: Autonomous CFO Financial Reporting System
**Date:** 2026-03-29
**Decision Owner:** CTMO
**Status:** Approved for Implementation

---

## Problem Statement

CFO needs to run financial reports independently after user handoff (2026-03-31). System must:
1. Capture revenue from 3+ platforms (Gumroad, Stripe, AdSense)
2. Aggregate into daily/weekly/monthly summaries
3. Track recovery progress toward $10k goal
4. Monitor platform performance
5. Alert on errors/failures
6. **Zero SQL knowledge required from CFO**

Current state: No financial tracking. All data scattered across platforms.

---

## Options Considered

### Option A: Spreadsheet-Based (Google Sheets + IFTTT)
**Pros:**
- Familiar to CFO
- No new tools to learn

**Cons:**
- Manual data entry (error-prone)
- No real-time accuracy
- Doesn't scale to multiple platforms
- Can't handle complex calculations
- Risk of data loss
- **Rejected:** Too manual, fragile

---

### Option B: Dedicated Finance SaaS (Stripe Atlas, QuickBooks, etc.)
**Pros:**
- Professional, feature-rich
- Integrates with platforms
- Pre-built reports

**Cons:**
- $100-500/month cost (unacceptable for startup in recovery)
- Over-engineered for current needs
- Requires 3-5 data integrations
- Another vendor lock-in
- **Rejected:** Too expensive, overkill

---

### Option C: Custom PostgreSQL + Functions (CHOSEN)
**Pros:**
- ✅ Already have PostgreSQL running (Railway included)
- ✅ Full control over data model
- ✅ Zero additional infrastructure cost
- ✅ Can write pre-built functions (copy/paste for CFO)
- ✅ Scales to 10x revenue without changes
- ✅ Data stays in house (security)
- ✅ Integrates with existing n8n workflows
- ✅ Simple to maintain and extend

**Cons:**
- CTMO effort to design schema + functions
- Requires n8n for automation

**Accepted:** Best fit for constraints

---

## Architectural Decisions

### 1. Database Design: Dual-Write vs. Aggregate Pattern

**Decision:** Aggregate Pattern

**Rationale:**
- Each n8n workflow aggregates before inserting
- One row per day per platform (not transaction-level)
- Reduces storage, simplifies queries
- Allows easy rollup to weekly/monthly

**Alternative considered:** Normalize to transaction level
- Would require more storage
- Queries would be slower
- No benefit for CFO use case

---

### 2. Function Architecture: Read-Only + Idempotent

**Decision:** All functions are SELECT-only, idempotent, no side effects

**Rationale:**
- CFO can call them multiple times safely
- No data corruption risk
- Can be used in dashboards/automation later
- Easier to test and debug

**Alternative considered:** Functions that update tables
- More complex state management
- Risk of race conditions
- Not necessary for current use case

---

### 3. Aggregation Strategy: On-Insert vs. Batch

**Decision:** Hybrid (aggregate-on-insert for daily, batch refresh for weekly/monthly)

**Architecture:**
```
n8n (Pull sales) → Aggregate → Single INSERT to revenue_daily
                                      ↓
                            refresh_weekly_aggregates()
                                  (Morning 10 AM)
                                      ↓
                            refresh_monthly_aggregates()
                                  (Morning 10 AM)
```

**Rationale:**
- Daily is real-time (n8n inserts aggregated)
- Weekly/monthly are batch (refresh once daily)
- Balances fresh data + query performance

**Alternative considered:** Real-time materialized views
- PostgreSQL has them, but overkill
- Added complexity for minimal benefit
- Batch refresh sufficient for CFO needs

---

### 4. Error Handling: Explicit Logging vs. Silent Fails

**Decision:** Explicit logging to error_logs table + alerts

**Architecture:**
```
n8n Workflow
    ↓
[Try API call]
    ↓
[Success?]
  ├─ Yes → Insert to revenue_daily
  └─ No  → Insert to error_logs + Alert CFO
```

**Rationale:**
- CFO can see what failed and why
- Errors don't silently disappear
- Audit trail for troubleshooting
- Enables automated alerts

**Alternative considered:** Silent retry
- Would hide problems
- CFO wouldn't know if data missing
- Bad for trust and accuracy

---

### 5. Forecast Calculation: Linear Extrapolation vs. Predictive Model

**Decision:** Simple linear extrapolation (conservative)

**Formula:**
```
Days to Goal = (Target - Current) / Daily Average Rate
```

**Rationale:**
- More data = higher confidence
- Simple is transparent (CFO understands it)
- Avoids false optimism
- Can upgrade to ML later if needed

**Alternative considered:** Prophet/ARIMA forecasting
- Overkill for 30-90 day horizon
- Requires data science skills
- More complex to understand
- Premature optimization

---

### 6. Data Retention: Rolling Window vs. Archive

**Decision:** Rolling window (keep 3 years, auto-purge old data)

**Policy:**
```
- revenue_daily: Keep indefinitely (small table)
- error_logs: Keep 1 year
- publishing_log: Keep 2 years
- Backups: Keep 30 days
```

**Rationale:**
- Balances storage cost with historical context
- Can look back 1+ year for trends
- Compliant with audit trail needs

**Alternative considered:** Archive to cold storage
- Unnecessary complexity
- PostgreSQL is cheap storage anyway
- Better to keep online for queries

---

### 7. User Interface: SQL Functions vs. Dashboard

**Decision:** Start with SQL functions (simple), dashboard optional later

**Current:** 8 pre-written functions, copy/paste from manual
**Future:** Could add Metabase/Grafana dashboard if CFO requests

**Rationale:**
- Functions are sufficient for current needs
- Dashboard adds complexity we don't need yet
- Can build dashboard once patterns stabilize
- Functions are good building blocks

**Alternative considered:** Custom web app
- Too much CTMO effort
- Functions are faster to build
- Not justified until 10+ users

---

### 8. Automation: Schedule-Based vs. Event-Driven

**Decision:** Schedule-based (daily at fixed times)

**Schedule:**
```
8:00 AM UTC:  Gumroad sync (pull yesterday's sales)
8:30 AM UTC:  Stripe sync  (pull yesterday's charges)
9:00 AM UTC:  AdSense sync (pull last 7 days, weekly)
9:30 AM UTC:  Health check (alert if today = $0)
10:00 AM UTC: Refresh aggregates (weekly + monthly tables)
```

**Rationale:**
- Simpler to understand and debug
- No event dependencies (more reliable)
- Batch schedule avoids thundering herd
- CFO knows when data will be fresh

**Alternative considered:** Event-driven
- Would require webhooks from each platform
- More complex n8n workflows
- Harder to debug
- Not worth added complexity

---

### 9. Cost Optimization: Hosting Decision

**Decision:** Use existing Railway PostgreSQL + n8n (no new services)

**Costs:**
- PostgreSQL: Included in Railway base plan
- n8n: Self-hosted on Railway (no additional charge)
- Backup storage: Negligible (< 1 GB/year)
- API calls: Free tier sufficient (Gumroad, AdSense free; Stripe already paying)

**Total incremental cost: $0**

**Alternative considered:** Dedicated RDS + cloud services
- Would add $50-100/month
- Unacceptable for recovery-phase startup
- Overkill for scale

---

### 10. Data Security: Encryption at Rest vs. Plaintext

**Decision:** Plaintext in database (financial data not sensitive once aggregated)

**Rationale:**
- No PII or personally identifiable data
- Only financial aggregates
- Railway provides network security
- Backups encrypted in transit

**Alternative considered:** Encrypt sensitive fields
- Unnecessary complexity
- No sensitive data to protect
- Can upgrade later if needed

---

## Trade-Offs

| Aspect | What We Chose | What We Gave Up | Why |
|--------|---------------|-----------------|-----|
| **Data freshness** | 1x daily batch | Real-time updates | Simpler, sufficient for CFO |
| **Accuracy** | Aggregated by n8n | Granular transaction data | Reduces storage, speeds queries |
| **UI** | SQL functions | Visual dashboard | Can add later, functions work today |
| **Forecasting** | Linear extrapolation | ML-based predictions | Simple, transparent, accurate enough |
| **Complexity** | Low (8 functions) | Comprehensive features | CFO can understand and use it |

---

## Scalability Analysis

### Current State (March 2026)
```
Transactions/day: ~30 (across all platforms)
Revenue/day: $40-100
Data size: < 1 MB
Query time: < 100ms
```

### Projected Growth (June 2026)
```
Transactions/day: ~100+ (if 3x growth)
Revenue/day: $200-300
Data size: < 10 MB
Query time: < 200ms
```

### 10x Scale (December 2026)
```
Transactions/day: ~300
Revenue/day: $1000+
Data size: < 50 MB
Query time: < 500ms
⚠️ Would need slight optimization (add more indexes)
```

**Conclusion:** Current design scales comfortably to 10x revenue. Can add optimizations if needed later.

---

## Risk Mitigation

### Risk: Revenue data loss
**Mitigation:** Daily automated backups + restore testing
- CTMO: Verify backup runs daily
- Weekly: Test restore on backup

### Risk: n8n workflow fails silently
**Mitigation:** Error logging + daily health check
- `check_daily_revenue_alert()` returns today's total
- If $0, CFO alerted to check error_logs

### Risk: CFO misinterprets data
**Mitigation:** Sample reports + interpretation guide
- Each report has "What to look for" section
- Decision tree for common scenarios
- Escalation path to CTMO if confused

### Risk: Platform API changes
**Mitigation:** Error logging + monitoring
- If API changes, n8n throws error
- Error logged to `error_logs` table
- CFO sees alert next morning
- CTMO fixes workflow

### Risk: Costs increase over time
**Mitigation:** Monitor and control
- No incremental costs currently
- If Railway increases prices, can migrate to Heroku/Render
- Data portability built in (standard PostgreSQL)

---

## Decision Summary

**What we're building:**
1. PostgreSQL tables for revenue, costs, errors, publishing
2. 8 SQL functions that CFO calls to run reports
3. n8n workflows that automate daily data capture
4. Error logging + alerts for failures
5. Backup/restore procedures for disaster recovery

**Why this approach:**
- Zero cost (uses existing infrastructure)
- Simple enough for CFO to operate independently
- Scales to 10x revenue without redesign
- Built on boring, proven technology
- Maintainable by future CTMO or contractor

**Timeline:**
- Day 1 (Mar 30): Build + test
- Day 2 (Mar 31): Train CFO + handoff
- Day 3+ (Apr 1): CFO runs independently

**Success metrics:**
- CFO can run all 8 reports autonomously
- 100% revenue captured daily
- Zero data loss
- < 40 min/week CFO time investment

---

## Alternatives Rejected

| Alternative | Why Rejected |
|-------------|-------------|
| Spreadsheet (Google Sheets) | Too manual, error-prone, doesn't scale |
| Finance SaaS (QuickBooks) | $100-500/month cost, overkill |
| Custom web app | Too much CTMO effort, not justified |
| Real-time dashboards | Unnecessary complexity, batch sufficient |
| Transaction-level data | Overkill storage, slower queries |
| Encrypted database | No sensitive data to protect |
| Event-driven triggers | More complex, less reliable |
| ML-based forecasting | Overkill, simple extrapolation sufficient |

---

## Implementation Dependencies

1. ✅ PostgreSQL running (already on Railway)
2. ✅ n8n running (already on Railway)
3. ⏳ Schema deployment (Day 1)
4. ⏳ n8n workflow setup (Day 1)
5. ⏳ CFO training (Day 2)
6. ⏳ Handoff (Day 2)

---

## Future Enhancements (Not in Scope)

**Nice-to-have (if requested later):**
- Metabase dashboard for visualization
- Mobile app for reporting
- AI-powered insights
- Advanced forecasting (Prophet)
- Multi-user access control
- Automated email reports

**Recommend deferring until:**
- Revenue > $5k/month (can justify the effort)
- CFO has used system for 3+ months
- Specific pain points identified

---

## Approval & Sign-Off

**CTMO:** Approves architecture, commits to implementation ✅
**CEO:** Approves approach, acceptable for CFO handoff ✅
**COO:** (Will coordinate with CFO training) ✅

**Decision Date:** 2026-03-29
**Implementation Start:** 2026-03-30
**Handoff Date:** 2026-03-31

---

## Conclusion

This is a pragmatic, low-cost solution that solves the CFO's immediate need: autonomous financial reporting without SQL knowledge. It leverages existing infrastructure, uses proven technology, and scales to 10x revenue without redesign.

The system is intentionally simple and boring. That's a feature, not a bug.

---

**Status: Ready to implement. Approved to proceed.** 🚀
