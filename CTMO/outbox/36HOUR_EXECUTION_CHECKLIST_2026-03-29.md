# 36-Hour Execution Checklist
## Trinity Open-Source Stack Launch (Days 1–2)

**Sprint Timeline:** 2026-03-29 15:30 → 2026-03-30 23:59
**Status:** CRITICAL SETUP WINDOW
**Owner:** CTMO (primary), COO, CFO, CEO (oversight)

---

## DAY 1 (2026-03-29): Setup & Foundation

### 15:30–16:00: Plan Review & Blockers (30 min)

- [ ] CTMO reads all three spec documents (TRINITY_OPENSOURCE_STACK, COMPONENT_SPECIFICATION, BOARD_SUMMARY)
- [ ] CTMO identifies any immediate blockers (API keys, permissions, etc.)
- [ ] CEO confirms approval of Phase 1 + Phase 2 strategy
- [ ] All roles confirm readiness for Day 1–2 sprint

**Sign-off:** CTMO ready to proceed → 16:00

---

### 16:00–17:00: Docker Validation (1 hour)

**Task:** Ensure current docker-compose.yml runs without errors on user's machine

- [ ] Copy docker-compose.yml to working directory
- [ ] Create `.env` file (copy from .env.example or template)
- [ ] `docker compose up -d` (start all services)
- [ ] `docker compose ps` (verify all containers running)
- [ ] `docker compose logs postgres | head -20` (check PostgreSQL healthy)
- [ ] `docker compose logs n8n | tail -20` (check n8n started)
- [ ] Access http://localhost:5678 (n8n web UI loads)
- [ ] Access http://localhost:8080 (WordPress loads)
- [ ] `docker compose down` (stop for next phase)

**Success criteria:** All services start, no fatal errors in logs

**If blocked:** Troubleshoot:
```bash
# Check disk space
df -h

# Check Docker daemon
docker version

# Check network
docker network ls

# Rebuild if needed
docker compose build --no-cache
```

**Sign-off:** Docker running → 17:00

---

### 17:00–18:00: PostgreSQL Schema Deployment (1 hour)

**Task:** Deploy database schema from `docker/init-db.sql`

- [ ] Restart PostgreSQL: `docker compose up -d postgres`
- [ ] Wait for healthy: `docker compose logs postgres | grep "database system is ready"`
- [ ] Apply schema: `docker exec mm-postgres psql -U makinmoves -d makinmoves -f /docker-entrypoint-initdb.d/init.sql`
- [ ] Verify tables created:
```bash
docker exec mm-postgres psql -U makinmoves -d makinmoves -c "\dt"
```
- [ ] Expected tables: digital_products, affiliate_content, revenue_summary, content_queue, error_logs, etc.

**Success criteria:** 10+ tables created, no errors

**If blocked:** Check schema file syntax:
```bash
cat docker/init-db.sql | head -50
```

**Sign-off:** PostgreSQL schema ready → 18:00

---

### 18:00–19:00: n8n Free Tier Setup (1 hour)

**Task:** Connect n8n to PostgreSQL, verify connectivity

- [ ] Start n8n container: `docker compose up -d n8n`
- [ ] Wait for healthy: `docker compose logs n8n | grep "Server started successfully"`
- [ ] Access http://localhost:5678
- [ ] Login with N8N_USER + N8N_PASSWORD (from .env)
- [ ] Create new workflow (test)
- [ ] Add PostgreSQL node:
  - [ ] Connection: Create new
  - [ ] Host: `postgres` (internal Docker network)
  - [ ] Port: 5432
  - [ ] Username: `makinmoves`
  - [ ] Password: (from .env)
  - [ ] Database: `makinmoves`
  - [ ] Click "Test Connection" → should succeed
- [ ] If using cloud free tier (instead of self-hosted):
  - [ ] Sign up: https://app.n8n.cloud
  - [ ] Create new workflow
  - [ ] Test execution (should use 1 execution credit)
  - [ ] Save API key for later

**Success criteria:** PostgreSQL connection works, can execute test query

**If blocked:**
```bash
# Check n8n logs
docker compose logs n8n | grep -i "error\|connection"

# Check PostgreSQL connection
docker exec mm-postgres psql -U makinmoves -d makinmoves -c "SELECT NOW();"
```

**Sign-off:** n8n connected to PostgreSQL → 19:00

---

### 19:00–20:00: Backup Automation Setup (1 hour)

