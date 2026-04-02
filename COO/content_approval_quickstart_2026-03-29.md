# Content Approval Workflow — COO Quick Start Guide

**Status:** For autonomous operation (zero human intervention after March 31)

**Time commitment:** 10 minutes per day

---

## THE BIG PICTURE

After you create content in Notion, you approve it using a simple folder workflow:

```
You create in Notion → CTMO exports to CSV → You review and move to /approved/ → n8n publishes automatically
```

That's it. No code. No database. No API calls.

---

## DAILY WORKFLOW (10 minutes)

### Step 1: Check your email (8:05 AM)

CTMO's system sends you an email every day at 8:00 AM with subject: **"Daily Content Sync"**

Example:
```
Subject: Daily Content Sync — 3 new items ready for review

Digital Products: 1 new item (SaaS Founder Tracker)
Print-on-Demand: 2 new items (DevOps shirt, Founder shirt)
Affiliate Articles: 0 new items

Review in: C:\Users\jsmcl\Documents\MakinMoves\MakinMoves-portable\content\approved\

Last export: 2026-03-29 08:00 UTC ✓
```

### Step 2: Open the approval folder (8:10 AM)

Navigate to:
```
C:\Users\jsmcl\Documents\MakinMoves\MakinMoves-portable\content\approved\
```

You'll see 3 CSV files:
- `digital-products.csv` — Notion templates you created
- `pod-designs.csv` — Canva shirt designs
- `affiliate-articles.csv` — Blog post outlines

### Step 3: Open one CSV in Excel/Sheets (8:15 AM)

Example: `digital-products.csv`

You'll see columns:
| product_id | title | niche | status | approved_date | published_date |
|---|---|---|---|---|---|
| DP001 | SaaS Founder Tracker | SaaS Founders | **draft** | (empty) | (empty) |
| DP002 | Freelancer Invoice | Freelancers | **draft** | (empty) | (empty) |

### Step 4: Approve content (5 minutes)

For each row you want to approve:

1. **Check the "status" column** — If it says "draft", it's waiting for you
2. **Review the title & niche** — Does it look good?
3. **Change status** from "draft" to "approved"
4. **Leave other columns alone** — n8n will fill in the dates

Example (after approval):
| product_id | title | niche | status | approved_date | published_date |
|---|---|---|---|---|---|
| DP001 | SaaS Founder Tracker | SaaS Founders | **approved** | 2026-03-29 | (stays empty) |
| DP002 | Freelancer Invoice | Freelancers | **draft** | (empty) | (empty) |

### Step 5: Save the file (8:25 AM)

Press **Ctrl+S** to save.

**IMPORTANT:** Keep the filename exactly the same:
- `digital-products.csv` (not `digital-products-edited.csv`)
- `pod-designs.csv`
- `affiliate-articles.csv`

### Step 6: Done!

n8n will automatically:
- Pick up the approved items at 9:00 AM
- Publish to all platforms (Gumroad, Etsy, WordPress, etc.)
- Fill in the `published_date` column when done
- Email you a summary: "✓ 2 products published"

---

## COMMON QUESTIONS

### Q: Can I approve items in bulk?

**A:** Yes! Open the CSV, select the column with "draft" values, change all to "approved" at once. Just remember to save.

### Q: What if I change my mind?

**A:** Change `status` back to "draft" and save. If the item hasn't published yet (published_date is still empty), n8n won't touch it. If it already published, you'll need to manually unpublish (contact CTMO for help).

### Q: Do I need to fill in `approved_date` and `published_date`?

**A:** No. n8n fills those in automatically. You only change the "status" column.

### Q: What if I see an error in the CSV?

