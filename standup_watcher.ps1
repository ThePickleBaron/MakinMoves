# File watcher for new directives/notices in role inboxes
# Alerts roles immediately when new messages arrive

$roles = @{
    "CEO" = "C:\Users\jsmcl\Documents\MakinMoves\CEO\inbox"
    "COO" = "C:\Users\jsmcl\Documents\MakinMoves\COO\inbox"
    "CTMO" = "C:\Users\jsmcl\Documents\MakinMoves\CTMO\inbox"
    "CFO" = "C:\Users\jsmcl\Documents\MakinMoves\CFO\inbox"
}

$notificationFile = "C:\Users\jsmcl\Documents\MakinMoves\logs\inbox_notifications.log"
$lastCheck = "C:\Users\jsmcl\Documents\MakinMoves\logs\.last_inbox_check"

foreach ($role in $roles.GetEnumerator()) {
    $inbox = $role.Value
    $lastModTime = "1970-01-01"
    
    if (Test-Path $lastCheck) {
        $lastModTime = Get-Content $lastCheck
    }
    
    $newFiles = Get-ChildItem $inbox -Filter "*.md" -ErrorAction SilentlyContinue | 
        Where-Object { $_.LastWriteTime -gt [DateTime]$lastModTime }
    
    if ($newFiles) {
        foreach ($file in $newFiles) {
            $msg = "$(Get-Date -Format 'HH:mm:ss') — NEW INBOX: $($role.Name) — $($file.Name)"
            Add-Content -Path $notificationFile -Value $msg
            Write-Host "📧 $($role.Name) has new message: $($file.Name)" -ForegroundColor Cyan
        }
    }
}

Set-Content $lastCheck (Get-Date).ToString()
