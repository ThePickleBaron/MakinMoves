# ExsituInnovations — Company Information

## Company Basics
- **Name:** ExsituInnovations
- **Domain:** exsituinnovations.com
- **Email:** exsituinnovations@gmail.com
- **Founded:** 2026-03-29

---

## Service Accounts (Created)

### Email & Communications
- **Twilio SendGrid** (formerly SendGrid)
  - Account: exsituinnovations@gmail.com
  - Status: ✅ Ready to configure
  - Purpose: Email delivery for SaaS/content

### Domain
- **exsituinnovations.com**
  - Status: ✅ Active
  - Email: exsituinnovations@gmail.com
  - Purpose: Brand domain for all streams

---

## Service Accounts (To Create)

### Priority 1: Digital Products & Payment Processing
- [ ] **Gumroad** (digital products marketplace)
  - Email: exsituinnovations@gmail.com
  - What to sell: Templates, courses, ebooks

- [ ] **Stripe** (payment processing)
  - Account: exsituinnovations
  - Webhook: https://exsituinnovations.com/webhooks/stripe
  - Used by: Digital products, SaaS subscriptions

### Priority 2: Content & Affiliate
- [ ] **Ghost** (blogging platform) or **Netlify** (static hosting)
  - Domain: exsituinnovations.com
  - Email: exsituinnovations@gmail.com
  - Purpose: Content hub for affiliate marketing

- [ ] **Google AdSense**
  - Domain: exsituinnovations.com
  - Email: exsituinnovations@gmail.com
  - Purpose: Ad revenue from content

- [ ] **Amazon Associates**
  - Email: exsituinnovations@gmail.com
  - Purpose: Affiliate commissions

- [ ] **ShareASale / Impact**
  - Email: exsituinnovations@gmail.com
  - Domain: exsituinnovations.com
  - Purpose: Additional affiliate programs

### Priority 3: SaaS Hosting
- [ ] **Railway.app** (SaaS hosting)
  - Project name: exsituinnovations-saas
  - Email: exsituinnovations@gmail.com
  - Domain: saas.exsituinnovations.com (or subdomain)

### Priority 4: Analytics & Monitoring
- [ ] **Google Analytics 4**
  - Property: exsituinnovations
  - Domain: exsituinnovations.com
  - Email: exsituinnovations@gmail.com

- [ ] **Google Search Console**
  - Domain: exsituinnovations.com
  - Email: exsituinnovations@gmail.com

### Optional: Trading/Bots
- [ ] **Binance** or **Coinbase** (if pursuing crypto trading)
  - Email: exsituinnovations@gmail.com
  - Account type: Business/trading

---

## Email Addresses in Use

| Service | Email | Status |
|---------|-------|--------|
| Domain registrar | exsituinnovations@gmail.com | ✅ Primary |
| Google services | exsituinnovations@gmail.com | ⏳ To configure |
| Twilio SendGrid | exsituinnovations@gmail.com | ⏳ To configure |
| Stripe | exsituinnovations@gmail.com | ⏳ To create |
| Gumroad | exsituinnovations@gmail.com | ⏳ To create |
| All other services | exsituinnovations@gmail.com | ⏳ To create |

---

## Branding Assets

**Logo/Brand Color:** [TBD]

**Company Description:**
[TBD - to be defined by CEO for marketing]

---

## Revenue Streams Under ExsituInnovations

### 1. Digital Products (Gumroad + Stripe)
- Platform: Gumroad (gumroad.com/@exsituinnovations or custom domain)
- Products: Templates, ebooks, courses, printables
- Payment: Stripe integrated with Gumroad

### 2. Content & Affiliate (Ghost/Netlify + AdSense + Affiliates)
- Site: exsituinnovations.com (content hub)
- Revenue: AdSense + Amazon Associates + other affiliate networks
- Email updates: Twilio SendGrid

### 3. SaaS (Railway + Stripe)
- Domain: saas.exsituinnovations.com or tool.exsituinnovations.com
- Payment: Stripe (subscriptions)
- Email: Twilio SendGrid

### 4. Trading (Paper trading + possible crypto)
- Name: ExsituInnovations Trading
- Exchanges: TradingView (paper), Binance/Coinbase (if live)
- Email: exsituinnovations@gmail.com

---

## DNS Setup (When Ready)

For exsituinnovations.com:
- **A record:** Points to hosting provider (Ghost, Netlify, or custom)
- **MX records:** Set up for email forwarding (if using custom domain email)
- **CNAME for SaaS:** saas.exsituinnovations.com → Railway domain
- **Google verification:** For Search Console
- **Stripe webhook:** Configured in Stripe dashboard

---

## Credentials Tracker

**IMPORTANT:** Create `CFO/credentials_tracker.md` (DO NOT commit to git)

Keep sensitive info organized:
- Stripe API keys (separate file, .env only)
- Gumroad account credentials
- Ghost/Netlify login
- SendGrid API key
- Google service account credentials
- Any other paid service passwords

**Rule:** Never commit credentials to git. Use .env files and password manager.

---

## Next Steps

1. **Update all services to use exsituinnovations.com** (where applicable)
2. **Set up email forwarding** (exsituinnovations@gmail.com → personal email)
3. **Create Stripe account** with company name
4. **Configure Twilio SendGrid** for email delivery
5. **Set up Google Analytics & Search Console** for domain
6. **Create Gumroad account** under company brand

---

**Status:** Company created, domain active, ready for service signup
**Created:** 2026-03-29
**Last Updated:** 2026-03-29

---

**Board visibility:** Share this file with CEO/COO/CTMO/CFO so they know the brand and account names when setting up services.
