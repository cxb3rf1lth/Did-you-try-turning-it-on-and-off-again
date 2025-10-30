# Windows Device Optimization Tool 🚀

> *"Have you tried turning it off and on again?"* - The universal IT solution

A comprehensive PowerShell-based Windows optimization tool with an intuitive guided CLI interface. Safely optimize, clean, and improve your Windows system performance with easy-to-follow menus and detailed guidance.

## 🌟 Features

### System Optimization
- **Temporary File Cleanup** - Remove unnecessary temp files and free up disk space
- **Disk Cleanup** - Run Windows built-in disk cleanup utility with all options
- **Service Optimization** - Disable non-essential services for better performance
- **Visual Effects Tuning** - Optimize visual effects for performance
- **Drive Optimization** - Defragment HDDs or TRIM SSDs automatically

### Network Enhancements
- **DNS Cache Flush** - Clear DNS cache for faster lookups
- **Winsock Reset** - Fix network connectivity issues
- **TCP/IP Stack Reset** - Resolve networking problems

### System Maintenance
- **Windows Update Cache Cleanup** - Clear stuck update files
- **System Health Check** - Run System File Checker (SFC)
- **System Information Display** - View detailed system specs

### User Experience
- ✨ **Guided CLI Interface** - Easy-to-navigate menu system
- 🎨 **Color-coded Output** - Visual feedback for all operations
- ⚡ **One-Click Optimization** - Run all safe optimizations with option [A]
- 🛡️ **Safety First** - Confirmations for potentially impactful changes
- 📊 **Real-time Feedback** - See exactly what's being optimized

## 📋 Requirements

- **Operating System**: Windows 10 or Windows 11
- **PowerShell**: Version 5.1 or higher (included in Windows 10/11)
- **Privileges**: Administrator rights required
- **Disk Space**: At least 1GB free for cleanup operations

## 🚀 Quick Start

### Method 1: Download and Run (Recommended)

1. **Download the script**:
   ```powershell
   # Clone the repository
   git clone https://github.com/cxb3rf1lth/Did-you-try-turning-it-on-and-off-again.git
   cd Did-you-try-turning-it-on-and-off-again
   ```

2. **Run as Administrator**:
   - Right-click `Optimize-Windows.ps1`
   - Select **"Run with PowerShell"** (as Administrator)
   
   Or from PowerShell:
   ```powershell
   # Open PowerShell as Administrator, then run:
   .\Optimize-Windows.ps1
   ```

### Method 2: Enable Scripts (If Needed)

If you get an execution policy error:

```powershell
# Open PowerShell as Administrator and run:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then run the script:
.\Optimize-Windows.ps1
```

### Method 3: Bypass Policy (Single Session)

```powershell
# Run this command as Administrator:
powershell -ExecutionPolicy Bypass -File .\Optimize-Windows.ps1
```

## 📖 Usage Guide

### Main Menu

When you launch the tool, you'll see this menu:

```
╔════════════════════════════════════════════════════════╗
║                                                        ║
║     Windows Device Optimization & Cleanup Tool        ║
║                                                        ║
║        Did You Try Turning It Off and On Again?       ║
║                                                        ║
╚════════════════════════════════════════════════════════╝

  Please select an optimization option:

  [1]  System Information
  [2]  Clear Temporary Files
  [3]  Run Disk Cleanup
  [4]  Optimize System Services
  [5]  Optimize Visual Effects
  [6]  Network Optimization
  [7]  Optimize Drives (SSD/HDD)
  [8]  Clear Windows Update Cache
  [9]  System Health Check (SFC)
  [A]  Run All Optimizations (Safe Mode)
  [Q]  Quit
```

### Option Details

#### [1] System Information
- Displays comprehensive system details
- Shows OS version, CPU, RAM, and disk space
- **Safe**: Read-only operation
- **Time**: Instant

#### [2] Clear Temporary Files
- Removes files from Windows temp folders
- Cleans user temp directory
- Shows amount of space freed
- **Safe**: Yes
- **Time**: 1-5 minutes

#### [3] Run Disk Cleanup
- Launches Windows Disk Cleanup with all options enabled
- Removes old Windows updates, logs, and cached files
- **Safe**: Yes
- **Time**: 5-15 minutes

#### [4] Optimize System Services
- Disables telemetry and non-essential services:
  - Connected User Experiences and Telemetry
  - WAP Push Message Routing Service
  - Superfetch/SysMain (if not needed)
- **Requires confirmation**: Yes
- **Safe**: Yes (can be reverted)
- **Time**: 1 minute

#### [5] Optimize Visual Effects
- Adjusts Windows visual effects for best performance
- Reduces animations and transparency
- **Safe**: Yes (can be reverted via System Properties)
- **Time**: Instant

#### [6] Network Optimization
- Flushes DNS cache
- Resets Winsock catalog
- Resets TCP/IP stack
- **Note**: Restart required for full effect
- **Safe**: Yes
- **Time**: 1 minute

