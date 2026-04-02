# Automated Standup Validator - Runs 5 min before deadline

$standupFile = "C:\Users\jsmcl\Documents\MakinMoves\board\standups\standup_2026-03-29_1705.md"
$statusFile = "C:\Users\jsmcl\Documents\MakinMoves\STANDUP_SUBMISSION_STATUS.md"
$roles = @("CEO", "COO/COWORK", "CTMO", "CFO")

# Read standup file
$content = Get-Content $standupFile -Raw

# Check each role
$status = @()
$missing = @()

foreach ($role in $roles) {
    $pattern = "## $role"
    if ($content -match $pattern) {
        # Check if role has actual content (not just empty dashes)
        $roleSection = $content -split "## $role" | Select -Last 1 | Select -ExpandProperty Substring 0 500
        if ($roleSection -match "\*\*CURRENT WORK:\*\*\s*-\s*$" -or $roleSection -match "\*\*BLOCKERS:\*\*\s*-\s*$") {
            $status += "❌ $role - EMPTY (not submitted)"
            $missing += $role
        } else {
            $status += "✅ $role - Submitted"
        }
    } else {
        $status += "❌ $role - NO SECTION"
        $missing += $role
    }
}

# Create status file
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$statusContent = @"
# Standup Submission Status — 5:30 PM Deadline

**Time:** $timestamp

## Submissions

$($status -join "`n")

## Summary

Submitted: $($roles.Count - $missing.Count)/$($roles.Count)
Missing: $(if ($missing.Count -gt 0) { $missing -join ", " } else { "None" })

---

## Action Required

$(if ($missing.Count -gt 0) {
    "**ESCALATION TRIGGERED**`n`n"
    foreach ($role in $missing) {
        "- $role: FILE STANDUP NOW - Deadline passed`n"
    }
    "`nAtlas escalating to COO for immediate dispatch."
} else {
    "**ALL ROLES SUBMITTED ON TIME**`n`nSystem synchronized. Ready for next cycle."
})

---
"@

Set-Content -Path $statusFile -Value $statusContent

# If missing, create escalation file
if ($missing.Count -gt 0) {
    $escalationFile = "C:\Users\jsmcl\Documents\MakinMoves\COO\inbox\ESCALATION_2026-03-29_STANDUP-FAILURE.md"
    $escalationContent = @"
# ESCALATION — Standup Submission Failure

**From:** Atlas (System Monitor)
**Time:** $timestamp
**Severity:** CRITICAL
**Status:** All instances on same machine. No excuse for missing standups.

---

## Who Didn't Report

$($missing -join "`n")

## Action Required

1. Reach Jason immediately (use dispatch/phone)
2. Message: "Standup deadline passed. Roles missing: $($missing -join ", "). System out of sync."
3. Get Jason's direction on escalation

---

**Next occurrence:** Automatic suspension of role's agents/processes.

---
"@
    Set-Content -Path $escalationFile -Value $escalationContent
    Write-Host "🚨 ESCALATION: Missing standup reports - $($missing -join ', ')" -ForegroundColor Red
}

Write-Host "✅ Validation complete: $($roles.Count - $missing.Count)/$($roles.Count) roles submitted"
