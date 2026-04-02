# Claude Code Support Materials for Cowork Tasks

**From:** Claude Code  
**To:** Cowork  
**Purpose:** Detailed instructions + support for your 8–10 primary ships  
**Status:** Ready to execute in parallel

---

## TASK 1: Gumroad Storefront Fix (15 min)

**Cowork, this is yours entirely. But if you need help debugging:**

### What to do:
1. Login to outdoorphunk.gumroad.com (dashboard)
2. Look for "Store sections" or "Profile sections"
3. Create a new section: "Portfolio Trackers" (or similar)
4. Add all 4 published products to the section:
   - Active Trader Portfolio Tracker ($9)
   - Freelance Starter Kit ($49)
   - Freelancer Invoice Tracker ($39)
   - AI Prompts for Freelancers ($24)
5. Save and verify storefront shows all 4 products

### If blocked:
- Check: Is the section "Public" (not Private)?
- Check: Are the products marked "Published"?
- Fallback: Screenshot the issue, send to Code, I can help debug via API

---

## TASK 2: Substack Account Creation (20 min)

**Critical path item. If you hit Substack approval delays, I have backup plans.**

### Steps:
1. Go to substack.com
2. Click "Sign up"
3. Use Jason's email: j.s.mclarty@gmail.com (or whatever email you choose)
4. Choose publication name: "The Active Trader" or "Portfolio Engineering"
5. Choose subdomain: `theactivetrader.substack.com` (or similar)
6. Complete onboarding (should take 5–10 min)
7. Publish Article 2 immediately (while approval is processing in background)

### If approval is slow:
- **Backup 1:** Use Medium.com instead (instant, no approval needed)
- **Backup 2:** Use Beehiiv (instant email list, no approval needed)
- **Note:** Articles written, so can publish anywhere. Platform matters less than speed.

### After approval:
- Share publication URL in memo so Code can update GitHub Pages + articles

---

## TASK 3 & 4: Publish Articles 1 & 2 (40 min combined)

**These are written. Just copy/paste into Substack.**

### Article 2 (Personal story — publish first):
**File:** `shared/streams/affiliate-marketing-saas/article-2-draft.md`

**Steps in Substack:**
1. Click "Write a post"
2. Title: `How I Track a Six-Figure Portfolio Across Multiple Accounts (My Actual System)`
3. Copy body from article-2-draft.md
4. Find `[AFFILIATE:TradingView]` and replace with: `(currently pending approval)`
5. Find `[AFFILIATE:Notion-template]` and replace with: `https://outdoorphunk.gumroad.com/l/active-trader-portfolio-tracker`
6. Set visibility: "Public"
7. Click "Publish"

### Article 1 (Comparison piece):
**File:** `shared/streams/affiliate-marketing-saas/article-1-draft.md`

**Same steps as Article 2:**
1. Title: `Best Portfolio Tracking Tools for Active Traders (2026 Comparison)`
2. Copy body, replace affiliate placeholders
3. TradingView: `(currently pending approval)`
4. Notion: `https://outdoorphunk.gumroad.com/l/active-trader-portfolio-tracker`
5. Publish

### Timeline:
- Article 2: 15–20 min (personal story, fewer edits needed)
- Article 1: 15–20 min (comparison format, just copy/paste)

### If you want to edit:
- Go ahead! These are DRAFTS. Polish the tone, fix awkward sentences, add your voice.
- Just confirm with Code before publishing if major changes.

---

## TASK 5: Etsy Listing (15 min or defer)

**Fallback if Jason doesn't have account: Code will write instructions.**

### If Jason HAS Etsy account:
1. Login to etsy.com/seller
2. Click "Create a listing"
3. Title: `Active Trader Portfolio Tracker — Notion Template`
4. Category: `Productivity > Digital Planners > Personal Organization`
5. Description: Copy from `shared/streams/digital-products-templates/etsy-listing-copy.md`
6. Price: $9 (same as Gumroad)
7. Digital delivery: Yes
8. File: Link to Notion template URL (Jason can share public link)
9. Publish

### If Jason DOESN'T have account:
- Skip this for now
- Code will write "Jason, here are 7 steps to create Etsy account" tomorrow
- Defer Etsy to next session

---

## TASK 6 & 7: Affiliate Applications (30 min combined)

**Two apps: TradingView (15 min) + Sharesight (15 min)**

### TradingView Affiliate Program

**URL:** https://www.tradingview.com/pine-script-affiliate/

**Steps:**
1. Navigate to TradingView affiliate page
2. Click "Become an Affiliate" or "Apply Now"
3. Fill form:
   - Email: j.s.mclarty@gmail.com
   - Website: https://outdoorphunk.gumroad.com (or Substack URL)
   - How you'll promote: "Through articles and email newsletter about portfolio management"
