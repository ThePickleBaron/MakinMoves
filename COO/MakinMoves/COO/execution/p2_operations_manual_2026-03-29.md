# P2 — Freelance Writing Service: Operations Manual & Decision Trees

**Filed by:** COO
**Date:** 2026-03-29
**Status:** ACTIVE — Operational framework ready for launch

---

## 1. Service Overview

P2 is a freelance writing service targeting small businesses, startups, and solopreneurs who need professional content but can't afford (or justify) a full-time writer. Jason delivers initially; we scale with contractors as volume grows.

**Core offerings:** Blog posts, website copy, email sequences, LinkedIn ghostwriting, product descriptions, case studies.

**Pricing tier (launch):** $1,200/mo retainer (4 blog posts + 1 email sequence) OR project-based ($300–$500 per deliverable).

---

## 2. Client Intake Flow (Step-by-Step)

### Step 1: Lead Capture
- Prospect finds us via content marketing (Substack, Medium, Reddit), referral, or cold outreach
- Fills intake form (Typeform or Tally — free tier): name, business, content needs, budget range, timeline
- Form auto-sends confirmation email with "what to expect" overview

### Step 2: Lead Qualification
- COO reviews intake form within 4 hours
- Qualification criteria:
  - Budget ≥ $300/project OR $1,000/mo retainer
  - Clear deliverable (not "I need content" with no specifics)
  - Responsive to initial contact within 48 hours
- If qualified → move to Discovery Call
- If unqualified → send polite decline template (Template E1 below)

### Step 3: Discovery Call (15–20 min)
- Scheduled via Calendly (free tier, linked from confirmation email)
- Agenda: understand their business, content goals, audience, tone preferences, timeline
- Post-call: COO generates Project Brief (Template PB1) within 24 hours

### Step 4: Proposal & Agreement
- Send proposal with scope, deliverables, timeline, and pricing (Template PR1)
- Include terms: payment schedule, revision policy, ownership transfer
- Client signs via email confirmation (no complex e-sign needed at this scale)
- Payment: 50% upfront via Stripe/PayPal, 50% on delivery

### Step 5: Project Kickoff
- Create client folder in Google Drive: `Clients/[ClientName]/[ProjectName]/`
- Subfolder structure: `/Brief`, `/Drafts`, `/Final`, `/Invoices`
- Add to client tracker (Notion or spreadsheet)
- Assign writer (Jason initially, contractor later)
- Send kickoff email with timeline and next steps (Template K1)

### Step 6: Content Production
- Writer completes draft by agreed deadline
- Internal quality review (see QA Checklist below)
- Draft shared with client via Google Docs link (comment access)

### Step 7: Client Review & Revisions
- Client has 48 hours to provide feedback
- 2 revision rounds included in base price
- Revisions completed within 48 hours of receiving feedback

### Step 8: Final Delivery & Payment
- Final version delivered as Google Doc + PDF + raw text
- Final invoice sent (remaining 50%)
- Payment due within 7 days
- Post-delivery follow-up email at Day 3 and Day 14 (Templates FU1, FU2)

### Step 9: Upsell & Retention
- At Day 14 follow-up: offer retainer package or next project
- At Day 30: check in on content performance, offer optimization
- Quarterly: send "content audit" offer — review what's working, suggest new content

---

## 3. Writer Workflow (When Scaling Beyond Jason)

### Assignment
1. COO assigns project via shared task board (Notion or Trello — free tier)
2. Writer receives: Project Brief, style guide, reference examples, deadline
3. Writer confirms acceptance within 12 hours

### Production
1. Writer submits first draft by deadline (typically 3–5 business days for blog post)
2. COO/QA reviews against checklist (see Section 6)
3. If pass → send to client
4. If fail → return to writer with specific revision notes

### Payment to Writers
- Per-piece payment: $150–$250 per blog post (1,500–2,500 words)
- Payment within 7 days of client approval
- Bonus: $50 per piece if client specifically praises quality

---

## 4. Decision Trees

### Decision Tree 1: Client Requests More Than 2 Revisions

