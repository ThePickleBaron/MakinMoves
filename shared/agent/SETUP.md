# MakinMoves Orchestrator — Setup Guide

## What This Does

The orchestrator runs **every 4 hours** automatically (24/7) to:
1. Read your work queue (`CURRENT_WORKQUEUE.md`)
2. Post content to Twitter, log emails, track Gumroad sales
3. Update metrics and execution logs
4. Commit changes to git

**No manual prompts needed. It just works.**

---

## Setup (5 minutes)

### Step 1: Push to GitHub

```bash
cd "C:\Users\jsmcl\Documents\MakinMoves"
git remote add origin https://github.com/YOUR_USERNAME/MakinMoves.git
git branch -M main
git push -u origin main
```

(If already on GitHub, just ensure `.github/workflows/orchestrator.yml` is pushed)

### Step 2: Add Secrets to GitHub

Go to: **GitHub repo → Settings → Secrets and variables → Actions → New repository secret**

Add these 6 secrets (values from your local `.env`):
- `GUMROAD_ACCESS_TOKEN` = your Gumroad token
- `TWITTER_API_KEY` = your Twitter API key
- `TWITTER_API_SECRET` = your Twitter API secret
- `TWITTER_ACCESS_TOKEN` = your Twitter access token
- `TWITTER_ACCESS_TOKEN_SECRET` = your Twitter access token secret
- `TWITTER_BEARER_TOKEN` = your Twitter bearer token

### Step 3: Enable GitHub Actions

Go to **Actions** tab → Enable workflows

### Step 4: Test It

Click **"Run workflow"** on the orchestrator workflow to test immediately (don't wait 4 hours).

---

## How It Works

### Execution Flow

```
Orchestrator runs (every 4 hours)
    ↓
Read: shared/queue/CURRENT_WORKQUEUE.md
    ↓
Read: shared/content/CONTENT_QUEUE.md
    ↓
Find "READY TO POST" items
    ↓
Post to Twitter, queue emails, log Gumroad
    ↓
Update: shared/logs/BLOCK_EXECUTION_LOG.md
    ↓
Update: shared/metrics/DAILY_METRICS.md
    ↓
Commit to git
```

### Content Queue Format

Your `CONTENT_QUEUE.md` must look like this:

```markdown
## READY TO POST
- Twitter thread on housing market (shared/content/twitter_2026-04-04.md)
- Email sequence intro (shared/content/email_welcome_2026-04-04.md)
- Medium article on macro trends (shared/content/medium_macro_2026-04-04.md)

## IN PROGRESS
- Lead magnet (50% complete, due Friday)

## BLOCKED
- [topic] (reason: waiting for X)
```

**Key:** Each item points to a markdown file in `shared/content/`.

### Twitter Thread Format

Create `twitter_YYYY-MM-DD.md` like this:

```markdown
# Twitter Thread: Housing Market

This is tweet 1. Keep it under 280 chars. Add context and hooks.

---

This is tweet 2. Continue the narrative here. Build on tweet 1.

---

This is tweet 3. Conclusion or call-to-action.
```

The orchestrator will:
- Split by `---` or blank lines
- Post as a thread (each tweet replies to the previous one)
- Log tweet IDs and engagement

### Email Queue Format

Create `email_YYYY-MM-DD.md` like this:

```markdown
# Email: Welcome Sequence

## Email 1: "Why I Built This Framework"
Subject: Why macro thesis matters
Body: [email copy here]

## Email 2: "Three Layers of Conviction"
Subject: How pros think about portfolio bets
Body: [email copy here]
```

(Currently logged for manual send via Substack. Can integrate Beehiiv API later.)

---

## Daily Workflow

### Morning (you):
1. Drop new content files into `shared/content/`
2. Update `CONTENT_QUEUE.md` to mark as "READY TO POST"
3. That's it.

### Automatic (orchestrator):
- Picks up your files
- Posts to Twitter
- Updates metrics
- Logs everything
- Commits to git

### Evening (optional):
- Review metrics in `shared/metrics/DAILY_METRICS.md`
- Check Twitter engagement
- Decide what content to create next

---

## Testing

### Test Twitter Posting

```bash
cd "C:\Users\jsmcl\Documents\MakinMoves\shared\agent"
python -c "
from orchestrator import TwitterClient
client = TwitterClient()
tweet_id = client.post_tweet('Testing orchestrator. This is a test tweet.')
print(f'Test tweet posted: {tweet_id}')
"
```

### Test Gumroad Metrics

```bash
python -c "
from orchestrator import GumroadClient
client = GumroadClient()
sales = client.get_sales()
print(f'Sales: {sales}')
"
```

### Test Full Block (local)

```bash
cd "C:\Users\jsmcl\Documents\MakinMoves\shared\agent"
python orchestrator.py
```

This will execute a full block locally (posts real tweets, pulls real metrics).

---

## Monitoring

Check execution logs:
- `shared/logs/BLOCK_EXECUTION_LOG.md` — What ran and what completed
- `shared/metrics/DAILY_METRICS.md` — Engagement, sales, etc.
- GitHub Actions → "Orchestrator" workflow → Run history

---

## Troubleshooting

**Workflow not running?**
- Check: Settings → Actions → General → Workflow permissions = "Read & write"
- Manually trigger: Actions → Orchestrator → Run workflow

**Tweets not posting?**
- Check Twitter API credentials in GitHub Secrets
- Test locally with the Twitter test command above
- Check rate limits (Twitter has request limits)

**Gumroad not updating?**
- Verify token in GitHub Secrets
- Run Gumroad test command above

**Git push failing?**
- Check: Settings → Actions → Workflow permissions = "Read & write"
- Ensure main branch exists

---

## Scaling Beyond Twitter

Once Twitter is working, add more platforms:

### Medium (via API)
```python
def _post_medium(self, content: str, item_name: str):
    # Use Medium API
    pass
```

### Substack (via email capture)
```python
def _post_substack(self, content: str):
    # Use Substack API (once approved)
    pass
```

### Reddit (via PRAW)
```python
def _post_reddit(self, subreddit: str, content: str):
    # Use Reddit API
    pass
```

---

## Daily Revenue Target

With this running 24/7:
- **Week 1:** Content seeding + testing ($0-50)
- **Week 2-4:** Twitter audience building + affiliate clicks ($50-150/week)
- **Week 5-8:** Affiliate revenue + product sales ($150-400/week)
- **Month 2+:** $300-500/week passive (all running on automation)

---

## Next Actions

1. Push to GitHub
2. Add 6 secrets to GitHub Actions
3. Test workflow manually
4. Create `CONTENT_QUEUE.md` with ready-to-post items
5. Let it run

**That's it. You're live.**

---

**Questions?** Check git logs or Twitter API docs.
**Blocked?** Write a memo in `shared/memos/` and I'll handle it next session.