**A:** Check the `/content/logs/publishing-errors.log` file. If you can't fix it, contact CTMO. Common issues:
- Image file doesn't exist (check path in `image_path` column)
- Price is invalid (must be like 19.99, not $19.99)
- Missing required field (some columns can't be empty)

### Q: How do I see what's been published?

**A:** Check the `published_date` column in the CSV. Any item with a date = published.

Or visit the platform:
- Gumroad: https://gumroad.com/dashboard
- Etsy: https://www.etsy.com/your/shops
- WordPress: https://blog.makinmoves.io/wp-admin

### Q: Can I add new products while others are publishing?

**A:** Yes! Create new rows in Notion, and the next export (8:00 AM tomorrow) will include them. You can approve those tomorrow.

---

## FILE STRUCTURE (What You Need to Know)

```
content/
├── approved/
│   ├── digital-products.csv          ← You edit this
│   ├── pod-designs.csv               ← You edit this
│   └── affiliate-articles.csv        ← You edit this
│
├── drafts/
│   └── (read-only, historical exports)
│
├── images/
│   ├── designs/
│   │   ├── POD001.png               ← Canva export
│   │   ├── POD002.png
│   │   └── ...
│   └── products/
│       └── (preview images)
│
└── logs/
    ├── publishing.log                ← Success logs (read-only)
    └── publishing-errors.log         ← Error logs (read-only, for troubleshooting)
```

---

## CHECKLIST (Before Autonomous Operation on March 31)

- [ ] I know where the `content/approved/` folder is
- [ ] I can open a CSV in Excel/Sheets
- [ ] I understand the status column (draft → approved → published)
- [ ] I've tested approving 1 product (did it publish after 9 AM?)
- [ ] I've read the error logs (at least once, to know what they look like)
- [ ] I know to contact CTMO if something breaks

---

## TROUBLESHOOTING

### Issue: CSV won't open in Excel

**Solution:** Right-click the file → Open With → Choose "Microsoft Excel" or "Google Sheets"

### Issue: Excel says "file is locked"

**Solution:** Close the file and wait 5 seconds. n8n might be updating it. Then try again.

### Issue: I changed "status" to "approved" but nothing published

**Solution:**
1. Check the time — n8n publishes at 9 AM, 12 PM, 3 PM, 6 PM, 9 PM (hourly during business hours)
2. Wait for the next hour and check again
3. If still nothing, email CTMO (include product_id from the CSV)

### Issue: I see error messages in the CSV file

**Solution:** Check `/content/logs/publishing-errors.log` for details. Most common fixes:
- Missing image: Add the image file to `/content/images/designs/`
- Invalid price: Change "19.99" (not "$19.99" or "19,99")
- Empty required field: Fill in the title, niche, or description

### Issue: Product published to wrong platform

**Solution:** Open the CSV, find the product row, check the "platform" column. Make sure it says the right platform (Gumroad, Etsy, WordPress, etc.). If wrong, correct it and re-save. Contact CTMO if product is already live (you may need to unpublish manually).

---

## REVENUE TRACKING (View Your Earnings)

After content is published, sales come in automatically:

**Daily (automatic):**
- Gumroad, Etsy, Redbubble, WordPress send sales data to the system
- Recovery tracker updates hourly

**How to check:**
1. Email summary: Check your inbox for daily emails with sales count
2. Dashboard: Ask CTMO to show you the recovery tracker (viewable in browser)
3. CSV: Check the `units_sold` or `earnings_30d` columns (read-only, auto-updated)

---

## KEY RULES (Don't Do These)

❌ **Don't:**
- Delete rows from the CSV (archive them instead: change status to "archived")
- Rename the CSV files (n8n looks for specific names)
- Edit columns other than "status" (you can, but n8n might overwrite)
- Leave the CSV open while n8n is publishing (causes conflicts)
- Add new columns (n8n won't know what to do with them)

✓ **Do:**
- Save after every change
- Keep files in the exact folder specified
- Use standard Excel/Sheets (not LibreOffice or other tools, if possible)
- Contact CTMO if something breaks

---

## SUMMARY

**You do:** Open CSV → Change "draft" to "approved" → Save

**n8n does:** Everything else (publishing, updates, revenue tracking)

**You get:** Email summary every day with sales and status

---

**Questions?** Write to `/coo/inbox/` with your question, and CTMO will answer within 1 hour.

**Status:** READY FOR LAUNCH

**Last Updated:** 2026-03-29