**Task:** Deploy automated PostgreSQL backup via GitHub (free tier)

- [ ] Create GitHub personal token (if not exists):
  - [ ] https://github.com/settings/tokens → Personal access tokens
  - [ ] Permissions: `public_repo`, `repo`
  - [ ] Save token to `.env`: `GITHUB_TOKEN=ghp_xxxxx`

- [ ] Create repository (if not exists):
  - [ ] `makinmoves-backups` (private, recommended)
  - [ ] Clone to local: `gh repo clone user/makinmoves-backups`

- [ ] Create backup script (`scripts/backup.sh`):
```bash
#!/bin/bash
BACKUP_DATE=$(date +%Y-%m-%d)
pg_dump -U makinmoves -d makinmoves | gzip > /tmp/backup_$BACKUP_DATE.sql.gz

# Upload to GitHub
gh release create "backup-$BACKUP_DATE" \
  /tmp/backup_$BACKUP_DATE.sql.gz \
  --repo user/makinmoves-backups \
  2>/dev/null || echo "Release exists"
```

- [ ] Test manual backup:
```bash
chmod +x scripts/backup.sh
./scripts/backup.sh
```

- [ ] Verify backup uploaded: `gh release list -R user/makinmoves-backups`

- [ ] Set up cron job (optional for Day 1, critical for Day 2):
```bash
# Add to crontab
(crontab -l; echo "0 2 * * * /path/to/backup.sh") | crontab -
```

**Success criteria:** Backup file created and uploaded to GitHub

**If blocked:** Test GitHub CLI:
```bash
gh auth status
gh repo list
```

**Sign-off:** Backup automation ready → 20:00

---

### 20:00–21:00: WordPress + Plugins Installation (1 hour)

**Task:** Deploy WordPress with required plugins

- [ ] Start WordPress: `docker compose up -d wordpress`
- [ ] Wait for startup: `docker compose logs wordpress | grep "WordPress is ready"`
- [ ] Access http://localhost:8080
- [ ] Complete WordPress setup:
  - [ ] Site title: "Trinity"
  - [ ] Username: `admin`
  - [ ] Password: (strong, save to .env)
  - [ ] Email: `admin@trinity.local`

- [ ] Install required plugins:
```bash
# Option 1: Via WordPress admin UI (Settings → Plugins → Add New)
# Option 2: Via WP CLI (faster)
docker exec mm-wordpress wp plugin install yoast-seo --activate
docker exec mm-wordpress wp plugin install thirstyaffiliates --activate
docker exec mm-wordpress wp plugin install mailchimp-for-wordpress --activate
docker exec mm-wordpress wp plugin install wp-mail-smtp --activate
```

- [ ] Verify plugins installed: http://localhost:8080/wp-admin → Plugins

- [ ] Basic WordPress configuration:
  - [ ] Permalink structure: "Post name" (Settings → Permalinks)
  - [ ] Timezone: UTC (Settings → General)
  - [ ] Site URL: `http://localhost:8080` (Settings → General)

**Success criteria:** WordPress admin accessible, 4+ plugins installed and activated

**If blocked:** Check WordPress logs:
```bash
docker compose logs wordpress | tail -50
```

**Sign-off:** WordPress ready with plugins → 21:00

---

### 21:00–22:00: Mailchimp + Stripe Integration (1 hour)

**Task:** Connect email/payment processors to WordPress

#### Mailchimp Setup:
- [ ] Create free Mailchimp account: https://mailchimp.com
- [ ] Create audience "Trinity"
- [ ] Generate API key (Admin → Extras → API keys)
- [ ] Store in `.env`: `MAILCHIMP_API_KEY=xxxxx` + `MAILCHIMP_SERVER=us15` (or your region)
- [ ] In WordPress (Plugins → Mailchimp for WP → Settings):
  - [ ] API Key: [paste]
  - [ ] Select audience: Trinity
  - [ ] Form style: Embedded

#### Stripe Setup:
- [ ] Create Stripe test account: https://stripe.com
- [ ] Get test API keys (Developers → API keys → Restricted keys)
- [ ] Store in `.env`: `STRIPE_PUBLIC_KEY=pk_test_xxxxx` + `STRIPE_SECRET_KEY=sk_test_xxxxx`
- [ ] Test webhook:
```bash
curl https://api.stripe.com/v1/test_helpers/test_clocks \
  -u sk_test_xxxxx: \
  -d "frozen_time=1234567890"
```

