# MCP & Tool Requirements — Claude Code & Cowork

**Date:** 2026-04-02  
**Purpose:** Document what integrations each agent needs to execute efficiently

---

## Claude Code Requirements

### MCPs (Model Context Protocols)
1. **Gumroad MCP** ✅ Available
   - List products
   - Read product details (pricing, description, file associations)
   - Create/update product listings
   - Retrieve sales data (if available)
   - **Use:** Publish Sheets tracker listing, update product copy, track sales

2. **Notion MCP** ✅ Available
   - Read database schema
   - Create/update pages
   - Manage databases
   - **Use:** If needed to refine template structure or create internal tracking database
   - **NOTE:** Cowork owns Notion builds — only use via API if needed for automation

### File System Access
- ✅ Read/write: `./shared/streams/` — product specs, articles, listing copy
- ✅ Read/write: `./shared/memos/` — status updates, blockers
- ✅ Read/write: `./shared/logs/` — session logs
- ✅ Git push to GitHub

### External Tools (Manual/Browser)
- Substack (create account, publish articles, manage email list)
- Beehiiv (email list setup)
- Medium (backup publishing platform)
- Etsy (list Notion template)
- TradingView/Sharesight/Stock Rover (affiliate program signups)
- Reddit (post links, engage)

**Note:** Jason will handle platform logins. I'll provide exact click-path instructions.

---

## Cowork Requirements

### MCPs (Model Context Protocols)
1. **Notion MCP** ✅ Available
   - Create/update Notion template
   - Build sample databases
   - Create "How to Use" guides
   - **Use:** Polish portfolio tracker template, add more features if needed

### Browser Automation (Claude in Chrome)
- ✅ Open platforms (Gumroad, Notion, Substack, etc.)
- ✅ Fill forms, upload files
- ✅ Review live products
- ✅ Test email workflows
- **Use:** Verify template quality, test Gumroad listings, check article rendering

### File System Access
- ✅ Read: `./shared/streams/` — product specs, article drafts
- ✅ Read: `./shared/memos/` — Claude Code's status & blockers
- ✅ Write: `./shared/memos/` — feedback, notes, competitive intel
- ✅ Git push to GitHub

### External Tools (Manual/Browser)
- Gumroad (review listings, test purchases if needed)
- Substack/Medium (review article placement, engagement)
- Reddit (market research, competitive analysis)
- Twitter/X (research trend discussions about trading/investing)
- Email clients (test email sequences)

---

## Shared Communication Protocol

### Memo Structure
**File:** `./shared/memos/memo_YYYYMMDD_cc_topic.md` (Claude Code) or `memo_YYYYMMDD_cw_topic.md` (Cowork)

**Content template:**
```markdown
# Memo: [Topic]

**From:** Claude Code / Cowork
**To:** The other agent + Jason (optional)
**Status:** [Done/Blocked/FYI/Question]
**Date:** YYYY-MM-DD

## Summary
[2-3 sentences]

## Details
[Context, findings, blockers]

## Action Needed
[What the other agent should do, if any]

## Questions
[Questions for the other agent]
```

### Sync Points
- **Daily memos:** Post status/blockers each session
- **Weekly reviews:** Friday (day 11, 18, 25, 32, 39, 46, 53, 60, 67, 74, 81, 88) — compare progress, adjust plan
- **Escalations:** Jason only if we're stuck (>3 days no progress) or major disagreement

---

## Data Handoff Format

### Article Drafts
- **Location:** `./shared/streams/affiliate-marketing-saas/article-N-draft.md`
- **Format:** Markdown with `[AFFILIATE_LINK_PLACEHOLDER]` for links
- **Review cycle:** Claude Code writes → Cowork reviews & comments → Claude Code revises

### Product Specs
- **Location:** `./shared/streams/digital-products-templates/`
- **Format:** Spec files + actual .xlsx or linked Notion template
- **Review cycle:** Claude Code writes spec → Cowork builds/reviews → Claude Code publishes

### Listing Copy
- **Location:** `./shared/streams/digital-products-templates/gumroad-listing-copy.md`
- **Format:** Markdown with sections (headline, description, features, FAQ)
- **Review cycle:** Claude Code writes → Cowork refines → Claude Code publishes

### Email Sequences
- **Location:** `./shared/streams/affiliate-marketing-saas/email-*.md`
- **Format:** Subject + body, markdown for formatting
- **Review cycle:** Claude Code writes → Cowork reviews tone/CTA → Claude Code finalizes

---

## Success Metrics (Tracked by Both)

- **Email list:** Current 0 → Target 500+ by Day 90
- **Gumroad sales:** Current 1 product (Notion) → Target 3 products + 20+ sales/month by Day 60
- **Affiliate clicks:** Current 0 → Target 30+ clicks/month by Day 60
- **Articles published:** Current 0 → Target 18+ by Day 90
- **Revenue:** Current $0 → Target $500+/month by Day 90

---

## Potential Friction Points (Healthy Tension)

1. **Product pricing:** Claude Code may want lower prices for volume; Cowork may want higher for margin
2. **Content quality:** Claude Code may push fast publishing; Cowork may demand polish
3. **Platform choice:** Claude Code may prefer Substack; Cowork may prefer Medium for distribution
4. **Affiliate aggressiveness:** Claude Code may lean hard on affiliate links; Cowork may worry about trust
5. **Time commitment:** Claude Code may have full plans; Cowork may flag Jason's 30-min/day constraint

**These are healthy.** Expect pushback, debate, and better decisions as a result.

---

## Tool Setup Checklist

### For Claude Code
- [ ] Gumroad MCP configured
- [ ] Notion MCP configured
- [ ] Git push tested ✅ (done)
- [ ] File paths verified ✅ (done)

### For Cowork
- [ ] Claude in Chrome browser automation enabled
- [ ] Notion MCP configured
- [ ] Read access to ./shared/streams/ verified
- [ ] Write access to ./shared/memos/ verified
- [ ] Git push tested

### Shared
- [ ] Memo protocol agreed
- [ ] Sync schedule agreed (weekly reviews)
- [ ] Success metrics dashboard created (or tracked manually)
- [ ] GitHub repo up-to-date ✅ (done)

---

## Escalation Protocol

**If Claude Code & Cowork disagree:**

1. Document disagreement in memo with both positions
2. Cowork writes counter-memo with reasoning
3. Claude Code acknowledges or rebuts (one more back-and-forth)
4. If still unresolved: Jason decides (via memo response)
5. Both execute Jason's decision

**Expected:** 1-2 disagreements in 90 days. Goal is better decision-making, not consensus.

---

## Ready for Cowork Game Plan

This document is the setup. Cowork should now write their own game plan with:
- Their strategy (content, Notion builds, market positioning)
- Their dependencies on Claude Code
- Their challenges to Claude Code's assumptions
- Their timeline & milestones
- Their success metrics

Then both run simultaneously with weekly memos.
