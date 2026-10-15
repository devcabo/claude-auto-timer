<#
.SYNOPSIS
    Automates sending a prompt to Claude.ai to initiate the 5-hour rolling limit window.

.DESCRIPTION
    Claude Pro usage limits reset 5 hours after your first message in a cycle.
    This script launches Claude.ai in your default browser, waits for the page to load,
    focuses the window, and sends a prompt to trigger the timer.
    Works natively on Windows without requiring browser extensions or admin privileges.

.PARAMETER DelaySeconds
    Seconds to wait for the browser and session to load before sending keys. Default is 8.

.PARAMETER PromptText
    Text message sent to Claude. Default is "start timer".

.PARAMETER Url
    Target Claude chat URL. Default is "https://claude.ai/new".

.EXAMPLE
    powershell.exe -ExecutionPolicy Bypass -File .\start_claude_timer.ps1

.EXAMPLE
    powershell.exe -ExecutionPolicy Bypass -File .\start_claude_timer.ps1 -DelaySeconds 10 -PromptText "ping"
#>

[CmdletBinding()]
param(
    [int]$DelaySeconds = 8,
    [string]$PromptText = "start timer",
    [string]$Url = "https://claude.ai/new"
)

Write-Host "[*] Launching $Url in default browser..." -ForegroundColor Cyan
Start-Process $Url

Write-Host "[*] Waiting $DelaySeconds seconds for page to load..." -ForegroundColor Cyan
Start-Sleep -Seconds $DelaySeconds

Write-Host "[*] Bringing browser window into focus..." -ForegroundColor Cyan
Add-Type -AssemblyName System.Windows.Forms
$wshell = New-Object -ComObject WScript.Shell
$activated = $wshell.AppActivate("Claude")

# Small grace period after activating window
Start-Sleep -Milliseconds 500

Write-Host "[*] Sending prompt: '$PromptText'..." -ForegroundColor Cyan
[System.Windows.Forms.SendKeys]::SendWait("$PromptText{ENTER}")

Write-Host "[+] Message sent successfully! 5-hour window triggered." -ForegroundColor Green
