# MakinMoves Communication Monitor
# Runs every 5 minutes via Task Scheduler
# Checks both directions: inbox (from C: instance) and outbox (from D: coordinator)

$ProjectRoot = "C:\Users\jsmcl\OneDrive\Documents\Claude\Projects\MakinMoves"
$InboxDir = Join-Path $ProjectRoot "inbox"
$OutboxDir = Join-Path $ProjectRoot "outbox"
$LogDir = Join-Path $ProjectRoot "logs"
$StateFile = Join-Path $LogDir ".monitor_state.json"

# Initialize state file if it doesn't exist
if (-not (Test-Path $StateFile)) {
    @{ LastInboxCheck = (Get-Date).ToString("o"); LastOutboxCheck = (Get-Date).ToString("o") } | ConvertTo-Json | Set-Content $StateFile
}

$State = Get-Content $StateFile | ConvertFrom-Json
$LastInboxCheck = [DateTime]::Parse($State.LastInboxCheck)
$LastOutboxCheck = [DateTime]::Parse($State.LastOutboxCheck)

# Check for new UNPROCESSED inbox messages (C: instance asking questions -> needs D: coordinator attention)
$NewInbox = Get-ChildItem -Path $InboxDir -Filter "*.md" -ErrorAction SilentlyContinue | Where-Object {
    $_.LastWriteTime -gt $LastInboxCheck -and
    (Get-Content $_.FullName -First 1 -ErrorAction SilentlyContinue) -ne "[PROCESSED]"
}

# Check for new UNPROCESSED outbox messages (D: coordinator sent answers -> C: instance should pick up)
$NewOutbox = Get-ChildItem -Path $OutboxDir -Filter "*.md" -ErrorAction SilentlyContinue | Where-Object {
    $_.LastWriteTime -gt $LastOutboxCheck -and
    (Get-Content $_.FullName -First 1 -ErrorAction SilentlyContinue) -ne "[PROCESSED]"
}

# Notify if there are new inbox messages (someone needs to relay to D: drive)
if ($NewInbox) {
    $Count = ($NewInbox | Measure-Object).Count
    $Names = ($NewInbox | ForEach-Object { $_.Name }) -join ", "

    # Windows toast notification
    [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
    $Balloon = New-Object System.Windows.Forms.NotifyIcon
    $Balloon.Icon = [System.Drawing.SystemIcons]::Information
    $Balloon.BalloonTipTitle = "MakinMoves - New Questions"
    $Balloon.BalloonTipText = "$Count new message(s) in inbox: $Names`nOpen D: drive Claude to relay answers."
    $Balloon.Visible = $true
    $Balloon.ShowBalloonTip(10000)
    Start-Sleep -Seconds 3
    $Balloon.Dispose()

    # Also log it
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    Add-Content -Path (Join-Path $LogDir "monitor.log") -Value "[$Timestamp] INBOX: $Count new question(s) - $Names"
}

# Notify if there are new outbox messages waiting for C: instance to pick up
if ($NewOutbox) {
    $Count = ($NewOutbox | Measure-Object).Count
    $Names = ($NewOutbox | ForEach-Object { $_.Name }) -join ", "

    [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
    $Balloon = New-Object System.Windows.Forms.NotifyIcon
    $Balloon.Icon = [System.Drawing.SystemIcons]::Information
    $Balloon.BalloonTipTitle = "MakinMoves - Answers Ready"
    $Balloon.BalloonTipText = "$Count answer(s) in outbox: $Names`nStart C: drive Claude to pick them up."
    $Balloon.Visible = $true
    $Balloon.ShowBalloonTip(10000)
    Start-Sleep -Seconds 3
    $Balloon.Dispose()

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    Add-Content -Path (Join-Path $LogDir "monitor.log") -Value "[$Timestamp] OUTBOX: $Count answer(s) waiting - $Names"
}

# Update state
@{
    LastInboxCheck = (Get-Date).ToString("o")
    LastOutboxCheck = (Get-Date).ToString("o")
} | ConvertTo-Json | Set-Content $StateFile
