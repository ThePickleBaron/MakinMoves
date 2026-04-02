# Content Format Architecture — Complete Documentation Index

**Project:** Autonomous Content Publishing for MakinMoves

**Status:** RESEARCH COMPLETE ✓ READY FOR BUILD

**Deadline:** Implementation by 2026-03-30 23:59 (36-hour sprint)

---

## DOCUMENTATION FILES (Read in This Order)

### 1. START HERE: Research Summary (10 min read)
📄 **`RESEARCH_SUMMARY_2026-03-29.md`**
- Executive overview
- Problem statement + solution
- High-level architecture diagram
- Implementation timeline
- Risk mitigation
- Next steps

**Who should read:** Everyone (CEO, COO, CTMO, CFO)

---

### 2. FOR CTMO: Full Technical Architecture (60 min read)
📄 **`content_format_architecture_2026-03-29.md`**
- Detailed format specifications (CSV schemas)
- Approval workflow with examples
- File system structure
- PostgreSQL schema
- n8n workflow overview
- Implementation checklist
- Failure modes & mitigations

**Who should read:** CTMO (primary), COO (reference)

**Contains:** Everything CTMO needs to build the system

---

### 3. FOR CTMO: n8n Workflow Specifications (90 min read)
📄 **`n8n_workflow_skeletons_2026-03-29.md`**
- 5 complete workflow designs
- Node-by-node configuration
- JavaScript code snippets (CSV parsing, data transformation)
- SQL code snippets (PostgreSQL operations)
- Testing procedures
- Debugging tips
- Implementation priority order

**Who should read:** CTMO (for build phase)

**Contains:** Ready-to-implement workflow designs

---

### 4. FOR COO: Quick-Start Approval Guide (5 min read)
📄 **`content_approval_quickstart_2026-03-29.md`**
- Daily workflow (10 minutes)
- File structure explanation
- Common mistakes
- Troubleshooting
- Checklist before March 31

**Who should read:** COO (primary), CTMO (reference for user experience)

**Contains:** Everything COO needs to know to approve content

---

## QUICK REFERENCE

### What Gets Built?

| Component | Owner | Status |
|-----------|-------|--------|
| Notion databases (3) | CTMO + COO | Design ready |
| CSV formats (3) | CTMO | Spec ready |
| File system structure | CTMO | Spec ready |
| PostgreSQL schema | CTMO | Spec ready |
| n8n Workflow A (Export) | CTMO | Build ready |
| n8n Workflow B (Publish) | CTMO | Build ready |
| n8n Workflow C (Webhooks) | CTMO | Build ready |
| n8n Workflow D (Generation) | CTMO | Build ready (optional) |
| n8n Workflow E (Polling) | CTMO | Build ready |
| Error logging system | CTMO | Build ready |
| Email notifications | CTMO | Build ready |

### Build Time Estimate

| Phase | Task | Duration | Owner |
|-------|------|----------|-------|
| 1 | Setup (Notion, files, schema) | 4 hours | CTMO |
| 2 | Build workflows (A-E) | 6 hours | CTMO |
| 3 | Integration testing | 3 hours | CTMO + COO |
| 4 | Documentation | 1 hour | CTMO |
| — | **Buffer/contingency** | 5.5 hours | CTMO |
| — | **TOTAL** | **19.5 hours** | — |

### Success Criteria (By March 30 23:59)

- [ ] End-to-end flow works: Notion → CSV → Approve → Publish → PostgreSQL
- [ ] COO can approve content in <10 minutes without help
- [ ] Publishing errors are logged and alerting works
- [ ] Recovery tracker updates in real-time
- [ ] All documentation complete
- [ ] System tested with sample data (≥3 items per stream)

---

## THE SOLUTION AT A GLANCE

### Problem
MakinMoves needs to publish content autonomously after March 31, with zero human intervention. But COO still needs to approve content before publishing (quality control).

### Solution
**Hybrid workflow:** Notion for drafting → CSV for approval → n8n for publishing → PostgreSQL for tracking

