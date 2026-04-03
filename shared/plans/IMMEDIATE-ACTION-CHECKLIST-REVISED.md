# IMMEDIATE ACTION CHECKLIST (Weekend Setup Only)

**Timeline:** This weekend only (4 hours total)  
**Owner:** Jason (setup), Claude (parallel infrastructure)  
**Objective:** Get Substack paid tier live + first briefing approved by Monday

---

## JASON'S SETUP TASKS (30 Minutes, This Weekend)

Do these in order. Each takes <10 minutes.

### Task 1: Substack Bank Account Setup (10 min)
1. Go to activetradertools.substack.com
2. Click **Settings** (gear icon, top right)
3. Click **Billing & Account** (left sidebar)
4. Click **Add bank account**
5. Follow Stripe setup wizard
   - Full name
   - Bank account routing number (US) or IBAN (international)
   - Account number
   - Confirm
6. **Note:** Stripe may take 1–2 business days to verify your bank (this is normal). You can still enable paid subscriptions in parallel.

**Deliverable:** Bank account connected to Stripe

---

### Task 2: Substack Tax Information (5 min)
1. Still in **Settings** → **Billing & Account**
2. Scroll to **Tax Information**
3. Enter your tax ID (SSN in the US, or equivalent in your country)
4. Confirm
5. Substack will generate a tax form (you'll see a copy in your account)

**Deliverable:** Tax info saved

---

### Task 3: Enable Paid Subscriptions (5 min)
1. Go to activetradertools.substack.com
2. Click **Settings** → **Publication** (or **Manage publication** link)
3. Scroll to **Paid subscriptions**
4. Click **Enable paid subscriptions**
5. Set tier name: "Premium"
6. Set initial price: **$8/month** (or $70/year option)
7. Write tier description: "Weekly macro divergence analysis—what institutions miss, what you'll price first"
8. **Save**

**Note:** If bank account verification isn't complete yet, Stripe will still let you create the tier. Publishing will require verified bank account.

**Deliverable:** Paid subscription tier live (testable)

---

### Task 4: Test Paid Subscription (5 min)
1. Go to activetradertools.substack.com
2. As a logged-out reader, click **Subscribe**
3. You should see:
   - Free tier (optional, or hidden if you chose "paid only")
   - Premium tier at $8/month with description
4. Test subscribing to Premium as a free trial (Substack defaults to free trial first, paid after trial)
5. You should receive a confirmation email
6. **Confirm:** Premium tier is working

**Deliverable:** Payment flow verified

---

## CLAUDE'S PARALLEL SETUP (Weekend, ~3 hours)

No Jason involvement. Parallel to the above.

### Task 1: First Briefing Draft (90 min)
- [ ] You provide 1 macro divergence currently in your mind (see prompt below)
- [ ] Claude writes 1,200–1,500 word briefing on that divergence
- [ ] Structure:
  - Opening: the divergence (what institutions price vs. reality)
  - Second-order effects mapping (who profits? what happens next?)
  - Timeline (when does this unfold?)
  - Closing: what you're watching

**Deliverable:** First briefing draft ready for Jason review Monday

---

### Task 2: Gumroad + Stripe Setup (30 min)
- [ ] Create Gumroad account if not exists (gumroad.com)
- [ ] Connect Stripe to Gumroad (Settings → Payments)
- [ ] Create product page (templates, ready to go live)
- [ ] Stage first research report (not public, just ready)

**Deliverable:** Gumroad infrastructure ready

---

### Task 3: SendGrid API + Email Automation (30 min)
- [ ] Create SendGrid account (sendgrid.com)
- [ ] Generate API key (Settings → API Keys)
- [ ] Store key in `.env` file (don't commit to git)
- [ ] Test email delivery
- [ ] Set up Zapier (optional): When briefing published to Substack, send email to subscribers

**Deliverable:** Email infrastructure working

---

### Task 4: Google Sheet Tracker (15 min)
- [ ] Create Google Sheet with columns:
  - Date
  - Briefing paid subs
  - Briefing revenue
  - Template sales
  - Template revenue
  - Report sales
  - Report revenue
  - Free subscriber count
- [ ] Share with Jason (read-only or edit)

**Deliverable:** Revenue tracking template ready

---

## JASON'S REVIEW TASKS (Monday Morning)

### Task 1: Provide Divergence Examples (10 min)
Send Claude 1–2 current macro divergences you're watching. Format:

```
DIVERGENCE NAME: [Name]
WHAT INSTITUTIONS PRICE: [Headline narrative]
YOUR THESIS / REALITY: [What you see instead]
SECOND-ORDER EFFECTS: [Cascade — who profits, what happens next]
TIMELINE: [When this unfolds]
CONVICTION LEVEL: [High/Medium/Low]
```

**Example:**
```
DIVERGENCE: Sticky Inflation + Rate Expectations Mismatch
WHAT INSTITUTIONS PRICE: Soft landing + Fed cuts coming Q3
YOUR THESIS: Inflation stickier than expected, rates higher for longer
SECOND-ORDER EFFECTS: Credit quality deteriorates, recession risk 2025, companies with floating-rate debt struggle
TIMELINE: Unfolds over next 6–9 months as earnings disappoint
CONVICTION: High
```

Provide 2–3 examples like this.

**Deliverable:** Topic list for Claude to write

---

### Task 2: Review First Briefing Draft (Monday AM)
- [ ] Claude sends draft Monday morning (9 AM)
- [ ] You read (~15 min)
- [ ] You approve OR provide edits
- [ ] Final version ready by Monday 2 PM

**Deliverable:** Approved briefing copy

---

### Task 3: Approve Pricing + Timeline (Monday AM)
- [ ] Confirm briefing launches at $8/mo (not $12)
- [ ] Confirm templates at $29 bundle + $12 individual
- [ ] Confirm reports at $19 one-time (not $250/yr subscription)
- [ ] Confirm automation approach (manual publish Substack, Zapier email delivery, or alternative)

**Deliverable:** Launch parameters confirmed

---

## PUBLISH TIMELINE (Week 1)

**Monday (Day 1):** Jason approves first briefing  
**Tuesday (Day 2):** Claude publishes briefing to Substack paid tier  
**Tue–Wed:** Monitor first 48 hours of response (signups, Q&A, etc.)  
**Friday (Day 5):** Jason reviews initial metrics  
**By Day 7:** Decision: proceed to templates Week 2, or hold pending metrics

---

## WHAT NOT TO DO THIS WEEKEND

- ❌ Don't create templates yet (wait until briefing proves traction)
- ❌ Don't write research reports yet (wait for template signal)
- ❌ Don't worry about affiliate programs yet (handle Week 3)
- ❌ Don't do full product repositioning yet (just get paid briefing live first)
- ❌ Don't cross-post articles yet (focus on briefing launch)

**Focus:** Briefing only. Prove it works. Everything else follows.

---

## COMMON ISSUES (Solutions)

**"My Stripe bank verification is pending (takes 1–2 business days)"**
- Expected and normal. You can still create paid subscription tier and test it. Publishing will work once verified.
- Workaround: Publish Monday, Stripe likely verified by then.

**"I don't have a macro divergence topic ready"**
- Don't guess. Send Claude 2–3 trades/positions you're watching + why. Claude will identify the divergence.
- Or pick one from your recent articles (you've written about portfolio tracking — what's the macro thesis behind your approach?).

**"Substack is asking me for business entity info I don't have"**
- Substack accepts solopreneurs (no business entity required). Use your personal SSN for tax ID. You're good.

**"I can't connect Stripe to Gumroad"**
- This happens if Stripe verification is incomplete. Once Stripe bank account is verified, Gumroad will connect automatically. If stuck, contact Gumroad support (response usually <24 hours).

**"I'm not sure about the $8/mo price"**
- Don't overthink it. You can change price anytime. Start low, raise to $12 after 50 paid subs. This is standard.

---

## CRITICAL PATH (What Must Happen by Monday EOD)

- ✅ Substack paid tier live and testable
- ✅ First briefing draft completed
- ✅ Jason reviews + approves briefing
- ✅ Pricing + timeline confirmed
- ✅ Gumroad + email infrastructure ready

If all 5 are done by Monday EOD → Tuesday (Day 2) publish happens on schedule.

If any blocker → assess and adjust timeline (delay to Wed/Thu, still acceptable).

---

## JASON'S COMMITMENT (Weekend)

- **Setup time:** 30 minutes (4 tasks)
- **Review time:** 20 minutes (provide divergence, review draft)
- **Approvals:** 10 minutes (confirm pricing)
- **Total:** 60 minutes

This is the ONLY major time commitment before first revenue. Everything else is Claude-autonomous.

---

## NEXT INSTRUCTION

**Send Claude this before setup starts:**

1. Your 2–3 macro divergence topics (format above)
2. Confirmation of prices: $8/mo briefing, $29 bundle templates, $19 reports
3. Confirmation of launch: this weekend → first briefing live Tuesday

Once you confirm, setup begins. Claude handles everything else.

---

**Status:** Ready for weekend setup  
**First revenue:** Tuesday (Day 2) if all approvals done Monday  
**Confidence level:** High (all setup pieces ready, just need Jason sign-off)