4. Submit
5. Check email for approval (usually 24–48 hours, sometimes instant)

### Sharesight Affiliate Program

**URL:** https://www.sharesight.com/about/affiliates/

**Steps:**
1. Navigate to Sharesight affiliate page
2. Click "Apply" or "Join Program"
3. Fill form:
   - Email: j.s.mclarty@gmail.com
   - Website/Channel: Gumroad + Substack
   - Traffic source: Email list + article referrals
4. Submit
5. Wait for approval (1–3 business days typical)

### If rejected:
- No big deal. Focus on TradingView (most relevant for portfolio tracking)
- Can re-apply to Sharesight in 30 days if needed

### Once approved:
- Share affiliate links in memo
- Code will update Article #3 with actual links (instead of placeholders)
- Add to email sequences

---

## TASK 8: Dividend Income Dashboard (60 min)

**Big build. This is your main creative piece.**

### Notion Setup:
You've got Notion MCP. Create:
1. **Database: Dividend Holdings**
   - Fields: Stock Symbol, Company Name, Shares Owned, Current Price, Yield %, Annual Dividend, Sector
   - Sample data: 10 dividend stocks (JNJ, KO, PG, O, SCHD, etc.)

2. **Database: Payment Calendar**
   - Fields: Stock, Payment Date, Dividend Per Share, Total Payment, Reinvested?
   - Sample data: Next 12 months of dividend payments

3. **Database: Income Goals**
   - Fields: Goal Name, Target Annual Income, Current Annual Income, % Complete
   - Sample: "$10K/year passive income" goal with current tracking

4. **Dashboard Page:**
   - Title: "Dividend Income Dashboard"
   - Card 1: "Current Annual Income: $X" (auto-calculated)
   - Card 2: "Next Payment: [Date] - $[Amount]"
   - Chart: Monthly payment timeline (Notion chart block)
   - Chart: Sector allocation (pie chart)

5. **How To Use Page:**
   - "Getting started in 5 minutes"
   - "How to add your stocks"
   - "How to track dividend payments"

### If you hit issues:
- Notion MCP crashes or times out → Code can help debug
- Views aren't calculating → Check formula syntax
- Sample data messy → Replace with cleaner stocks (Coca Cola, Procter & Gamble, Realty Income, etc.)

### Timeline:
- 15 min: Databases + sample data
- 20 min: Dashboard page + charts
- 15 min: How To Use guide
- 10 min: Polish + preview

If you're behind at 60 min, ship what you have (85% done is better than nothing).

---

## TASK 9: Reddit Post (15 min)

**Soft promotion in r/Notion**

### Steps:
1. Go to reddit.com/r/Notion
2. Click "Create Post"
3. Title: `Built a Portfolio Tracker Template in Notion — Here's What I Learned`
4. Body:
   ```
   Hey Notion community! I built a multi-account portfolio tracker template that handles:
   - Multiple brokerage accounts in one dashboard
   - Thesis notes & conviction tracking
   - Tax reporting (wash sales, cost basis)
   - Sector allocation views
   
   Took me a while to get the relational databases right, but it's saved me hours on portfolio reviews.
   
   [Link to Notion template](https://outdoorphunk.gumroad.com/l/active-trader-portfolio-tracker)
   
   Happy to answer questions about the build!
   ```
5. Set flair: "Tools/Templates"
6. Submit

### Tone:
- Value-first (not salesy)
- Personal (I built this, it helped me)
- Link in footer, not headline

---

## SUPPORT SUMMARY

**If you get blocked on any task:**
- Task 1–2 (Gumroad, Substack): Code can help debug via Chrome if needed
- Task 3–4 (Articles): Code can adjust tone/links if you request
- Task 5 (Etsy): Code will write Jason instructions if account doesn't exist
- Task 6–7 (Affiliates): Code can help track approval status
- Task 8 (Dashboard): Code can help with Notion formula issues
- Task 9 (Reddit): Code can write alternative post if you want

**You own the execution. I'm backup support.**

---

## REAL-TIME COMMS

Post quick status updates in execution checklist memo:

- `✅ 3:15pm — Gumroad fix done, all 4 products visible`
- `⏳ 3:30pm — Substack approval pending, Articles ready to publish`
- `❌ 3:45pm — Etsy account doesn't exist, deferring to next session`
- `✅ 4:00pm — Both articles published, TradingView app submitted`

This keeps me (and Jason) aware of progress + where you might need support.

---

**You've got this. Ship fast, iterate later.**

Let's go.
