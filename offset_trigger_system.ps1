# Async Offset Trigger System
# Runs every minute, notifies each role when it's their standup window

# Define windows (minutes within the hour: 0-59)
$windows = @{
    "CEO" = @{ start = 0; end = 15; folder = "C:\Users\jsmcl\Documents\MakinMoves\CEO" }
    "COO" = @{ start = 15; end = 30; folder = "C:\Users\jsmcl\Documents\MakinMoves\COO" }
    "CTMO" = @{ start = 30; end = 45; folder = "C:\Users\jsmcl\Documents\MakinMoves\CTMO" }
    "CFO" = @{ start = 45; end = 60; folder = "C:\Users\jsmcl\Documents\MakinMoves\CFO" }
}

# Get current minute
$now = Get-Date
$currentMinute = $now.Minute
$hourLabel = $now.ToString("HH00")  # "0600" format

# Check which role's window it is
foreach ($role in $windows.GetEnumerator()) {
    $roleName = $role.Name
    $start = $role.Value.start
    $end = $role.Value.end
    $folder = $role.Value.folder
    
    # Check if we're in this role's window
    if ($currentMinute -ge $start -and $currentMinute -lt $end) {
        # Create notification file
        $inboxPath = Join-Path $folder "inbox"
        $notificationFile = Join-Path $inboxPath "WINDOW_ACTIVE_$hourLabel.md"
        
        # Only create if it doesn't exist yet (avoid duplicates)
        if (-not (Test-Path $notificationFile)) {
            $startTime = $now.AddMinutes(-($now.Minute - $start)).ToString("h:mm tt")
            $endTime = $now.AddMinutes(-($now.Minute - $start) + 15).ToString("h:mm tt")
            
            $content = @"
# 🔴 YOUR STANDUP WINDOW IS ACTIVE

**Your Role:** $roleName
**Window:** $startTime - $endTime (15 minutes)
**Time Now:** $($now.ToString('h:mm:ss tt'))

---

## What To Do

1. **Read previous updates** (2-3 min)
   - CEO: always reads nothing (baseline)
   - COO: Read CEO update from standup file
   - CTMO: Read CEO + COO updates
   - CFO: Read CEO + COO + CTMO updates

2. **Critique them** (1-2 min)
   - What did they do well?
   - What should they watch?
   - Any suggestions?

3. **Provide your update** (3-5 min)
   - File your standup section
   - Include: Current work, Agents, Blockers, Next deliverable
   - Add your critique of previous updates
   - Update personal identity focus

4. **Save** to standup file before your window ends

---

## File Location

Update: `board/standups/standup_2026-03-29_$hourLabel.md`

---

**You have 15 minutes. Go.**

---
"@
            Set-Content -Path $notificationFile -Value $content
            Write-Host "🔴 [$hourLabel] $roleName WINDOW ACTIVE - Notification sent" -ForegroundColor Red
        }
    }
}

# Also check for window transitions (role's window is ending in 2 minutes)
foreach ($role in $windows.GetEnumerator()) {
    $roleName = $role.Name
    $end = $role.Value.end
    $folder = $role.Value.folder
    
    if ($currentMinute -eq ($end - 2)) {
        # Role's window is ending in 2 minutes
        $inboxPath = Join-Path $folder "inbox"
        $warningFile = Join-Path $inboxPath "FINAL_CALL_$hourLabel.md"
        
        if (-not (Test-Path $warningFile)) {
            $content = "# ⚠️ FINAL CALL - Your window ends in 2 minutes`n`nFile your standup NOW if not already saved.`n`nTime: $($now.ToString('h:mm:ss tt'))"
            Set-Content -Path $warningFile -Value $content
            Write-Host "⚠️ [$hourLabel] $roleName WINDOW ENDING - Final call sent" -ForegroundColor Yellow
        }
    }
}

Write-Host "✅ Offset trigger check complete (minute: $currentMinute, hour: $hourLabel)"
