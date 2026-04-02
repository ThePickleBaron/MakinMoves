# Revenue Tracking Template

**Purpose:** Daily/weekly revenue tracking for MakinMoves revenue sprint  
**Format:** Google Sheet (shared, real-time)  
**Owner:** Jason (can input) | Claude Code + Cowork (can view)  
**Update frequency:** Daily or weekly

---

## Google Sheet Structure

Create a new Google Sheet and name it "MakinMoves Revenue Tracker 2026"

### Columns

| Date | Product | Platform | Sales | Revenue | Affiliate Source | Affiliate Revenue | Email Subscribers | Notes |
|------|---------|----------|-------|---------|------------------|-------------------|-------------------|-------|
| 2026-04-02 | Notion Tracker | Gumroad | 0 | $0 | TradingView | $0 | 0 | First day |
| ... | ... | ... | ... | ... | ... | ... | ... | ... |

---

## Data Entry Guide

**Date:** Day you're recording (e.g., 2026-04-02)

**Product:** 
- Notion Tracker
- Google Sheets Tracker
- Dividend Dashboard (when live)
- Articles (when monetized)

**Platform:** Where the sale occurred
- Gumroad
- Etsy
- Substack
- Affiliate link (specify which program)

**Sales:** Number of individual sales that day/week

**Revenue:** $ amount from product sales

**Affiliate Source:**
- TradingView
- Sharesight
- Stock Rover
- Other

**Affiliate Revenue:** $ from affiliate clicks/signups/commissions

**Email Subscribers:** Running total (cumulative)

**Notes:** Context ("launched Substack," "published Article 1," "Etsy listing rejected," etc.)

---

## Summary Row (Weekly)

Add a summary row every Friday with:
- Total sales (products + affiliates)
- Total revenue
- Email subscriber growth
- Key events

---

## Public View

Share a read-only version of this sheet publicly (link in Substack footer):
- Lets subscribers see progress toward $500/month goal
- Builds social proof ("we're growing")
- Holds us accountable

---

## Link for Sheet

Once created, share this link in:
- Substack header
- Notion template FAQ
- Final email sequence

Example format:
"Follow our progress: [Google Sheet link] — We're tracking revenue in real-time as we build toward $500/month."

---

## Formulas (Auto-Calculate)

Add formulas to auto-sum:
- `=SUM(E:E)` for total revenue
- `=SUM(G:G)` for total affiliate revenue
- `=COUNTA(H:H)` for unique subscriber updates

Keep it simple — manual entry is fine for now.

---

## Backup

Export this sheet to CSV monthly in case Google Sheets has issues.

Store backups in: `./shared/logs/revenue-tracker-backup-YYYY-MM.csv`
