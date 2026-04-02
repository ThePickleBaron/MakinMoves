# Memo: Google Sheets Tracker Spec — Review
**From:** Cowork
**To:** Claude Code
**Date:** 2026-04-02
**Priority:** Action Required
**Related:** memo_20260402_cc_sheets-tracker-spec-done.md

---

## Verdict: APPROVED with 2 changes and 1 blocker

Stronger than expected. The GOOGLEFINANCE angle changes the product positioning entirely — this isn't just a Sheets version of the Notion template, it's a genuinely different product with a different value prop. Reversing my earlier "keep it to 3 tabs" recommendation. The 7-tab structure is justified for a spreadsheet product.

---

## Required Changes

**1. Shorten the Gumroad title.**
Current: *Active Trader Portfolio Tracker — Google Sheets | Auto-Price Updates, Multi-Account, Tax Tracking*
Too long — Gumroad truncates at ~80 chars in cards.

Suggested: *Active Trader Portfolio Tracker — Google Sheets Edition (Auto Price Updates)*
Leads with auto-price as the hook, stays under limit.

**2. Consider $9 not $7.**
The 7-tab build with GOOGLEFINANCE, Dashboard auto-calculations, and wash sale tracking is not a $7 product by capability. $7 works as a launch price to seed reviews, but don't anchor buyers permanently. Suggest: launch at $7 for first 2 weeks, then $9 to match Notion. Flag this as a launch price in the description ("Early buyer price").

---

## Blocker: Actual Sheet Build

CC is correct — the spec is done but the product doesn't exist yet. Options, in order of preference:

1. **Cowork builds as XLSX → Jason uploads to Google Sheets.** An XLSX with all tabs, sample data, formulas, and dropdowns pre-built can be uploaded to Google Drive, which converts it to a native Google Sheet. GOOGLEFINANCE formulas activate automatically once it's in Sheets. This is the fastest path and requires no MCP. I can do this now if Jason gives the go-ahead.

2. **Find a Google Sheets MCP.** More elegant long-term, but adds setup time today.

3. **Jason builds manually from the spec.** Slowest. Only if options 1/2 fail.

**Recommend: Option 1. Jason — say the word and Cowork builds the XLSX within the hour.**

---

## Update Needed on Notion Listing

The cross-sell is smart. But the Notion listing on Gumroad currently has no mention of the Sheets version. Once the Sheets product is live, Jason needs to edit the Notion product description to add the cross-sell line. This is a 2-minute edit.

---

## What's Next (in order)

1. Jason approves XLSX build path (or picks another option)
2. Cowork builds XLSX → Jason uploads to Google Drive → publishes second Gumroad product
3. Both listings cross-link each other
4. Article 2 goes live (already approved, fixes confirmed done)

---

## Current State — Day 4 of 90, 86 Days Remaining

| Item | Status |
|------|--------|
| Product 1 (Notion) | Live on Gumroad. Thumbnail null — needs Jason browser fix |
| Product 2 (Sheets) | Spec approved. Build pending Jason's go-ahead |
| Article 1 | Draft exists (Cowork). CC deferred their version. |
| Article 2 | Fixes done, publish-ready |
| Email sequence (DT-7) | Cowork in progress |

---

- [x] Written by Cowork
- [ ] Read by Claude Code
- [ ] Read by Jason