#### [7] Optimize Drives
- Detects drive type (SSD or HDD)
- Runs TRIM on SSDs for optimal performance
- Analyzes HDDs for defragmentation needs
- **Safe**: Yes
- **Time**: 5-30 minutes (depending on drive size)

#### [8] Clear Windows Update Cache
- Stops Windows Update service temporarily
- Clears stuck update files
- Restarts Windows Update service
- **Requires confirmation**: Yes
- **Safe**: Yes
- **Time**: 2-5 minutes

#### [9] System Health Check (SFC)
- Runs System File Checker
- Repairs corrupted system files
- **Requires confirmation**: Yes (takes time)
- **Safe**: Yes
- **Time**: 10-20 minutes

#### [A] Run All Optimizations
- Executes all safe optimizations automatically:
  - System Information
  - Clear Temporary Files
  - Disk Cleanup
  - Visual Effects
  - Network Optimization
- **Recommended**: For comprehensive system tune-up
- **Time**: 15-30 minutes

## 🛡️ Safety Features

- **Administrator Check**: Ensures proper privileges before running
- **Confirmation Prompts**: Asks before making significant changes
- **Non-destructive**: Only removes temporary/cache files
- **Reversible Changes**: Most optimizations can be undone
- **Error Handling**: Gracefully handles locked files and errors
- **Detailed Logging**: See exactly what's being done

## ⚠️ Important Notes

### Before Running
1. **Close all programs** - Especially browsers and Office apps
2. **Save your work** - Some operations may require a restart
3. **Check disk space** - Ensure you have at least 1GB free
4. **Backup important data** - Though this tool is safe, always backup

### After Running
- **Restart your computer** for network optimizations to take full effect
- **Check performance** - Most improvements are immediate
- **Re-run periodically** - Monthly maintenance recommended

### What This Tool Does NOT Do
- ❌ Does not delete personal files or documents
- ❌ Does not uninstall programs
- ❌ Does not modify BIOS/UEFI settings
- ❌ Does not disable security features
- ❌ Does not require internet connection

## 🔧 Troubleshooting

### "Execution Policy" Error
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Administrator Privileges Required"
- Right-click PowerShell icon
- Select "Run as Administrator"
- Navigate to script location
- Run the script

### Script Won't Run
```powershell
# Try this command:
powershell -ExecutionPolicy Bypass -File .\Optimize-Windows.ps1
```

### Some Files Can't Be Deleted
- Normal behavior - files in use can't be removed
- Close all programs and try again
- Restart and run the script immediately after boot

## 📊 Expected Results

### Typical Performance Improvements
- **Disk Space**: 2-20GB freed (varies by system usage)
- **Boot Time**: 10-30% faster
- **System Responsiveness**: Noticeably improved
- **Network**: Faster DNS lookups and browsing

### When to Run This Tool
- ✅ System feels sluggish
- ✅ Running low on disk space
- ✅ After major Windows updates
- ✅ Monthly maintenance routine
- ✅ Before important work/presentations
- ✅ After installing/uninstalling many programs

## 🤝 Contributing

Found a bug or have a suggestion? Feel free to:
- Open an issue
- Submit a pull request
- Share your optimization ideas

## 📜 License

MIT License - Feel free to use and modify for your needs.

## ⚡ Advanced Usage

### Run Specific Function from Command Line
```powershell
# Source the script and run a specific function
. .\Optimize-Windows.ps1
Clear-TemporaryFiles
```

### Scheduled Maintenance
Create a scheduled task to run optimizations automatically:
```powershell
# Run Task Scheduler (taskschd.msc)
# Create a new task with action:
powershell.exe -ExecutionPolicy Bypass -File "C:\path\to\Optimize-Windows.ps1"
```

## 💡 Tips for Best Results

1. **Run option [A] first** - Gets most optimizations done quickly
2. **Close all apps** - Maximizes files that can be cleaned
3. **Restart after** - Applies network and service changes
4. **Run monthly** - Keeps system in optimal condition
5. **Monitor results** - Use option [1] to track improvements

## 🎯 Common Use Cases

### Slow Computer Startup
```
Run: [4] Optimize System Services
Then: [A] Run All Optimizations
Finally: Restart
```

### Low Disk Space
```
Run: [2] Clear Temporary Files
Then: [3] Run Disk Cleanup
Then: [8] Clear Windows Update Cache
```

### Network Issues
```
Run: [6] Network Optimization
Then: Restart
```

### General Maintenance
```
Run: [A] Run All Optimizations
Monthly or when system feels slow
```

## 📞 Support

For issues, questions, or suggestions:
- GitHub Issues: [Open an issue](https://github.com/cxb3rf1lth/Did-you-try-turning-it-on-and-off-again/issues)
- Documentation: This README
- Community: Check existing issues for solutions

---

**Remember**: When in doubt, restart your computer! 🔄

*Made with ❤️ for Windows users who want a faster, cleaner system*