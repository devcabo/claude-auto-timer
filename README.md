# Claude Auto Timer ⏳

> Lightweight, native Windows automation to automatically trigger Claude.ai's 5-hour rate limit reset window — without browser extensions, API costs, or administrator privileges.

[![Platform](https://img.shields.io/badge/Platform-Windows-blue.svg)](https://microsoft.com/windows)
[![Shell](https://img.shields.io/badge/Shell-PowerShell%205.1+-blue.svg)](https://github.com/PowerShell/PowerShell)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 💡 The Problem

On **Claude.ai (Pro / Team plans)**, usage limits reset on a **5-hour rolling window**.

Crucially:
- The 5-hour countdown **does not start automatically** at fixed times (like midnight or 8:00 AM).
- The countdown **only starts once you send your first message** of a new cycle.

### Why this matters:
* **Without automation:** If you sit down at 10:00 AM and send a prompt, your 5-hour window runs from `10:00 AM -> 3:00 PM`. If you hit your limit at 11:30 AM, you are blocked until 3:00 PM.
* **With Claude Auto Timer:** A lightweight ping is sent early (e.g., `7:00 AM`). Your 5-hour window runs from `7:00 AM -> 12:00 PM`. When you start heavy work at 10:00 AM, your full capacity resets at 12:00 PM instead of 3:00 PM!

---

## ✨ Features

- **🛡️ Enterprise & Admin Friendly:** No browser extensions needed (bypasses enterprise IT extension blocks such as Tampermonkey / Chrome Web Store restrictions).
- **🔒 No Bot Detection / Ban Risk:** Uses your regular default browser, existing session cookies, and legitimate user headers — no headless browser flags (Puppeteer/Playwright) that trigger Cloudflare captchas.
- **⚡ Zero Dependencies:** Built strictly using native Windows components (`PowerShell`, `WScript.Shell`, and `SendKeys`).
- **💰 100% Free:** Does not use the paid Anthropic API.
- **👤 No Admin Privileges Required:** Can be registered and run in standard user scope.

---

## 🚀 Quick Start

### 1. Clone or Download

```powershell
git clone https://github.com/devcabo/claude-auto-timer.git
cd claude-auto-timer
```

### 2. Test It

Make sure you are logged into [claude.ai](https://claude.ai) in your default browser, then run:

```powershell
powershell.exe -ExecutionPolicy Bypass -File .\start_claude_timer.ps1
```

The script will:
1. Open `https://claude.ai/new` in your default browser.
2. Wait 8 seconds for the page and session to load.
3. Bring the window to the foreground.
4. Type `"start timer"` and press `Enter`.

---

## ⏰ Automated Scheduling (Every 5 Hours)

You can schedule the script to run automatically using either the automated script or the Windows Task Scheduler GUI.

### Option A: One-Click Registration (Recommended)

Run the included registration script in PowerShell:

```powershell
.\register_task.ps1 -StartTime "07:00" -IntervalHours 5
```

To remove the scheduled task at any time:
```powershell
.\unregister_task.ps1
```

---

### Option B: Manual Setup via Windows Task Scheduler (GUI)

1. Press `Win + R`, type **`taskschd.msc`**, and hit **Enter**.
2. In the right-hand panel, click **Create Task...** (*not "Create Basic Task"*).
3. **General Tab:**
   - **Name:** `Claude Auto Timer`
   - Select: **"Run only when user is logged on"** *(required for desktop GUI automation / SendKeys)*.
4. **Triggers Tab:**
   - Click **New...**
   - **Begin the task:** `On a schedule`
   - **Settings:** `Daily`
   - **Start:** Set your preferred start time (e.g., `07:00:00`).
   - Under **Advanced settings**:
     - Check **Repeat task every:** `5 hours`
     - Set **for a duration of:** `Indefinitely`
     - Ensure **Enabled** is checked.
5. **Actions Tab:**
   - Click **New...**
   - **Action:** `Start a program`
   - **Program/script:** `powershell.exe`
   - **Add arguments:**
     ```text
     -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\Path\To\claude-auto-timer\start_claude_timer.ps1"
     ```
6. **Conditions Tab (For Laptops):**
   - Uncheck *"Start the task only if the computer is on AC power"* so it triggers on battery as well.
7. Click **OK** to save.

---

## ⚙️ Script Parameters

`start_claude_timer.ps1` accepts optional parameters:

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `-DelaySeconds` | `int` | `8` | Wait time for the browser and chat DOM to load before typing. |
| `-PromptText` | `string` | `"start timer"` | Text sent to Claude to trigger the message limit countdown. |
| `-Url` | `string` | `"https://claude.ai/new"` | Target URL for initiating a new chat. |

Example with custom parameters:
```powershell
powershell.exe -ExecutionPolicy Bypass -File .\start_claude_timer.ps1 -DelaySeconds 12 -PromptText "ping"
```

---

## ❓ FAQ & Troubleshooting

#### Why not use the Anthropic API?
The Anthropic developer API (`console.anthropic.com`) is completely decoupled from the Claude.ai Web Pro subscription ($20/month). Using the API costs tokens per request and does **not** trigger or reset your Claude Pro web usage limit.

#### The text didn't send on my machine. What should I check?
1. **Slow Internet / Page Load:** If Claude takes longer to load, increase the delay:
   ```powershell
   .\start_claude_timer.ps1 -DelaySeconds 12
   ```
2. **Screen Locked / Sleeping:** Windows GUI simulation (`SendKeys`) requires an active, unlocked user session. If your computer is asleep or locked, Windows suspends UI events until you log back in.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
