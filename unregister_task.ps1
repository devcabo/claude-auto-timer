<#
.SYNOPSIS
    Removes the Windows Scheduled Task for Claude Auto Timer.
#>

[CmdletBinding()]
param(
    [string]$TaskName = "ClaudeAutoTimer"
)

try {
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction Stop
    Write-Host "[+] Scheduled task '$TaskName' removed successfully." -ForegroundColor Green
} catch {
    Write-Warning "Could not find or remove scheduled task '$TaskName': $_"
}
