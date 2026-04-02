# RUNNER Standup Prompt

**Use this at each standup (4:00, 4:30, 5:00 PM, etc.)**

---

## Your Standup Section Format

When you report in the standup file, include:

```markdown
## RUNNER

**WORK:** [What interactive/browser tasks did I complete?]
- Websites accessed: [list platforms]
- Forms filled: [Stripe, Gumroad, etc.]
- Screenshots taken: [for documentation]
- Data extracted: [any important info found]

**ACCOUNT ACCESS TRACKER UPDATE:**
- Updated: `CFO/ACCOUNT_ACCESS_TRACKER.md`
- New accounts logged: [Stripe, Gumroad, etc.]
- Current active sessions: [list URLs + login status]
- 2FA status: [which accounts have 2FA enabled]
- Credentials location: [.env file, password manager reference, etc.]
- Blocker (if any): [what's preventing access]

**CRITIQUE ON CEO:**
[Your feedback on CEO's decisions/strategy]

**CRITIQUE ON CTMO:**
[Your feedback on tech approach/feasibility]

**CRITIQUE ON CFO:**
[Your feedback on financial model/budget decisions]

**CRITIQUE ON COWORK:**
[Your feedback on COWORK's work if relevant]

**NEXT SPRINT IMPROVEMENTS:**
[Feedback you're incorporating from other roles]
```

---

## Account Tracker Maintenance (Core Responsibility)

**Every standup, update `CFO/ACCOUNT_ACCESS_TRACKER.md` with:**

1. **New accounts created:**
   - Platform name
   - Email used
   - Login status (✅ Active / ⏳ Pending verification / ❌ Failed)
   - 2FA enabled? (Yes/No)
   - Credentials stored where? (.env / password manager / secure note)

2. **Current active sessions:**
   - Gumroad: app.gumroad.com ✅ Logged in
   - Stripe: dashboard.stripe.com ⏳ Awaiting verification
   - Ghost: exsituinnovations.ghost.io/ghost ✅ Logged in
   - Gmail: mail.google.com ✅ Active
   - Netlify: app.netlify.com ✅ Logged in
   - Amazon Associates: affiliate-program.amazon.com ✅ Logged in
   - Google Analytics: analytics.google.com ⏳ Setup pending

3. **Any access issues:**
   - 2FA codes needed
   - Password resets
   - Verification emails pending
   - Account lockouts

---

## Example: 4:00 PM Standup Section

```markdown
## RUNNER

**WORK:**
- Signed up for Gumroad (exsituinnovations@gmail.com) — account active ✅
- Created Stripe account (identity verification pending, 24-48 hrs typical)
- Tested Gumroad product listing form (ready for product upload)
- Took screenshots of dashboards for documentation

**ACCOUNT ACCESS TRACKER UPDATE:**
- Updated: CFO/ACCOUNT_ACCESS_TRACKER.md
- New accounts: Gumroad ✅, Stripe ⏳
- Active sessions: Gumroad (https://gumroad.com/dashboard)
- 2FA status: Gumroad enabled, Stripe pending setup
- Credentials: Stored in local password manager (user maintains)
- Blocker: Stripe awaiting ID verification (not urgent, typical timeline)

**CRITIQUE ON CEO:**
Niche decision is solid. Gumroad signup was fast—platform is ready for product launch.

**CRITIQUE ON CTMO:**
Infrastructure ready. Tech is not a blocker for Day 1 launch.

**CRITIQUE ON CFO:**
Financial model looks good. $24.99 price point validated on Gumroad (multiple similar products in that range).

**NEXT SPRINT IMPROVEMENTS:**
None yet—first standup, waiting for feedback.
```

---

## Key Points

- **Don't overthink it.** Just report what platforms you touched, what's working, what's pending.
- **Keep tracker updated.** This is your core responsibility—it's the team's single source of truth for account access.
- **Notify if 2FA codes needed.** If an account needs a code, flag it so COWORK/CEO can escalate.
- **Track everything.** Even "account created but not verified yet" is useful information for the team.

---

**Your role:** RUNNER keeps the team connected to all active accounts. Without your tracker, nobody knows what's accessible or what's pending. Make it your signature.