**Success criteria:** API keys saved, test connections successful

**If blocked:** Check API key format:
```bash
# Verify format
echo $STRIPE_SECRET_KEY  # Should start with sk_test_
echo $MAILCHIMP_API_KEY  # Should be long hex string
```

**Sign-off:** Payment + email processors connected → 22:00

---

### 22:00–23:00: Initial Testing (1 hour)

**Task:** Verify all Day 1 components work together

- [ ] Test PostgreSQL query:
```bash
docker exec mm-postgres psql -U makinmoves -d makinmoves \
  -c "SELECT COUNT(*) FROM digital_products;"
```

- [ ] Test n8n PostgreSQL node (manual execution)
- [ ] Test backup script manually
- [ ] Test WordPress admin login
- [ ] Verify plugins loaded: http://localhost:8080/wp-admin/plugins.php
- [ ] Send test email via Mailchimp (from WordPress)

**Success criteria:** No errors, all components communicate

**If blocked:** Review logs from each container:
```bash
docker compose logs postgres
docker compose logs n8n
docker compose logs wordpress
```

**Sign-off:** All Day 1 components verified → 23:00

---

### 23:00–23:59: Summary & Handoff (59 min)

**Task:** Document Day 1 progress and prepare Day 2

- [ ] CTMO writes Day 1 completion report:
  - [ ] What worked
  - [ ] What didn't (and mitigations)
  - [ ] What's ready for Day 2
  - [ ] Any new blockers

- [ ] Commit to GitHub (if using):
```bash
git add -A
git commit -m "CTMO: Day 1 setup complete - Docker, PostgreSQL, n8n, WordPress, backups"
git push
```

- [ ] Prepare Day 2 work:
  - [ ] n8n workflow templates ready
  - [ ] PostgreSQL queries ready
  - [ ] Content templates ready

**Sign-off:** Day 1 complete, Day 2 prep ready → 23:59

---

## DAY 2 (2026-03-30): Workflows & Integration

### 06:00–10:00: n8n Core Workflows (4 hours)

**Task:** Build 3 core n8n workflows (revenue capture, publishing, email alerts)

#### Workflow 1: Hourly Revenue Capture (2 hours)
- [ ] Create new workflow: "Revenue Capture"
- [ ] Add Cron trigger: "0 * * * *" (hourly)
- [ ] Add Gumroad HTTP node (GET /sales):
  - [ ] URL: https://api.gumroad.com/v2/sales
  - [ ] Header: Authorization Bearer {{GUMROAD_TOKEN}}
  - [ ] Query params: access_token, after={{last_check}}
- [ ] Add PostgreSQL node: INSERT into revenue_summary
- [ ] Add error handler: Log to error_logs
- [ ] Save and test: "Execute workflow"

**Success criteria:** One execution = one revenue entry in PostgreSQL

#### Workflow 2: Daily Publishing (1 hour)
- [ ] Create new workflow: "Publish Content"
- [ ] Add Cron trigger: "0 9 * * *" (9am daily)
- [ ] Add PostgreSQL node: SELECT * FROM content_queue WHERE status='approved'
- [ ] Add For Each loop (process each item):
  - [ ] Switch on content_type
  - [ ] If digital_product: Gumroad API POST
  - [ ] If article: WordPress REST API POST
- [ ] Update content_queue: status='published'
- [ ] Save and test: "Execute workflow"

**Success criteria:** Approved content publishes to platforms

#### Workflow 3: Email Alerts (1 hour)
- [ ] Create new workflow: "Error Alerts"
- [ ] Add PostgreSQL trigger: On INSERT to error_logs with severity='critical'
- [ ] Add Email node: Send to CFO
  - [ ] To: cfo@trinity.local (or file notification)
  - [ ] Subject: "[CRITICAL] {{workflow_name}} failed"
  - [ ] Body: Error details
- [ ] Save and test: Manually insert error to test

**Success criteria:** Critical errors trigger email alerts

**Sign-off:** 3 workflows deployed and tested → 10:00

---

### 10:00–12:00: Integration Testing (2 hours)

**Task:** Verify data flow: n8n → PostgreSQL → CFO queries

- [ ] Test revenue capture:
  - [ ] Manually execute revenue capture workflow
  - [ ] Verify entry in revenue_summary table
  - [ ] CFO runs query: `SELECT * FROM revenue_summary ORDER BY captured_at DESC LIMIT 1`
  - [ ] Confirm data matches

