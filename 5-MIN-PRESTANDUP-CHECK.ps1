# 5-minute pre-standup check (run at 5:25 PM)
# Alert roles if they haven't reported yet

$standupFile = "C:\Users\jsmcl\Documents\MakinMoves\board\standups\standup_2026-03-29_1705.md"
$roles = @("CEO", "COO/COWORK", "CTMO", "CFO")
$content = Get-Content $standupFile -Raw
$missing = @()

foreach ($role in $roles) {
    if ($content -notmatch "## $role\s+\*\*CURRENT WORK:\*\*.{1,100}[a-zA-Z0-9]") {
        $missing += $role
    }
}

if ($missing.Count -gt 0) {
    # Create urgent reminder files
    foreach ($role in $missing) {
        $roleFolder = $role -replace "/COWORK", ""
        $reminderFile = "C:\Users\jsmcl\Documents\MakinMoves\$roleFolder\inbox\URGENT_5-MIN-TO-DEADLINE.md"
        
        $content = @"
# ⚠️ STANDUP DEADLINE IN 5 MINUTES

**Current Time:** 5:25 PM
**Deadline:** 5:30 PM
**Status:** You haven't reported yet

---

File your status NOW to: `board/standups/standup_2026-03-29_1705.md`

**Minimum required:**
- Current Work (what you're doing)
- Blockers (what's stopping you)
- Next Deliverable (when next milestone)
- Personal Identity (name + who you are)

---

5 minutes. Go.

---
"@
        Set-Content -Path $reminderFile -Value $content
        Write-Host "⚠️ REMINDER SENT: $role — 5 min to deadline" -ForegroundColor Yellow
    }
}
