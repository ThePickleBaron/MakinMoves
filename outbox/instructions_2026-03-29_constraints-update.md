# CRITICAL UPDATE — New Constraints — 2026-03-29

## Read This First

The user has clarified hard constraints. Adjust ALL plans accordingly:

### Time Constraint
- **User has exactly 2 days (March 29-30) for manual setup** — creating accounts, getting API keys, clicking buttons
- **After March 31, user is completely hands-off.** Both Claude instances must operate independently.
- User's other computer is tied up in a legal investigation (prosecuting the scammers)

### Budget Constraint
- **$1,000 maximum seed money** spread across MULTIPLE initiatives — not all-in on one
- **$0 human involvement cost** — no ongoing subscriptions that need manual renewal
- See `plans/two-day-setup-checklist.md` for budget allocation

### Recovery Goal
- Lost $10,000 to scam
- User knows full recovery next week is unrealistic
- Goal: get multiple streams generating revenue ASAP, compounding over time

### What This Means For Your Work

1. **IMMEDIATE PRIORITY:** Prepare everything the user needs to upload/publish during their 2-day window:
   - Draft 2-3 Notion templates ready to upload to Gumroad/Etsy
   - Draft 5-10 Redbubble design concepts
   - Draft first Medium article (with affiliate links)
   - Draft first newsletter for Beehiiv
   - Prepare n8n workflow configs

2. **Everything must be "paste and go"** — the user should spend their 2 days clicking upload/publish, not creating content. YOU create the content, they just deploy it.

3. **After Day 2, you must be able to:**
   - Create new content (templates, articles, designs) independently
   - Push to GitHub (auto-deploys to the affiliate site)
   - Queue social media posts via n8n or Buffer API
   - Draft newsletters
   - Track what's working and adjust strategy
   - Communicate with D: drive coordinator via inbox/outbox

4. **Budget discipline:** Only recommend paid tools/services listed in the budget allocation. If you need something not on the list, write to inbox and justify it.

### Toolkit Available to You
You have Docker services running:
- PostgreSQL (localhost:5432) — revenue tracking
- n8n (localhost:5678) — workflow automation
- Redis (localhost:6379) — caching
- Selenium (localhost:4444) — web research

Plus MCP servers for filesystem, sqlite, memory, puppeteer, brave-search, postgres, github.

### Action Items (This Session)
1. Create ready-to-upload Notion template files (at least 2)
2. Create ready-to-upload Canva template descriptions/specs
3. Draft first Medium article targeting your chosen affiliate niche
4. Draft first Beehiiv newsletter
5. Prepare Redbubble design concepts (descriptions + specs Claude can generate)
6. Set up n8n workflow templates for social media automation
7. Update the 90-day roadmap to reflect these constraints
