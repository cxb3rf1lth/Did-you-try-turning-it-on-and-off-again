# Usage Examples

This guide shows you exactly how to use the Windows Optimization Tool in various scenarios.

## 🚀 Getting Started (First Time)

### Automated Setup Method (Recommended)

**Step 1:** Open PowerShell as Administrator
- Press `Win + X`
- Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

**Step 2:** Navigate to the tool directory
```powershell
cd C:\path\to\Did-you-try-turning-it-on-and-off-again
```

**Step 3:** Run the automated setup
```powershell
.\Setup.ps1
```

**What happens next:**
1. ✅ Setup checks your system prerequisites
2. ✅ Configures PowerShell execution policy
3. ✅ Unblocks the script files
4. ✅ Asks if you want a desktop shortcut
5. ✅ Launches the optimization tool automatically
6. ✅ Shows the first-time user guide

**Total time:** ~1 minute

---

## 🎯 Using the Tool

### One-Click Launch (Anytime After Setup)

After running Setup.ps1 once, you can launch the tool anytime:

```powershell
.\Start-WindowsOptimizer.ps1
```

This automatically:
- Checks for Administrator privileges
- Elevates permissions if needed
- Launches the tool

### Using the Desktop Shortcut (If Created)

1. Right-click "Windows Optimizer" on your desktop
2. Select "Run as administrator"
3. Tool launches immediately

---

## 📋 Common Scenarios

### Scenario 1: Computer Running Slow

**Quick Fix (5 minutes):**
1. Launch the tool: `.\Start-WindowsOptimizer.ps1`
2. Press `4` - Optimize System Services
3. Press `Y` to confirm
4. Press `5` - Optimize Visual Effects
5. Restart your computer

**Comprehensive Fix (20 minutes):**
1. Launch the tool
2. Press `A` - Run All Optimizations
3. Press `Y` to confirm
4. Wait for completion
5. Restart your computer

### Scenario 2: Low Disk Space

**Free Up Space (10-15 minutes):**
1. Launch the tool
2. Press `2` - Clear Temporary Files (wait ~2 minutes)
3. Press `3` - Run Disk Cleanup (wait ~10 minutes)
4. Press `8` - Clear Windows Update Cache (wait ~3 minutes)
5. Check freed space with option `1`

**Expected results:** 2-20 GB freed depending on system usage

### Scenario 3: Network Problems

**Fix Network Issues (2 minutes):**
1. Launch the tool
2. Press `6` - Network Optimization
3. Wait for completion
4. Restart your computer
5. Test your network connection

**What it does:**
- Flushes DNS cache
- Resets Winsock catalog
- Resets TCP/IP stack

### Scenario 4: Monthly Maintenance

**Routine Maintenance (20 minutes):**
1. Close all programs
2. Save your work
3. Launch the tool
4. Press `A` - Run All Optimizations
5. Press `Y` to confirm
6. Let it run (grab a coffee ☕)
7. Restart when complete

**Best practices:**
- Run on the first day of each month
- Close all applications first
- Restart after completion

### Scenario 5: Before Important Work

**Quick Performance Boost (5 minutes):**
1. Launch the tool
2. Press `2` - Clear Temporary Files
3. Press `5` - Optimize Visual Effects
4. Continue working (no restart needed)

---

## 🎓 Understanding the Menu Options

### [1] System Information
**When to use:**
- Check system specs before optimization
- Verify disk space available
- Monitor improvements after optimization

**Time:** Instant  
**Safety:** Read-only, completely safe

### [2] Clear Temporary Files
**When to use:**
- Low disk space
- Before Disk Cleanup
- After software installations/uninstalls
- Weekly maintenance

**Time:** 1-5 minutes  
**Expected result:** 500MB - 5GB freed

### [3] Run Disk Cleanup
**When to use:**
- Need more space than option [2] provides
- Haven't run in months
- After Windows updates
- Monthly maintenance

**Time:** 5-15 minutes  
**Expected result:** 1-10GB freed

### [4] Optimize System Services
**When to use:**
- Computer runs slowly at startup
- Too many background services
- Privacy concerns (disables telemetry)
- One-time setup for new computers

**Time:** 1 minute  
**Requires:** Confirmation  
**Reversible:** Yes (through Services)

### [5] Optimize Visual Effects
**When to use:**
- Computer feels sluggish
- Prioritize performance over appearance
- Low-end hardware
- Before gaming or heavy applications

**Time:** Instant  
**Effect:** Immediate but subtle  
**Reversible:** Yes (through System Properties)

### [6] Network Optimization
**When to use:**
- Websites loading slowly
- "DNS not found" errors
- Network connectivity issues
- After router/modem changes

**Time:** 1 minute  
**Note:** Restart required for full effect