- [ ] Test publishing pipeline:
  - [ ] Insert test content into content_queue
  - [ ] Update status to 'approved'
  - [ ] Execute publishing workflow
  - [ ] Verify publishing_log entry created

- [ ] Test error handling:
  - [ ] Manually insert error to error_logs
  - [ ] Verify error alert sent

- [ ] CFO builds daily report query:
```sql
SELECT
  DATE_TRUNC('day', captured_at) as date,
  stream,
  SUM(total_revenue) as daily_total
FROM revenue_summary
GROUP BY date, stream
ORDER BY date DESC;
```

**Success criteria:** Data flows cleanly from platforms → n8n → PostgreSQL → CFO

**If blocked:** Check n8n logs for API errors:
```bash
docker compose logs n8n | grep -i error
```

**Sign-off:** Full integration verified → 12:00

---

### 12:00–14:00: Workflow Testing & Refinement (2 hours)

**Task:** Stress test workflows and add error handling

- [ ] Test revenue capture with multiple platforms (Gumroad, Etsy, Medium)
  - [ ] Each should parse correctly
  - [ ] Duplicates should be prevented (ON CONFLICT clause)

- [ ] Test publishing with different content types
  - [ ] Digital product → Gumroad
  - [ ] Article → WordPress
  - [ ] Design → Check if API available (fallback to manual)

- [ ] Add retry logic to failed workflows
- [ ] Test error notifications work end-to-end
- [ ] Document any manual steps required

**Success criteria:** Workflows handle edge cases (API errors, timeouts, duplicates)

**Sign-off:** Workflows robust and tested → 14:00

---

### 14:00–18:00: CFO Financial Reporting Setup (4 hours)

**Task:** Build financial tracking system + automated reports

- [ ] CFO creates PostgreSQL functions:
```sql
-- Get today's revenue
CREATE OR REPLACE FUNCTION get_todays_revenue()
RETURNS TABLE(...) AS $$...$$;

-- Get recovery progress
CREATE OR REPLACE FUNCTION get_recovery_progress()
RETURNS TABLE(...) AS $$...$$;
```

- [ ] CFO builds report templates (SQL + CSV export):
  - [ ] Daily revenue snapshot
  - [ ] Weekly cumulative
  - [ ] Recovery tracker (% toward $10k goal)
  - [ ] Error statistics (last 7 days)

- [ ] CFO sets up automated report generation:
  - [ ] PostgreSQL cron (if available) or n8n daily job
  - [ ] Generate CSV each morning
  - [ ] Export to GitHub or email

- [ ] CFO verifies all queries work:
```bash
psql -U makinmoves -d makinmoves -c "SELECT * FROM revenue_daily LIMIT 5;"
```

**Success criteria:** CFO can run 5+ queries without manual SQL editing

**Sign-off:** Financial tracking fully autonomous → 18:00

---

### 18:00–22:00: End-to-End Testing (4 hours)

**Task:** Complete launch readiness test

#### Simulate full revenue flow:
- [ ] Manually add test sale to revenue_summary
- [ ] Check revenue_daily view updates
- [ ] Check recovery_progress view shows progress
- [ ] Verify all CFO queries return data

#### Simulate content publishing:
- [ ] Create test content in content_queue
- [ ] Mark as approved
- [ ] Run publishing workflow
- [ ] Verify publishing_log shows success
- [ ] Verify content_queue status updated

#### Error scenario testing:
- [ ] Deliberately break an API connection
- [ ] Verify error logged and alert sent
- [ ] Fix error and verify recovery

#### Backup testing:
- [ ] Run backup script manually
- [ ] Verify backup uploaded to GitHub
- [ ] Test restore:
  - [ ] Create fresh PostgreSQL container
  - [ ] Restore from backup
  - [ ] Verify data integrity

#### Documentation:
- [ ] CTMO documents all workflows
- [ ] CTMO documents all n8n nodes + configuration
- [ ] CTMO documents all PostgreSQL queries
- [ ] CTMO documents troubleshooting guide

**Success criteria:** Complete launch readiness without errors

**If any failures:** Debug and fix before 22:00

**Sign-off:** Full system tested and ready → 22:00

---

### 22:00–23:59: Final Verification & Sign-Off (1.5 hours)

**Task:** CEO confirms readiness for March 31 user hands-off

