# Substack Paid Subscriptions Setup — Complete Walkthrough for Jason

**Time estimate:** 25 minutes total (Stripe verification may take 1-2 business days)
**Goal:** Get "Entropy & Divergence" ready to accept paid subscribers at $8/month

**Prerequisites:**
- Substack account already created and published (you have this)
- Bank account ready (routing number + account number handy)
- Government ID (driver's license or passport for Stripe identity check)

---

## SECTION 1: Connect Your Bank Account via Stripe (10 min)

Stripe is Substack's payment processor. Money flows: Readers → Stripe → Your bank account.

### Step 1.1: Navigate to Payments Settings

1. Go to your Substack publication dashboard
2. Click **Settings** (top right, gear icon)
3. In the left sidebar, click **Payments**

**What you should see:** A section titled "Payments" with a blue button that says "Connect with Stripe"

### Step 1.2: Click "Connect with Stripe"

1. Click the blue **"Connect with Stripe"** button
2. You'll be redirected to Stripe's setup flow (new tab or same tab)

### Step 1.3: Fill in Stripe Identity Information

Stripe will ask for:

| Field | What to Enter | Notes |
|-------|---------------|-------|
| **Full legal name** | Your real name (as on ID) | Must match government ID |
| **Email address** | Your personal email | Where Stripe will send verification emails |
| **Phone number** | Your actual phone | Stripe may verify by SMS |
| **Date of birth** | Your DOB | For identity verification |
| **Address** | Street address | Can use home address or virtual mailbox (readers may see this on receipts) |
| **Country** | United States | (If applicable) |

**⚠️ Important:** These details must match your government ID exactly. Stripe will verify them.

### Step 1.4: Add Your Bank Account

Stripe asks for payment destination. Two options:

**Option A: Link via Online Banking (Faster)**
1. Choose "Link your bank account"
2. Stripe will ask for your online banking login (doesn't store it)
3. Select your bank from the list and authenticate
4. Confirm the correct account (last 4 digits will show)

**Option B: Manual Entry (If online linking fails)**
1. Choose "Enter bank details manually"
2. Enter:
   ```
   Routing number: [Your bank's routing number — look on check or bank statement]
   Account number: [Your actual account number]
   Account holder name: [Full name on account]
   ```

**Verification:** Stripe will deposit 2 small test amounts ($0.01 and $0.02) into your account in 1-2 business days. You'll need to confirm these amounts in Stripe to verify ownership.

### Step 1.5: Add Customer Support Information (What Readers See)

Stripe collects customer support details for your subscribers' receipts and credit card statements:

| Field | What to Enter | Notes |
|-------|---------------|-------|
| **Business name** | Entropy & Divergence (or your publication name) | What appears on subscribers' credit card statements |
| **Support email** | Your email | Subscribers can email with payment issues |
| **Support phone** (optional) | Your phone | Optional; readers may see this on receipts |
| **Support website** | Your Substack URL | For reference |

**Privacy tip:** If you don't want your phone on statements, leave it blank or use a Google Voice number.

### Step 1.6: Review and Submit

1. Stripe will show you a summary of everything you entered
2. Confirm it's all correct
3. Click **"Activate my Stripe account"** (or similar language)

**You'll see:** "Stripe account created successfully" or similar message.

---

## What Happens Next: Bank Verification (1-2 Business Days)

✅ **Success indicator:** You return to your Substack Settings → Payments page, and the "Connect with Stripe" button is now replaced with your Stripe account status (shows as "Connected" with options to manage your account).

**Timeline:**
- **Immediately:** Stripe account created, you can see "Connected" on Payments page
- **1-2 business days:** Stripe deposits two test amounts in your bank account
- **Your action:** Check your bank, find those two amounts, log into Stripe and confirm them
- **Result:** Your Stripe account is fully activated

### If Verification is Slow

If you don't see the test deposits after 2-3 business days:

1. Log into your Stripe account (via Substack's Payments page)
2. Check your Stripe dashboard for any alerts or requests for additional info
3. Stripe may email you asking for documents (proof of address, utility bill, etc.)
4. If this happens, respond within the deadline Stripe gives you — **payments will be paused without response**

---

## SECTION 2: Add Tax Information (5 min)

This is required so Stripe can issue your 1099-K tax form at year-end (if you earn over $20K).

### Step 2.1: Where to Find Tax Settings

1. Stay in Substack Settings → Payments
2. In the Stripe section, look for **"Tax information"** or **"W-9 information"**
3. Click **"Add tax information"** (or the settings icon next to Stripe)

You'll be directed back to your Stripe dashboard (in a new tab or popup).

### Step 2.2: Enter Your Tax ID

In Stripe, you'll see a section for "Tax ID" or "Business tax information."

**For U.S. residents:**

| Situation | What to Enter |
|-----------|--------------|
| **Individual (sole proprietor)** | Your Social Security Number (SSN) |
| **Business (LLC, S-Corp, etc.)** | Your Employer Identification Number (EIN) from the IRS |

```
Example SSN format: XXX-XX-XXXX (9 digits, with dashes)
Example EIN format: XX-XXXXXXX (9 digits, with dash in middle)
```

**For non-U.S. residents:**
Stripe will ask for your country's equivalent (e.g., VAT ID in UK/EU).

### Step 2.3: Confirm Full Legal Name and Address

Stripe will pre-fill your name and address from Step 1.3. Confirm they're correct — they must match your tax records.

### Step 2.4: Save

Click **"Save"** or **"Confirm."**

**✅ Success indicator:** You see "Tax information added" or the screen closes. Return to Substack Settings → Payments. You should see "Tax information on file" confirmation.

**What Stripe does with this:** Issues your 1099-K form at year-end if you earn $20K+. IRS gets a copy too. The amount on your 1099 is GROSS (before Stripe and Substack fees deducted), so you'll need to track deductions separately for taxes.

---

## SECTION 3: Enable Paid Subscriptions (5 min)

Now that Stripe is connected, you can enable paid tiers on your publication.

### Step 3.1: Still in Settings → Payments

Look for the **"Enable payments"** toggle (large switch, probably gray/off right now).

### Step 3.2: Set Your Subscription Tier Price

You'll see three price fields:

```
Monthly subscription:    $___
Annual subscription:     $___
Founding member:         $___
```

**Recommended for Entropy & Divergence:**

| Tier | Price | Why |
|------|-------|-----|
| **Monthly** | $8/month | Standard for finance/trading newsletters; profitable but accessible |
| **Annual** | $76/year | Discount encourages annual commits (vs. $96 for 12 months) |
| **Founding member** | $199 one-time | Optional; creates urgency early. Can leave blank if not doing founding launch |

**Minimum price:** Substack requires $5/month minimum.

**Finance/trading niche:** Substacks in this category typically charge $10-15/month. At $8, you're competitive and approachable for your early audience.

### Step 3.3: Add Subscription Benefits (What Readers Get)

Click on **"Subscription benefits"** or **"Tier descriptions"** to add what paid subscribers receive.

**Example for Entropy & Divergence:**

```
Monthly Subscriber ($8/month):
- Full access to all posts
- Weekly macro conviction thesis breakdown
- Trading setup commentary (entries, exits, position management)
- Subscriber-only email updates on major market moves
- Access to back catalog of all paid content

Annual Subscriber ($76/year):
- Everything in monthly, plus:
- Save ~$20 vs. monthly
- Uninterrupted access through the year

Founding Member ($199 one-time):
- Everything in annual
- Lifetime founding member badge on your profile
- First to access new products or signals
- Optional: Q&A session or monthly office hours [your choice]
```

Keep it focused on **what they get** (not "support my work" generic copy). Readers in the trading niche care about **infrastructure, discipline, and differentiation.**

### Step 3.4: Click "Enable Payments"

Once you've set prices and written benefits:

1. Toggle the **"Enable payments"** switch to ON (it should turn blue/green)
2. You may see a confirmation message: "Payments enabled" or "Live"

**⚠️ Important:** Stripe's initial verification may not be complete yet. If you see a warning like "Payments paused," it means Stripe is still verifying your identity. Check your email from Stripe for next steps.

### Step 3.5: Save Your Changes

Click **"Save"** or **"Publish"** (Substack auto-saves usually, but confirm with the button).

**✅ Success indicator:** 
- The "Enable payments" toggle is ON/blue
- Your prices appear in the Payments section
- When you view your publication as a non-logged-in reader, there's now a **"Subscribe"** button visible at the top and bottom of posts

---

## SECTION 4: Test the Subscription Flow (5 min)

Before publicizing, make sure the subscribe button works and the payment flow looks right.

### Step 4.1: View Your Publication as a New Reader

1. Open your Substack publication in a new **incognito/private browser window** (Ctrl+Shift+N on Windows, Cmd+Shift+N on Mac)
2. Navigate to your Substack URL (e.g., `entropyanddivergence.substack.com`)

**What you should see:**
- Your publication header/logo
- Posts with a "Subscribe" button visible (top right and/or at end of free posts)

### Step 4.2: Click the Subscribe Button

1. Click any **"Subscribe"** button
2. A popup or new page should appear with three tiers:
   - Monthly ($8/month)
   - Annual ($76/year)
   - Founding Member ($199 one-time) [if you set this up]

### Step 4.3: Test the Free Trial (Don't Charge Yourself)

1. Select **"Monthly"**
2. You should see: **"7-day free trial"** option
3. Click **"Start your free trial"**

Substack will ask for your email and credit card details to set up the trial.

**⚠️ Don't use your real card for testing.** Use a test card number provided by Stripe:

```
Test card number: 4242 4242 4242 4242
Expiry: 12/34
CVC: 123
```

4. Enter test details and complete the flow
5. **DO NOT submit with your real card unless you want to charge yourself**

### Step 4.4: Confirm What Happens After

You should see:
- Confirmation message: "Your free trial starts now" or "Subscription active"
- Email sent to you confirming the trial
- A link to manage your subscription (to cancel if needed)

### Step 4.5: Cancel the Test Trial (Clean Up)

1. Go to your Substack account (log in as yourself, not as reader)
2. Click **"Manage subscription"** or go to your subscriptions
3. Find the test subscription and click **"Cancel"**
4. Confirm cancellation

**✅ Success indicator:** 
- Subscribe button is visible to non-logged-in readers
- Free trial option appears
- Payment form loads without errors
- Confirmation email is sent
- You can manage/cancel subscriptions

---

## SECTION 5: What to Do If Something Goes Wrong

### "Stripe account not verified yet"

**Problem:** You see a message like "Your Stripe account is pending verification" or "Payments paused."

**Solution:**
1. Check your email from Stripe (look in spam folder too)
2. Stripe may be asking for additional information:
   - Proof of address (utility bill, lease agreement)
   - Business documentation (if applicable)
   - Selfie with ID
3. **Respond within Stripe's deadline** (usually 7 days). Payments won't process without response.
4. Once Stripe confirms, your account automatically activates — no action needed on Substack side.

**Timeline:** Most accounts activate within 1-2 business days. If longer than 3 days, contact Stripe support.

---

### "Test card declined" or "Can't complete payment"

**Problem:** The payment form won't process, even with test card.

**Solution:**
1. Make sure you're using the exact test card number: `4242 4242 4242 4242`
2. Make sure expiry is in the future (e.g., 12/34)
3. Make sure CVC is any 3 digits (e.g., 123)
4. Clear your browser cache (Ctrl+Shift+Delete) and try again
5. Try a different browser (Safari instead of Chrome, etc.)

If still failing, your Stripe account may not be fully activated. Wait for Stripe verification email.

---

### "I don't see a Subscribe button on my publication"

**Problem:** Readers visit your site but no "Subscribe" button is visible.

**Solution:**
1. Confirm "Enable payments" toggle is ON in Settings → Payments
2. If toggle is OFF, turn it ON and save
3. Wait 5-10 minutes for changes to propagate
4. Refresh the page in an incognito window
5. If still missing, check Stripe account status in Settings → Payments (should say "Connected")

---

### "Bank verification deposits didn't arrive"

**Problem:** You're waiting for the two test deposits from Stripe, but they haven't shown up after 2-3 days.

**Solution:**
1. Check your bank account carefully — they're very small ($0.01 and $0.02)
2. They may appear as pending — wait for them to clear (1-2 business days)
3. Once they appear, log into Stripe and confirm the amounts:
   - Go to Stripe dashboard
   - Look for "Bank verification" or "Verify bank account"
   - Enter the two amounts
4. If deposits never arrive after 5 business days:
   - Log into Stripe
   - Check for alerts or messages from Stripe
   - Contact Stripe support (support.stripe.com) with your account details

---

### "Stripe is asking for extra documents"

**Problem:** You got an email from Stripe asking for passport, business license, proof of address, etc.

**Solution:**
1. **Don't ignore this.** Stripe has a deadline (usually 7 days)
2. Gather the documents Stripe asks for (e.g., utility bill, driver's license)
3. Upload them via the link in Stripe's email or your Stripe dashboard
4. Stripe will review (typically 1-3 business days)
5. Once approved, you'll get confirmation and payments activate automatically

This is normal for some accounts — Stripe is just verifying you're a real person for money-laundering prevention.

---

### "I can't log into my Stripe account from Substack"

**Problem:** You click "Manage Stripe" in Substack and get an error.

**Solution:**
1. Log into Stripe directly at stripe.com (use your email from Stripe's verification email)
2. Your Substack account is already linked to this Stripe account
3. You can manage everything from stripe.com directly
4. Or go back to Substack and ensure you're logged in before clicking Stripe settings

---

## Fees Summary

**What will Substack and Stripe take from your revenue?**

| Processor | Fee | Applied |
|-----------|-----|---------|
| **Substack** | 10% | Off gross revenue |
| **Stripe credit card** | 2.9% + $0.30 | Per transaction |
| **Stripe recurring billing** | 0.5% | Per monthly charge |

**Real example:** $8/month subscription
```
Gross revenue:                    $8.00
Stripe fee (2.9% + $0.30 + 0.5%): -$0.53
Substack fee (10%):              -$0.80
Your net per subscriber:          $6.67
```

For annual ($76/year):
```
Gross:                            $76.00
Stripe fee (one transaction):     -$2.51
Substack fee (10%):              -$7.60
Your net per subscriber:          $65.89
```

**You don't need to do anything — Stripe and Substack automatically deduct these.**

---

## Success Checklist

Before you launch paid subscriptions, confirm all of these:

- [ ] **Stripe connected** — "Connected" status shows in Settings → Payments
- [ ] **Bank verified** — You've confirmed the two test deposits in Stripe (if asked)
- [ ] **Tax info added** — "Tax information on file" message appears
- [ ] **Prices set** — Monthly ($8), Annual ($76), Founding (optional)
- [ ] **Benefits written** — Subscribers know what they get
- [ ] **Payments enabled** — "Enable payments" toggle is ON (blue)
- [ ] **Subscribe button visible** — Shows on your publication when logged out
- [ ] **Test successful** — You tested free trial flow (and cancelled it)
- [ ] **No warnings** — No red alerts in Stripe or Substack settings

**If all boxes are checked: You're ready to publicize.**

---

## What's Next: Publish and Promote

1. **First paid post:** Write a compelling, paywalled post that shows the value
   - Free preview for non-subscribers (optional)
   - Full access for paid subscribers
   - Enforce via Substack's paywall toggle

2. **Announce to your list:** Send a free post to all subscribers saying paid tier is live
   - Link to the subscription page
   - Explain what paid subscribers get
   - Offer a 7-day free trial

3. **Monitor payouts:** After your first paid subscription:
   - First payout takes 7-14 days to arrive
   - After that, payouts arrive within 48 hours (daily or weekly, you choose)

4. **Track for taxes:** Stripe will email you a 1099-K form in January (if you earned $20K+)
   - Download it for your tax return
   - Remember to deduct Stripe and Substack fees from the gross amount

---

## Quick Reference: Settings Path

To get back to Payments any time:

**Substack dashboard → Settings (gear icon) → Payments (left sidebar)**

---

## Support Resources

- [Substack: How to set up a paid publication](https://support.substack.com/hc/en-us/articles/360037459952-How-do-I-set-up-a-paid-publication)
- [Substack: How to set up Stripe account](https://support.substack.com/hc/en-us/articles/4405482746132-How-do-I-set-up-my-Stripe-account-on-Substack-to-start-receiving-payments)
- [Stripe: Getting started with tax reporting](https://docs.stripe.com/connect/get-started-tax-reporting)
- [Substack: How do paid subscriptions work?](https://faq.substack.com/p/how-do-paid-subscriptions-on-substack)

---

**Last updated:** April 3, 2026
**Status:** Ready for Jason's use
