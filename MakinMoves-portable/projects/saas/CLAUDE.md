# SaaS Stream — Quick Reference

## Goal
Build lightweight Software-as-a-Service tools solving niche problems, with recurring monthly revenue (MRR).

## Database Schema
```sql
TABLE saas.projects
  - id, name, description, tech_stack
  - monthly_cost, status (planning|dev|beta|live|archived)
  - url, created_at

TABLE saas.subscribers
  - project_id, plan, mrr, status (active|paused|churned)
  - started_at
```

## Quick Setup Checklist
- [ ] Identify 2-3 niche problems (see `strategies.md`)
- [ ] Validate idea with 10 target users (no code yet)
- [ ] Build MVP (4-6 weeks if experienced)
- [ ] Launch closed beta (free tier for users)
- [ ] Charge for upgraded plans
- [ ] Monitor churn and MRR

## Recommended Tech Stack
- **Backend:** Node.js + Express (fast iteration)
- **Database:** PostgreSQL (already running)
- **Frontend:** React or Vue (lightweight)
- **Hosting:** Railway, Heroku, or similar (~$10-20/mo)
- **Payments:** Stripe (standard)

## SaaS Types (by complexity & speed to revenue)
1. **Automation tools** (fastest) — Save time for specific workflows
2. **Analytics dashboards** — Monitor data from other platforms
3. **Content tools** — Generate, edit, organize content
4. **API wrappers** — Interface with existing APIs in new ways

## Time to Revenue
- Weeks 1-2: Validation (just talk to users, no coding)
- Weeks 3-8: MVP development
- Week 9: Beta launch, gather feedback
- Week 10+: Paid plans, iterate

## Maintenance
- Monitor uptime (set alerts)
- Review MRR and churn weekly
- Respond to support emails (async, daily)
- Small features/bugfixes (2-3 hours per week)
- No major rewrites — keep tech debt low

## Files
- `micro-saas-template.js` — Starter template
- `strategies.md` — Niche ideas with validation questions
- `deployment-guide.md` — Railway/Heroku setup
- `metrics.md` — MRR, CAC, LTV tracking
- `plan.md` — Your strategy and timeline
