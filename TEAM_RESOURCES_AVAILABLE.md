# Available Resources & Tools — Use Liberally

**From:** Jason (Owner)
**Date:** 2026-03-29 17:15
**Status:** All tools authorized, no permission requests needed

---

## Hardware Available

- **RAM:** 128 GB (plenty for parallel processes)
- **CPU:** Threadripper (massive core count)
- **GPU:** RTX 3090 (for compute-heavy work)

**Use aggressively. This is not a laptop.**

---

## Approved Tools & Commands

All instances have unrestricted access to:

### Development & Automation
- ✅ **Docker** — Spin up containers freely (PostgreSQL, n8n, etc.)
- ✅ **Python** — Run scripts, data analysis, automation
- ✅ **Node/npm** — JavaScript tooling, build pipelines
- ✅ **Bash** — Shell scripting, system commands
- ✅ **Git** — Version control, repo management
- ✅ **curl/wget** — API calls, web scraping

### Media & Content
- ✅ **ffmpeg** — Video encoding, screenshot capture, GIF creation

### No Permission Needed

All the above execute **without asking your permission**. Just use them.

---

## Recommendations by Role

### COO (Content & Products)
**Use:** Python scripts for bulk content generation, ffmpeg for product screenshots/videos
- Example: Generate 50 AI prompts with quality checks via Python script (saves context, faster execution)
- Example: Create product preview images/GIFs with ffmpeg

### CTMO (Infrastructure)
**Use:** Docker for local testing, Python for architecture simulation
- Example: Spin up PostgreSQL + n8n locally to test integration before deployment
- Example: Run Python script to benchmark tech stack options

### CFO (Financial Modeling)
**Use:** Python for complex calculations, spreadsheet generation
- Example: Run Python script for pricing scenario modeling (10x faster than manual)
- Example: Generate revenue dashboards as JSON/CSV locally, then load into templates

### CEO (Strategy)
**Use:** Python for data aggregation, Bash for batch operations
- Example: Scrape competitor data with Python, analyze with local scripts

---

## Context Efficiency Strategy

**When to use local tools instead of Claude agent work:**

| Task | Do This | Why |
|------|---------|-----|
| Generate 50+ items | Python script | Faster, cleaner, saves context |
| Process/transform data | Python/Bash script | Batch operations are efficient |
| Complex calculations | Python | Precise, repeatable, auditable |
| Media encoding | ffmpeg | Specialized tool, way faster |
| API testing | curl in Bash | Direct, instant feedback |
| Environment setup | Docker | Reproducible, instant |

---

## How to Request New Tools

If you need something not listed above:
1. Post to your role's inbox: `request_tools_2026-03-29.md`
2. Explain what you need and why
3. Jason will approve or explain constraints

---

## Bottom Line

You have world-class hardware and no budget constraints. **Use it.**

Don't do manually what can be automated. Don't calculate what can be scripted. Don't wait for context when you can run local.

Go.

---