### [7] Optimize Drives
**When to use:**
- Monthly maintenance for HDDs
- Weekly for SSDs (TRIM)
- Fragmented files (file access is slow)
- After large file operations

**Time:** 5-30 minutes  
**Note:** Automatically detects SSD vs HDD

### [8] Clear Windows Update Cache
**When to use:**
- Windows updates fail to install
- Update errors
- System storage full
- Updates stuck downloading

**Time:** 2-5 minutes  
**Expected result:** 1-5GB freed  
**Requires:** Confirmation

### [9] System Health Check (SFC)
**When to use:**
- System errors or crashes
- Corrupted system files
- After malware removal
- Every 3-6 months

**Time:** 10-20 minutes  
**Requires:** Confirmation  
**Note:** Resource intensive

### [A] Run All Optimizations
**When to use:**
- First-time setup
- Monthly maintenance
- General slowness
- Maximum improvement needed

**Time:** 15-30 minutes  
**Includes:** Options 1, 2, 3, 5, 6  
**Recommended:** Most users should start here

### [H] Show First-Time User Guide
**When to use:**
- First time using the tool
- Need a refresher
- Showing someone else how to use it
- Quick reference for common tasks

---

## ⚙️ Advanced Usage

### Running Specific Function from Command Line

You can call specific functions directly:

```powershell
# Source the main script
. .\Optimize-Windows.ps1

# Run a specific function
Clear-TemporaryFiles
```

Available functions:
- `Get-SystemInfo`
- `Clear-TemporaryFiles`
- `Start-DiskCleanup`
- `Optimize-Services`
- `Optimize-VisualEffects`
- `Optimize-Network`
- `Optimize-Drives`
- `Clear-WindowsUpdateCache`
- `Test-SystemHealth`
- `Start-AllOptimizations`

### Scheduled Automation

Create a scheduled task to run optimizations automatically:

1. Open Task Scheduler (`taskschd.msc`)
2. Create New Task
3. Set trigger (e.g., Monthly on 1st day)
4. Set action:
   - Program: `powershell.exe`
   - Arguments: `-ExecutionPolicy Bypass -NoProfile -File "C:\path\to\Optimize-Windows.ps1" -WindowStyle Hidden`
5. Set to run with highest privileges

### Silent/Unattended Mode

For automation scripts:

```powershell
# Source the script and run specific functions
. .\Optimize-Windows.ps1
Clear-TemporaryFiles
Optimize-VisualEffects
# Exit without prompts
```

---

## 🔧 Troubleshooting Common Issues

### Issue: "Cannot be loaded because running scripts is disabled"
**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Or use: `.\Start-WindowsOptimizer.ps1` (handles this automatically)

### Issue: "Administrator privileges required"
**Solution:**
- Close PowerShell
- Right-click PowerShell icon
- Select "Run as Administrator"
- Try again

Or use: `.\Start-WindowsOptimizer.ps1` (auto-elevates)

### Issue: Setup.ps1 doesn't launch the tool
**Solution:**
Run with `-NoLaunch` parameter:
```powershell
.\Setup.ps1 -NoLaunch
```
Then launch manually:
```powershell
.\Optimize-Windows.ps1
```

### Issue: Desktop shortcut doesn't work
**Solution:**
Create it manually during setup:
```powershell
.\Setup.ps1 -CreateShortcut
```

### Issue: Some temp files couldn't be deleted
**Solution:**
- Normal behavior for files in use
- Close all programs and try again
- Run immediately after restart

---

## 📊 Expected Results

### After Running Option [A] (All Optimizations)

**Immediate Benefits:**
- 2-20 GB disk space freed (average: 5-8 GB)
- Reduced startup time (10-30%)
- Fewer background processes
- Improved system responsiveness

**After Restart:**
- Network performance improvements
- Service optimizations active
- Full effect of visual effects changes

**Long-term Benefits (with monthly maintenance):**
- Consistently fast performance
- Reduced system clutter
- Fewer update issues
- Better overall stability

---

## 💡 Pro Tips

1. **Best time to run:** Right after booting, before opening other programs
2. **Frequency:** Monthly for option [A], weekly for option [2]
3. **Before major work:** Run option [2] for a quick boost
4. **Gaming performance:** Run options [4] and [5] before gaming sessions
5. **Free up maximum space:** Run options [2], [3], and [8] in sequence

---

## 📞 Getting Help

If you need assistance:
- Press `H` in the main menu for the interactive guide
- Check [README.md](README.md) for detailed documentation
- Review [INSTALL.md](INSTALL.md) for installation help
- Open an issue on GitHub for bugs or questions

---

**Remember:** When in doubt, option [A] is safe and recommended for all users! 🚀