```
Client asks for Revision 3+
├── Is the feedback within original scope?
│   ├── YES → Do the revision (goodwill), note in file, mention policy in delivery email
│   └── NO → Scope change detected
│       ├── Minor (< 1 hour work) → Do it, send "heads up" that this is outside scope
│       └── Major (> 1 hour work) → Send Change Order template (Template CO1)
│           ├── Client approves → Execute at $75/hour
│           └── Client declines → Deliver current version as final
```

### Decision Tree 2: Client Misses Review Deadline

```
48-hour review window expires
├── Send reminder email (Template R1)
├── Wait 48 more hours
│   ├── Client responds → Resume normal flow
│   └── No response after 96 hours total
│       ├── Send "project on hold" notice (Template OH1)
│       ├── Pause all work on this project
│       └── If no response after 7 days → Close project, invoice for work completed
```

### Decision Tree 3: Writer Misses Deadline

```
Writer deadline passes
├── Was writer communicating about delay?
│   ├── YES (gave advance notice) → Extend 48 hours, notify client of adjusted timeline
│   └── NO (ghosted)
│       ├── Attempt contact (email + backup channel)
│       ├── Wait 24 hours
│       │   ├── Writer responds → Assess: can they deliver in 48 hrs?
│       │   │   ├── YES → Give final deadline, notify client
│       │   │   └── NO → Reassign to backup writer or Jason
│       │   └── No response → Reassign immediately
│       └── Flag writer: 1 strike (3 strikes = removed from roster)
```

### Decision Tree 4: Payment Fails

```
Payment not received by due date
├── Day 1 overdue: Auto-reminder email (Template PAY1)
├── Day 7 overdue: Personal email from Jason (Template PAY2)
├── Day 14 overdue: Final notice — "payment required within 48 hours or collections" (Template PAY3)
├── Day 16 overdue:
│   ├── Amount < $500 → Write off, blacklist client, no future work
│   └── Amount ≥ $500 → Consider small claims or collections agency
└── All future clients with this flag: 100% upfront payment required
```

### Decision Tree 5: Client Disputes Quality

```
Client says "this isn't what I asked for"
├── Review against original Project Brief
│   ├── Deliverable matches brief → Walk client through how it addresses their needs
│   │   ├── Client understands → Proceed with minor adjustments
│   │   └── Client still unhappy → Offer 1 free revision with updated brief
│   └── Deliverable doesn't match brief → Our error
│       ├── Apologize, reassign/redo at no cost
│       ├── Expedite: deliver corrected version in 48 hours
│       └── If pattern (same writer multiple times) → Remove writer from roster
```

---

## 5. Escalation Procedures

| Situation | Escalate To | Timeline |
|-----------|------------|----------|
| Client threatens legal action | Jason immediately | Within 1 hour |
| Payment dispute > $500 | Jason + CFO | Within 24 hours |
| Writer no-shows on active project | Jason (for reassignment) | Within 4 hours |
| Client requests NDA or custom contract | Jason | Within 24 hours |
| Scope change > $500 in additional work | Jason (for approval) | Before committing |
| Quality complaint (2+ from same client) | Jason (strategic decision) | Within 24 hours |
| Any PR/reputation risk | Jason immediately | Within 1 hour |

**Everything else:** COO handles autonomously. Default to protecting the client relationship while maintaining margins.

---

## 6. Quality Assurance Checklist

Before ANY deliverable goes to a client:

- [ ] Matches Project Brief requirements (topic, length, tone, audience)
- [ ] Grammar and spelling checked (Grammarly or equivalent)
- [ ] No AI-detection flags (run through Originality.ai or similar if client is sensitive)
- [ ] Formatting correct (headers, bullet points, CTA placement)
- [ ] SEO elements included if applicable (target keyword, meta description, internal links)
- [ ] Brand voice consistent with client's existing content
- [ ] All claims sourced or verifiable
- [ ] No plagiarism (Copyscape check)
- [ ] Read aloud test — does it sound natural?
- [ ] CTA present and aligned with client's goals

---

## 7. Template Emails

### Template E1: Polite Decline (Unqualified Lead)
```
Subject: Thanks for reaching out — [Business Name]

Hi [Name],

Thanks for your interest in working together. After reviewing your inquiry, I don't think I'm the best fit for what you need right now — [brief, kind reason: budget alignment / scope mismatch / timeline conflict].

A few suggestions that might help:
- [Alternative resource or platform]
- [Relevant free resource if we have one]

Wishing you the best with [their project/business].

Best,
[Brand Name]
```

