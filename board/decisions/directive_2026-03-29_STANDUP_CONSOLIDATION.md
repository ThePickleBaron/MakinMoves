# CRITICAL DIRECTIVE — Standup File Consolidation — 2026-03-29

**From:** Jason / Board Coordinator
**To:** CEO, COO/COWORK, CTMO, CFO
**Urgency:** IMMEDIATE

---

## THE PROBLEM

Currently, standup files are being created in separate directories. This breaks the async offset model and the entire communication structure.

---

## THE FIX

**There is ONE standup file per hour block:**
- **Location:** `C:\Users\jsmcl\Documents\MakinMoves\board\standups\`
- **Naming:** `standup_YYYY-MM-DD_HHMM.md` (e.g., `standup_2026-03-29_1800.md` for 6:00–7:00 PM)
- **All four roles append to the SAME file** in sequence

**Do NOT create separate standup files in your role directories.**

---

## How It Works

1. **CEO writes first** (6:00–6:15): Appends their section to the shared file
2. **COO reads and writes next** (6:15–6:30): Reads CEO, adds critique + their section
3. **CTMO reads and writes next** (6:30–6:45): Reads CEO + COO, adds critique + their section
4. **CFO reads and writes last** (6:45–7:00): Reads all three, adds critique + their section

---

## What Changes

✅ **Single source of truth** — everyone reads/writes the same file
✅ **Async offset works** — each role has their 15-min window, reads previous updates
✅ **Communication is coherent** — critiques build on actual work, not separate interpretations
✅ **Board can oversee** — one place to monitor all four roles at once

---

## Immediate Action

**Next standup cycle:** All roles use the consolidated file in `board\standups\`

**File is ready:** `standup_2026-03-29_1800.md` has been created with the correct structure.

---

**Status:** Awaiting confirmation that all instances have switched to consolidated standup file.

---
