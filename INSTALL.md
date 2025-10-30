# Installation Guide

## Step-by-Step Installation Instructions

### Prerequisites Check

Before installing, verify you have:
- ✅ Windows 10 or Windows 11
- ✅ Administrator account access
- ✅ PowerShell 5.1 or higher (check with: `$PSVersionTable.PSVersion`)

### Installation Methods

#### Option 1: Git Clone (Recommended)

1. **Open PowerShell as Administrator**
   - Press `Win + X`
   - Select "Windows PowerShell (Admin)" or "Terminal (Admin)"

2. **Navigate to desired location**
   ```powershell
   cd C:\Tools
   # Or any directory you prefer
   ```

3. **Clone the repository**
   ```powershell
   git clone https://github.com/cxb3rf1lth/Did-you-try-turning-it-on-and-off-again.git
   cd Did-you-try-turning-it-on-and-off-again
   ```

#### Option 2: Direct Download

1. **Download the ZIP file**
   - Visit: https://github.com/cxb3rf1lth/Did-you-try-turning-it-on-and-off-again
   - Click the green "Code" button
   - Select "Download ZIP"

2. **Extract the ZIP file**
   - Right-click the downloaded ZIP file
   - Select "Extract All..."
   - Choose a location (e.g., `C:\Tools\`)

3. **Navigate to the folder**
   ```powershell
   cd "C:\Tools\Did-you-try-turning-it-on-and-off-again"
   ```

#### Option 3: Manual Download

1. **Download just the main script**
   - Go to the repository
   - Click on `Optimize-Windows.ps1`
   - Click "Raw" button
   - Right-click and "Save As..." to your computer

2. **Save to a convenient location**
   - Recommended: `C:\Tools\` or `Documents\Scripts\`

### First-Time Setup

#### Step 1: Enable Script Execution

PowerShell's execution policy might prevent the script from running. Enable it:

```powershell
# Open PowerShell as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

When prompted, type `Y` and press Enter.

**What does this do?**
- Allows locally created scripts to run
- Still requires downloaded scripts to be signed or trusted
- Does not compromise system security

#### Step 2: Unblock the Script (If Downloaded)

If you downloaded the script, Windows might block it:

```powershell
# Unblock the script file
Unblock-File -Path .\Optimize-Windows.ps1
```

#### Step 3: Verify Installation

```powershell
# Check if the script exists
Test-Path .\Optimize-Windows.ps1

# Should return: True
```

### Running the Tool

#### Method 1: PowerShell Command Line

```powershell
# Navigate to the script directory
cd "C:\Tools\Did-you-try-turning-it-on-and-off-again"

# Run the script
.\Optimize-Windows.ps1
```

#### Method 2: Right-Click Context Menu

1. Right-click `Optimize-Windows.ps1`
2. Select "Run with PowerShell"
3. If prompted, confirm to run as Administrator

#### Method 3: Bypass Execution Policy (One-Time)

If you don't want to change execution policy:

```powershell
powershell -ExecutionPolicy Bypass -File .\Optimize-Windows.ps1
```

### Creating a Desktop Shortcut (Optional)

1. **Right-click on Desktop** → New → Shortcut

2. **Enter this as the location:**
   ```
   powershell.exe -ExecutionPolicy Bypass -File "C:\Tools\Did-you-try-turning-it-on-and-off-again\Optimize-Windows.ps1"
   ```
   *(Adjust path to match your installation)*

3. **Name the shortcut:** "Windows Optimizer"

4. **Right-click the shortcut** → Properties

5. **Click "Advanced"** → Check "Run as administrator"

6. **Click OK** twice

Now you can double-click the desktop icon to run the tool!

### Troubleshooting Installation

#### Error: "File cannot be loaded because running scripts is disabled"

**Solution:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### Error: "Administrator privileges required"

**Solution:**
- Close PowerShell
- Right-click PowerShell icon
- Select "Run as Administrator"
- Try again

#### Error: "The file is not digitally signed"

**Solution:**
```powershell
Unblock-File -Path .\Optimize-Windows.ps1
```

Or run with bypass:
```powershell
powershell -ExecutionPolicy Bypass -File .\Optimize-Windows.ps1
```

#### Script won't start or immediately closes

**Solution:**
1. Open PowerShell as Administrator manually
2. Navigate to script directory: `cd "path\to\script"`
3. Run directly: `.\Optimize-Windows.ps1`
4. Check for error messages

### Updating the Tool

If you installed via Git:

```powershell
cd "C:\Tools\Did-you-try-turning-it-on-and-off-again"
git pull origin main
```

If you downloaded manually:
- Download the latest version again
- Replace old files with new ones

### Uninstallation

To remove the tool:

1. **Delete the folder:**
   ```powershell
   Remove-Item -Path "C:\Tools\Did-you-try-turning-it-on-and-off-again" -Recurse -Force
   ```

2. **Remove desktop shortcut** (if created)

3. **(Optional) Restore execution policy:**
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
   ```

### System Requirements Details

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Windows 10 | Windows 11 |
| PowerShell | 5.1 | 7.x |
| RAM | 4 GB | 8 GB+ |
| Disk Space | 1 GB free | 5 GB+ free |
| Privileges | Administrator | Administrator |

### Post-Installation

After successful installation:

1. ✅ **Run the tool** for the first time
2. ✅ **Select option [1]** to verify it can read system information
3. ✅ **Try a safe operation** like option [2] to clear temp files
4. ✅ **Bookmark this guide** for future reference

### Getting Help

If you encounter issues:
- Check the [README.md](README.md) for detailed usage
- Review [Troubleshooting](#troubleshooting-installation) section above
- Open an issue on GitHub with error details

---

**You're all set!** The tool is ready to optimize your Windows system. 🚀