### Template PR1: Proposal
```
Subject: Content Proposal — [Client Business Name]

Hi [Name],

Great chatting on our call. Here's what I'm proposing based on our discussion:

**Project:** [Deliverable description]
**Timeline:** [X] business days from kickoff
**Deliverables:** [Specific list]
**Investment:** $[Amount] ([50% upfront / 50% on delivery] OR [$X/month retainer])
**Revisions:** 2 rounds included

**What's included:**
- [Bullet 1]
- [Bullet 2]
- [Bullet 3]

**Next steps:** Reply "approved" and I'll send the invoice for the first 50%. We'll kick off within 24 hours of payment.

Looking forward to it.

Best,
[Brand Name]
```

### Template K1: Kickoff
```
Subject: We're live — [Project Name] kickoff

Hi [Name],

Payment received — we're officially underway. Here's your timeline:

- **Draft 1 delivery:** [Date]
- **Your review window:** 48 hours from delivery
- **Final delivery (after revisions):** [Date]

Your project folder: [Google Drive link]

If anything changes on your end, just reply to this email. Otherwise, I'll check in when the first draft is ready.

Let's make something great.

Best,
[Brand Name]
```

### Template FU1: Follow-Up (Day 3)
```
Subject: Quick check-in — how's [deliverable] working?

Hi [Name],

Just wanted to check in — have you had a chance to use [the blog post / email sequence / copy] yet?

If you have any questions or want to adjust anything, I'm here.

Best,
[Brand Name]
```

### Template FU2: Follow-Up (Day 14) + Upsell
```
Subject: How's [deliverable] performing?

Hi [Name],

It's been a couple weeks since we delivered [project]. Curious how it's performing — any early results?

If you're seeing traction, I'd love to help you build on it. A few ideas:
- [Relevant next project suggestion]
- [Retainer offer if applicable]

No pressure — just wanted to plant the seed. Let me know if you'd like to chat.

Best,
[Brand Name]
```

### Template CO1: Change Order
```
Subject: Scope update — [Project Name]

Hi [Name],

Love the direction you're going with this feedback. The changes you've requested go a bit beyond our original scope, so I want to make sure we're aligned:

**Additional work:** [Description]
**Additional investment:** $[Amount] (at $75/hour, estimated [X] hours)
**Updated timeline:** [New date]

If that works, just reply "approved" and I'll get started. If you'd prefer to stick with the current scope, the existing version is ready for final delivery.

Either way works — just want to be transparent.

Best,
[Brand Name]
```

### Template PAY1: Payment Reminder (Day 1 Overdue)
```
Subject: Invoice reminder — [Invoice #]

Hi [Name],

Quick reminder that invoice [#] for $[Amount] was due on [Date]. If you've already sent payment, please disregard.

Payment link: [Link]

Thanks,
[Brand Name]
```

---

## 8. Tools & Infrastructure

| Tool | Purpose | Cost | Status |
|------|---------|------|--------|
| Typeform/Tally | Intake forms | Free tier | Setup needed |
| Calendly | Discovery call scheduling | Free tier | Setup needed |
| Google Drive | File storage + client collaboration | Free | Ready |
| Notion or Sheets | Client tracker + project board | Free | Ready (Notion preferred) |
| Stripe/PayPal | Payment processing | Per-transaction fees | Setup needed |
| Grammarly | QA — grammar/spelling | Free tier | Ready |
| Copyscape | QA — plagiarism check | $0.03/check | Setup needed |

---

## 9. Contingency Workflows

### If Jason Gets Sick / Unavailable
- All active projects get client notification within 24 hours
- Deadline extensions of 3–5 business days offered
- If > 1 week unavailable: contractors handle active projects (must be onboarded in advance)

### If We Lose Our Biggest Client
- Immediately activate outbound acquisition (cold email 20 prospects)
- Post 2x content pieces to attract inbound leads
- Offer existing clients referral bonus ($200 per successful referral)

### If a Contractor Produces Bad Work
- Pull from active projects immediately
- Jason covers deliverables personally
- Contractor gets 1 documented warning; 2nd offense = removed from roster
- Post-incident: review onboarding process for gaps

---

*Filed by COO — 2026-03-29 | Block 1 Complete*