```
┌──────────────────────────────────────────────────────────────────┐
│                   COO'S DAILY WORKFLOW (10 min)                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. Email reminder arrives (8:00 AM)                            │
│  2. Open /content/approved/ folder                              │
│  3. Review CSV files (items awaiting approval)                  │
│  4. Change status: draft → approved                             │
│  5. Save file (Ctrl+S)                                          │
│                                                                  │
│  ✓ DONE — Everything else is automatic                          │
│                                                                  │
├──────────────────────────────────────────────────────────────────┤
│                 AUTOMATED SYSTEMS (no human input)               │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  9:00 AM: n8n publishes approved items to:                      │
│    ├─ Gumroad (digital products)                                │
│    ├─ Etsy (digital products + PoD)                             │
│    ├─ Merch by Amazon (PoD designs)                             │
│    ├─ Redbubble (PoD designs)                                   │
│    └─ WordPress (affiliate articles)                            │
│                                                                  │
│  Real-time: Platforms send sales data                           │
│    ├─ Gumroad webhooks → PostgreSQL                             │
│    ├─ Etsy webhooks → PostgreSQL                                │
│    ├─ Redbubble webhooks → PostgreSQL                           │
│    └─ WordPress views → PostgreSQL                              │
│                                                                  │
│  Hourly: Revenue summary email to COO                           │
│    └─ "✓ 3 products published, 5 sales, $127.50 revenue"       │
│                                                                  │
│  Daily: Recovery tracker updated                                │
│    └─ Tracks progress toward $10,000 goal                       │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Key Innovation
Instead of complex database flags or web interfaces, uses **file operations** for approval:
- Move file to `/approved/` folder = **Approve**
- Move file to `/drafts/` folder = **Reject**
- Simple, visible, foolproof

---

## IMPLEMENTATION CHECKLIST

### Before Starting Build (Day 1, morning)
- [ ] Read all 4 documentation files
- [ ] Validate Merch by Amazon & Redbubble API capabilities
- [ ] COO prepares test data in Notion (3-5 items per stream)
- [ ] CTMO and COO agree on file paths

### Phase 1: Setup (Day 1, 4 hours)
- [ ] Create Notion databases (3 databases with columns)
- [ ] Create file system folders (`/content/drafts`, `/content/approved`, etc.)
- [ ] Create PostgreSQL schema (4 tables: content_products, revenue_log, publishing_log, publishing_errors)
- [ ] Build n8n Workflow A (Notion → CSV export, test manually)

### Phase 2: Automation (Day 2, morning, 6 hours)
- [ ] Build n8n Workflow B (CSV → Gumroad, test)
- [ ] Build n8n Workflow B (CSV → Etsy, duplicate approach)
- [ ] Build n8n Workflow B (CSV → WordPress, duplicate approach)
- [ ] Build n8n Workflow C (Webhook handlers, test with sample webhook)
- [ ] Build n8n Workflow E (Hourly polling, test)

### Phase 3: Integration (Day 2, afternoon, 3 hours)
- [ ] End-to-end test: Create item in Notion → Export to CSV → Approve → Publish to Gumroad
- [ ] Verify CSV updates with published_date and URL
- [ ] Verify PostgreSQL inserts revenue_log when sale occurs
- [ ] Test error handling (try to publish item with missing image, verify error logged)

### Phase 4: Documentation (Day 2, evening, 1 hour)
- [ ] Write COO one-page quick start
- [ ] Screenshot each n8n workflow
- [ ] Create troubleshooting guide
- [ ] Test COO can execute approval workflow solo

### Final (Evening, March 30)
- [ ] All 4 success criteria verified
- [ ] System ready for March 31 handoff

---

## FILE LOCATIONS

```
/c/Users/jsmcl/documents/makinmoves/

