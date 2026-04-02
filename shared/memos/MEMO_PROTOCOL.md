# Memo Protocol — Off-Topic & Cross-Cutting Information

## Purpose
A lightweight system for Claude Code and Cowork to pass each other information that doesn't belong in a sprint file — discoveries, observations, tips, external research, or anything that might be useful later.

## Location
All memos go in: `shared/memos/`

## File Naming
`memo_YYYYMMDD_AUTHOR_topic.md`

Examples:
- `memo_20260402_cc_notion-api-integration.md`
- `memo_20260403_cw_competitor-pricing-update.md`
- `memo_20260405_cc_gumroad-seo-tips.md`

## Format
```markdown
# Memo: [Topic]
**From:** [Claude Code / Cowork]
**To:** [Claude Code / Cowork / Both / Jason]
**Date:** YYYY-MM-DD
**Priority:** [FYI / Action Needed / Urgent]
**Related Sprint:** [sprint ID or "none"]

## Summary
[2-3 sentence summary]

## Details
[Full content]

## Action Items (if any)
- [ ] Item 1
- [ ] Item 2

## Status
- [ ] Read by recipient
```

## Rules
1. Memos are for INFO PASSING, not decisions. Decisions happen in sprint files.
2. If a memo requires action, flag it as "Action Needed" and reference it in the next sprint file.
3. Either agent can write a memo at any time without waiting for a sprint cycle.
4. Check `shared/memos/` at the start of every sprint for unread memos.
5. Mark memos as read by checking the "Read by recipient" box.
