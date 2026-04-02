# System Resource Monitor for MakinMoves
# Run periodically to track CPU, RAM, GPU usage

$thresholds = @{
    cpu = 75
    ram = 80
    disk = 85
}

$logFile = "C:\Users\jsmcl\Documents\MakinMoves\logs\resource_usage.log"
$statusFile = "C:\Users\jsmcl\Documents\MakinMoves\SYSTEM_STATUS.md"

# Ensure log directory exists
$logDir = Split-Path $logFile
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Get system stats
$cpu = (Get-WmiObject win32_processor | Measure-Object -Property LoadPercentage -Average).Average
$ram = Get-WmiObject win32_operatingsystem
$ramPercent = [math]::Round(($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory) / $ram.TotalVisibleMemorySize * 100, 1)
$ramUsedGB = [math]::Round(($ram.TotalVisibleMemorySize - $ram.FreePhysicalMemory) / 1MB / 1024, 1)

$disk = Get-Volume -DriveLetter C
$diskPercent = [math]::Round(($disk.Size - $disk.SizeRemaining) / $disk.Size * 100, 1)

# Get process count
$procCount = (Get-Process).Count

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Create status line
$alerts = @()
if ($cpu -gt $thresholds.cpu) {
    $alerts += "⚠️ CPU HIGH: ${cpu}% (threshold: $($thresholds.cpu)%)"
}
if ($ramPercent -gt $thresholds.ram) {
    $alerts += "⚠️ RAM HIGH: ${ramPercent}% (${ramUsedGB}GB / 128GB used)"
}
if ($diskPercent -gt $thresholds.disk) {
    $alerts += "⚠️ DISK HIGH: ${diskPercent}% (threshold: $($thresholds.disk)%)"
}

# Write to log
$logEntry = "$timestamp | CPU: ${cpu}% | RAM: ${ramPercent}% | Disk: ${diskPercent}% | Processes: $procCount"
Add-Content -Path $logFile -Value $logEntry

# Update status file
$statusContent = @"
# System Resource Status

**Last Updated:** $timestamp

## Current Usage

- **CPU:** ${cpu}% (threshold: $($thresholds.cpu)%)
- **RAM:** ${ramPercent}% (${ramUsedGB}GB / 128GB)
- **Disk:** ${diskPercent}% (threshold: $($thresholds.disk)%)
- **Processes:** $procCount

"@

if ($alerts.Count -gt 0) {
    $statusContent += "## 🚨 ALERTS`n`n"
    foreach ($alert in $alerts) {
        $statusContent += "- $alert`n"
    }
} else {
    $statusContent += "## ✅ All Systems Normal`n"
}

Set-Content -Path $statusFile -Value $statusContent

# Output
if ($alerts.Count -gt 0) {
    $alerts | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
} else {
    Write-Host "✅ System normal - CPU: ${cpu}%, RAM: ${ramPercent}%, Disk: ${diskPercent}%" -ForegroundColor Green
}
