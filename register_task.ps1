<#
.SYNOPSIS
    Registers a Windows Scheduled Task to run start_claude_timer.ps1 every 5 hours.

.PARAMETER TaskName
    Name of the scheduled task. Default is "ClaudeAutoTimer".

.PARAMETER StartTime
    Time to run the first daily check (24-hour format). Default is "07:00".

.PARAMETER IntervalHours
    Interval between executions in hours. Default is 5.
#>

[CmdletBinding()]
param(
    [string]$TaskName = "ClaudeAutoTimer",
    [string]$StartTime = "07:00",
    [int]$IntervalHours = 5
)

$scriptPath = Join-Path $PSScriptRoot "start_claude_timer.ps1"

if (-not (Test-Path $scriptPath)) {
    Write-Error "Script not found at: $scriptPath"
    exit 1
}

try {
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
    $trigger = New-ScheduledTaskTrigger -Daily -At $StartTime
    $trigger.RepetitionInterval = (New-TimeSpan -Hours $IntervalHours)
    $trigger.RepetitionDuration = (New-TimeSpan -Days 3650)

    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Force | Out-Null
    Write-Host "[+] Scheduled task '$TaskName' successfully registered!" -ForegroundColor Green
    Write-Host "    - Runs daily starting at: $StartTime"
    Write-Host "    - Repeats every: $IntervalHours hours indefinitely"
    Write-Host "    - Script path: $scriptPath"
} catch {
    Write-Error "Failed to register task: $_"
    Write-Host "Tip: You can also set this up via Windows Task Scheduler GUI (taskschd.msc)." -ForegroundColor Yellow
}