- [ ] CTMO final checklist:
  - [ ] All Docker services running
  - [ ] All workflows deployed and tested
  - [ ] Backup automation verified
  - [ ] Documentation complete
  - [ ] No known blockers

- [ ] COO final checklist:
  - [ ] 10+ digital products ready for publishing
  - [ ] 10+ affiliate articles drafted and queued
  - [ ] All accounts created (Gumroad, WordPress, Medium)
  - [ ] Manual publishing pipeline tested

- [ ] CFO final checklist:
  - [ ] All financial queries working
  - [ ] Revenue tracking system ready
  - [ ] Error alerting configured
  - [ ] Recovery progress tracking ready

- [ ] CEO final decision:
  - [ ] All systems green?
  - [ ] All roles ready for autonomy?
  - [ ] March 31 launch approved?

**Sign-off:** CEO approval for March 31 → 23:59

---

## Go/No-Go Criteria

### Green Light (Proceed to March 31 Launch)
- ✓ All 3 n8n workflows deployed + tested
- ✓ PostgreSQL backup automation verified
- ✓ CFO financial queries working
- ✓ No critical blockers
- ✓ CEO approval obtained

### Yellow Light (Acceptable Risk)
- ~ One non-critical workflow not fully tested (can finish Day 3)
- ~ One backup restoration not verified (can verify on Day 3)
- ~ One CFO query needs refinement (can iterate autonomously)

### Red Light (STOP, Do Not Launch)
- ✗ n8n cannot connect to PostgreSQL
- ✗ Backup automation consistently failing
- ✗ Any platform API keys invalid
- ✗ Critical security vulnerability found
- ✗ CEO cannot approve autonomy readiness

---

## Success Metrics (Post-Launch)

### Week 1 (March 31 - April 6)
- [ ] First revenue captured (within 24h)
- [ ] First content published autonomously (within 48h)
- [ ] No critical errors in error_logs (< 5 warnings)
- [ ] Backup verification passed (Day 2 restore test)

### Week 2 (April 7 - 13)
- [ ] Day 7 revenue target: $70+ (per board target)
- [ ] All 3 workflows running daily
- [ ] CFO reports working (daily snapshot)

### Week 3 (April 14 - 20)
- [ ] Day 21 break-even: $350+ revenue
- [ ] All platforms integrating successfully
- [ ] Decision: Upgrade to Phase 2 Standard if revenue ≥ $150/mo

---

## Emergency Contacts & Escalations

### If blocked during Day 1:
1. Document blocker (what, why, impact)
2. Post to board communication
3. Escalate to CEO for decision
4. Implement contingency (fallback to manual if needed)

### If workflow fails during Day 2:
1. Check n8n error logs
2. Verify API connectivity
3. Simplify workflow (remove features if needed)
4. Test with mock data
5. Escalate if unresolved

### If backup fails:
1. Test PostgreSQL export manually
2. Check GitHub CLI authentication
3. Fallback to manual backup to USB (for user hand-off)
4. Document issue for Phase 2 recovery

---

## Success Handoff (March 31)

**For CEO:**
"All systems ready. No manual intervention required post-March 31. Workflows run autonomously. CFO queries provide daily revenue tracking. Escalation paths documented."

**For COO (Future Reference):**
"Publishing workflow is automatic. Approved content publishes daily at 9am. New content should be added to content_queue table with status='pending' for approval."

**For CFO (Future Reference):**
"Revenue summary updates hourly. Run get_recovery_progress() for current recovery status. Check error_logs daily (table auto-queries critical errors to alert email)."

**For CTMO (Future Maintenance):**
"All infrastructure is self-hosted except backups (GitHub). Monitor: 1) n8n execution logs, 2) PostgreSQL disk usage, 3) workflow success rate. Upgrade to Phase 2 (Railway) if revenue ≥ $150/month by Day 21."

---

## FINAL STATUS

**Execution Window:** 36 hours (Days 1–2)
**Critical Path:** Docker → PostgreSQL → n8n → Testing
**Confidence Level:** 90%
**Risk Level:** LOW (proven technologies, clear contingencies)

**READY TO EXECUTE**

---

**Checklist Document:** Trinity 36-Hour Execution
**Version:** 1.0 (Final)
**Date:** 2026-03-29 17:30
**Owner:** CTMO
**Status:** READY FOR USE
**Next:** Board approval → Day 1 execution begins 15:30
