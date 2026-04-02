# Operations Dashboard - Consolidated Standup Model

$standupDir = "C:\Users\jsmcl\Documents\MakinMoves\board\standups"

while ($true) {
    Clear-Host

    # Get latest standup file (consolidated, all 4 roles)
    $file = Get-ChildItem $standupDir -Filter "standup_*.md" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if (-not $file) {
        Write-Host "Looking for standups..." -ForegroundColor Yellow
        Write-Host "Checked: $standupDir" -ForegroundColor Gray
        Start-Sleep -Seconds 5
        continue
    }

    $content = Get-Content $file.FullName -Raw
    $time = Get-Date -Format "HH:mm:ss"

    Write-Host "========== EXSITU OPERATIONS DASHBOARD ==========" -ForegroundColor Cyan
    Write-Host "Time: $time | Latest: $($file.Name)" -ForegroundColor Gray
    Write-Host ""

    # Parse and display each role
    $roles = @("CEO", "CTMO", "CFO", "COO")

    foreach ($role in $roles) {
        # Extract role section
        if ($content -match "## $role.*?(?=## |\Z)") {
            $roleSection = $matches[0]

            Write-Host "[$role]" -ForegroundColor Yellow

            # Current Work
            if ($roleSection -match "CURRENT WORK:(.*?)(?=BLOCKERS|AGENTS|CRITIQUE|NEXT|`$)") {
                $work = $matches[1].Trim() -replace "^\s*-\s*", ""
                if ($work) {
                    Write-Host "  Work: $work" -ForegroundColor White
                }
            }

            # Blockers
            if ($roleSection -match "BLOCKERS:(.*?)(?=CRITIQUE|AGENTS|NEXT|PERSONAL|`$)") {
                $blockers = $matches[1].Trim()
                if ($blockers -and $blockers -notmatch "^\[") {
                    Write-Host "  [BLOCKER] $blockers" -ForegroundColor Red
                } else {
                    Write-Host "  [OK] No blockers" -ForegroundColor Green
                }
            }

            # Next Deliverable
            if ($roleSection -match "NEXT DELIVERABLE:(.*?)(?=CRITIQUE|PERSONAL|`$)") {
                $next = $matches[1].Trim() -replace "^\s*-\s*", ""
                if ($next) {
                    Write-Host "  Next: $next" -ForegroundColor Cyan
                }
            }

            Write-Host ""
        }
    }

    # System Resources
    $cpu = (Get-WmiObject win32_processor | Measure-Object -Property LoadPercentage -Average).Average
    $ram = Get-WmiObject win32_operatingsystem
    $ramPercent = [math]::Round(($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory) / $ram.TotalVisibleMemorySize * 100, 1)

    Write-Host "================================================" -ForegroundColor Gray
    Write-Host "SYSTEM: CPU ${cpu}% | RAM ${ramPercent}% | OK" -ForegroundColor Green
    Write-Host "Refreshing in 30 seconds..." -ForegroundColor Gray

    Start-Sleep -Seconds 30
}
