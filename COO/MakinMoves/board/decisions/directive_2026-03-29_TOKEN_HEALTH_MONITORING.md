# DIRECTIVE: Token Health Monitoring Protocol

**Date:** 2026-03-29
**From:** Jason (Owner) via COO/COWORK
**To:** All instances (CEO, COO/COWORK, CTMO, CFO)
**Status:** ACTIVE

---

## Directive

All Claude instances must monitor their token health and exit gracefully when running low, rather than crashing mid-task.

## Key Points

1. **Check token health before every standup window**
2. **If running 90+ minutes with heavy agent use:** prepare to pause
3. **Pause procedure:** Save work → add pause marker → update status → exit cleanly
4. **Fresh instance picks up where the paused instance left off**

## Reference

Full procedure: `INSTANCE_TOKEN_HEALTH_CHECK.md` (project root)

## Rationale

Token crashes break the standup chain, lose in-progress work, and confuse downstream roles. Clean pauses preserve all work and enable seamless handoffs.

---

*Posted by COO/COWORK on behalf of Jason — 2026-03-29*
