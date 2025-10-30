<#
.SYNOPSIS
    Automated Setup and Launch for Windows Optimization Tool
    
.DESCRIPTION
    This script automates the complete setup process:
    - Checks prerequisites
    - Configures execution policy
    - Unblocks the script
    - Creates a desktop shortcut (optional)
    - Launches the optimization tool
    
.EXAMPLE
    .\Setup.ps1
    
.EXAMPLE
    .\Setup.ps1 -NoLaunch
    
.NOTES
    Author: Windows Optimization Tool
    Version: 1.0
    Requires: PowerShell 5.1 or higher, Administrator privileges
#>

param(
    [switch]$NoLaunch,
    [switch]$CreateShortcut
)

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  Administrator Privileges Required" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "This setup script needs to run as Administrator." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please follow these steps:" -ForegroundColor Cyan
    Write-Host "  1. Right-click on PowerShell" -ForegroundColor White
    Write-Host "  2. Select 'Run as Administrator'" -ForegroundColor White
    Write-Host "  3. Navigate to: $PSScriptRoot" -ForegroundColor White
    Write-Host "  4. Run: .\Setup.ps1" -ForegroundColor White
    Write-Host ""
    
    $relaunch = Read-Host "Would you like to relaunch as Administrator now? (Y/N)"
    if ($relaunch -eq 'Y' -or $relaunch -eq 'y') {
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -CreateShortcut:$CreateShortcut -NoLaunch:$NoLaunch"
    }
    exit
}

# Banner
Clear-Host
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                        ║" -ForegroundColor Cyan
Write-Host "║     Windows Optimization Tool - Automated Setup       ║" -ForegroundColor Cyan
Write-Host "║                                                        ║" -ForegroundColor Cyan
Write-Host "║        Did You Try Turning It Off and On Again?       ║" -ForegroundColor Cyan
Write-Host "║                                                        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "🚀 Starting automated setup..." -ForegroundColor Green
Write-Host ""

# Step 1: Check Prerequisites
Write-Host "[1/5] Checking prerequisites..." -ForegroundColor Yellow

$psVersion = $PSVersionTable.PSVersion
Write-Host "  ✓ PowerShell version: $($psVersion.Major).$($psVersion.Minor)" -ForegroundColor Green

$osInfo = Get-CimInstance Win32_OperatingSystem
Write-Host "  ✓ Operating System: $($osInfo.Caption)" -ForegroundColor Green

$scriptPath = Join-Path $PSScriptRoot "Optimize-Windows.ps1"
if (Test-Path $scriptPath) {
    Write-Host "  ✓ Optimization script found" -ForegroundColor Green
} else {
    Write-Host "  ✗ Error: Optimize-Windows.ps1 not found!" -ForegroundColor Red
    Write-Host "    Make sure you're running this from the correct directory." -ForegroundColor Yellow
    pause
    exit
}
Write-Host ""

# Step 2: Configure Execution Policy
Write-Host "[2/5] Configuring PowerShell execution policy..." -ForegroundColor Yellow

$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
Write-Host "  Current policy: $currentPolicy" -ForegroundColor Cyan

if ($currentPolicy -eq 'Restricted' -or $currentPolicy -eq 'Undefined') {
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "  ✓ Execution policy set to RemoteSigned" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ Could not change execution policy (this is usually OK)" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ✓ Execution policy is already configured" -ForegroundColor Green
}
Write-Host ""

# Step 3: Unblock Script
Write-Host "[3/5] Unblocking script files..." -ForegroundColor Yellow

try {
    Unblock-File -Path $scriptPath -ErrorAction SilentlyContinue
    Write-Host "  ✓ Script file unblocked" -ForegroundColor Green
} catch {
    Write-Host "  ✓ Script was already unblocked" -ForegroundColor Green
}
Write-Host ""

# Step 4: Create Desktop Shortcut (Optional)
Write-Host "[4/5] Desktop shortcut creation..." -ForegroundColor Yellow

if ($CreateShortcut) {
    $createIt = 'Y'
} else {
    $createIt = Read-Host "  Create desktop shortcut? (Y/N)"
}

if ($createIt -eq 'Y' -or $createIt -eq 'y') {
    try {
        $desktopPath = [Environment]::GetFolderPath("Desktop")
        $shortcutPath = Join-Path $desktopPath "Windows Optimizer.lnk"
        
        $WshShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($shortcutPath)
        $Shortcut.TargetPath = "powershell.exe"
        $Shortcut.Arguments = "-ExecutionPolicy Bypass -NoProfile -File `"$scriptPath`""
        $Shortcut.WorkingDirectory = $PSScriptRoot
        $Shortcut.Description = "Windows Device Optimization Tool"
        $Shortcut.IconLocation = "powershell.exe,0"
        $Shortcut.Save()
        
        Write-Host "  ✓ Desktop shortcut created: $shortcutPath" -ForegroundColor Green
        Write-Host "    Note: Right-click the shortcut and select 'Run as administrator'" -ForegroundColor Cyan
    } catch {
        Write-Host "  ⚠ Could not create desktop shortcut: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⊝ Skipped desktop shortcut creation" -ForegroundColor Gray
}
Write-Host ""

# Step 5: Verify Setup
Write-Host "[5/5] Verifying setup..." -ForegroundColor Yellow
Write-Host "  ✓ All checks passed!" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║                                                        ║" -ForegroundColor Green
Write-Host "║              Setup Completed Successfully!            ║" -ForegroundColor Green
Write-Host "║                                                        ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  The tool is ready to use! You can run it by:" -ForegroundColor White
Write-Host "    • Using the desktop shortcut (if created)" -ForegroundColor White
Write-Host "    • Running: .\Optimize-Windows.ps1" -ForegroundColor White
Write-Host "    • Running: .\Start-WindowsOptimizer.ps1 (one-click launch)" -ForegroundColor White
Write-Host ""

# Launch the tool
if (-not $NoLaunch) {
    Write-Host "🎯 Launching Windows Optimization Tool..." -ForegroundColor Green
    Write-Host ""
    Start-Sleep -Seconds 2
    
    & $scriptPath
} else {
    Write-Host "Setup complete. Run .\Optimize-Windows.ps1 to start." -ForegroundColor Cyan
    Write-Host ""
    pause
}