├── CTMO/technical/
│   ├── RESEARCH_SUMMARY_2026-03-29.md ← START HERE
│   ├── content_format_architecture_2026-03-29.md (main doc)
│   ├── n8n_workflow_skeletons_2026-03-29.md
│   └── README_CONTENT_ARCHITECTURE.md (this file)
│
├── COO/
│   └── content_approval_quickstart_2026-03-29.md
│
├── MakinMoves-portable/
│   ├── content/
│   │   ├── approved/         ← COO edits files here
│   │   ├── drafts/           ← CTMO exports to here
│   │   ├── images/
│   │   │   ├── designs/      ← PoD design images
│   │   │   └── products/
│   │   ├── articles/         ← Generated blog posts
│   │   └── logs/
│   │       ├── publishing.log
│   │       └── publishing-errors.log
│   │
│   └── projects/             ← Already exists, organized per stream
│       ├── digital-products/
│       ├── content/
│       └── ...
```

---

## HOW TO USE THIS DOCUMENTATION

### If you're CTMO (building the system)
1. Read RESEARCH_SUMMARY (10 min)
2. Read content_format_architecture (60 min)
3. Read n8n_workflow_skeletons (90 min)
4. Follow the "CTMO Build Checklist" above
5. Reference the specs while coding

### If you're COO (approving content)
1. Read content_approval_quickstart (5 min)
2. Follow the daily workflow outlined there
3. Check for error emails if publishing fails
4. Ask CTMO if something breaks

### If you're CEO/CFO (overseeing)
1. Read RESEARCH_SUMMARY (10 min)
2. Check the timeline and risk mitigation sections
3. Monitor daily standups for progress
4. Verify success criteria on March 30 evening

### If you're CTMO troubleshooting later
1. Reference RESEARCH_SUMMARY for architecture overview
2. Reference n8n_workflow_skeletons for workflow details
3. Check PostgreSQL `publishing_errors` table for error messages
4. Review n8n error logs for workflow execution issues

---

## KEY DESIGN DECISIONS

### Why CSV Instead of Notion JSON?
- n8n has limited Notion update support
- CSV is universally compatible
- Easier validation and error messages
- Easy for COO to edit in Excel/Sheets if needed

### Why File-Based Approval Instead of Database Flags?
- Zero SQL knowledge required
- Visible (folder structure is obvious)
- Atomic (move = approve, simple)
- Easy to rollback (move back to drafts)

### Why Hybrid Approach?
- Notion is excellent for human input (visual, flexible)
- CSV is excellent for automation (structured, n8n-native)
- Separation of concerns: drafting vs. approval vs. publishing

---

## TESTING STRATEGY

### Unit Testing (Each workflow in isolation)
- Test Notion export with 10 items
- Test CSV parser with malformed data
- Test Gumroad API call with mock response
- Test PostgreSQL insert with transaction rollback

### Integration Testing (End-to-end)
- Create item in Notion
- Verify export to CSV
- Manually change status to "approved"
- Verify n8n publishes to platform
- Verify PostgreSQL updated with URL and date
- Verify email summary sent

### Error Testing (Failure scenarios)
- Publish item with missing image → Error logged
- Publish item with invalid price → Error logged
- API key expired → System paused, email alert sent
- CSV file corrupted → Fallback to previous version

---

## ESCALATION PROCEDURES

### If Workflow Fails
1. Check `/content/logs/publishing-errors.log` for error message
2. Verify API key is valid (not expired)
3. Check file paths (do they exist?)
4. Test n8n individually (use "Test" button in n8n UI)

### If COO Can't Approve
1. Check file path is correct
2. Verify CSV is valid (can open in Excel)
3. Check file permissions (can n8n access folder?)

### If Revenue Isn't Captured
1. Check webhook is registered on platform (Gumroad dashboard)
2. Check webhook URL points to correct n8n instance
3. Check PostgreSQL for errors (query `publishing_errors` table)

---

## SUPPORT CONTACTS

**Questions about architecture:** CTMO (via `/ctmo/inbox/`)

**Questions about approval workflow:** CTMO (via `/ctmo/inbox/`)

**Issues with Notion setup:** CTMO (via `/ctmo/inbox/`)

**Issues with revenue tracking:** CFO (via `/cfo/inbox/`)

---

## FINAL NOTES

This architecture prioritizes **simplicity and reliability** over feature richness. It's designed to work without human intervention after March 31 while keeping the approval workflow simple enough for COO to execute in 10 minutes/day.

The 36-hour implementation timeline is ambitious but achievable. Focus on:
1. Getting Workflow A working first (foundation)
2. Testing one platform (Gumroad) thoroughly
3. Duplicating for other platforms (fast once template works)
4. Comprehensive error handling (make failures visible)

---

**Status:** Ready for build

**Owner:** CTMO

**Timeline:** 36 hours (2026-03-29 14:00 to 2026-03-30 23:59)

**Next Review:** 2026-03-30 12:00 (midpoint check-in)

**GO LIVE:** 2026-03-31 00:00 (autonomous operation begins)

---

*Last updated: 2026-03-29 17:00 UTC*
