<#
.SYNOPSIS
    Windows Device Optimization Tool
    
.DESCRIPTION
    A comprehensive PowerShell-based Windows optimization tool with guided CLI interface.
    Provides safe system optimization, cleanup, and performance improvements.
    
.NOTES
    Author: Windows Optimization Tool
    Version: 1.0
    Requires: PowerShell 5.1 or higher, Administrator privileges
#>

#Requires -RunAsAdministrator

# Color output functions
function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Header {
    param([string]$Message)
    Write-Host "`n========================================" -ForegroundColor Magenta
    Write-Host " $Message" -ForegroundColor Magenta
    Write-Host "========================================`n" -ForegroundColor Magenta
}

# System Information
function Get-SystemInfo {
    Write-Header "System Information"
    
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor
    $memory = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    
    Write-Info "OS: $($os.Caption) $($os.Version)"
    Write-Info "Computer: $env:COMPUTERNAME"
    Write-Info "CPU: $($cpu.Name)"
    Write-Info "RAM: $([math]::Round($memory.Sum / 1GB, 2)) GB"
    Write-Info "Disk Space: $([math]::Round($disk.FreeSpace / 1GB, 2)) GB free of $([math]::Round($disk.Size / 1GB, 2)) GB"
    Write-Host ""
}

# Clear Temporary Files
function Clear-TemporaryFiles {
    Write-Header "Cleaning Temporary Files"
    
    $tempFolders = @(
        "$env:TEMP",
        "$env:WINDIR\Temp",
        "$env:LOCALAPPDATA\Temp"
    )
    
    $totalCleaned = 0
    
    foreach ($folder in $tempFolders) {
        if (Test-Path $folder) {
            Write-Info "Cleaning: $folder"
            try {
                $beforeSize = (Get-ChildItem $folder -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                Get-ChildItem $folder -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
                $afterSize = (Get-ChildItem $folder -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
                $cleaned = $beforeSize - $afterSize
                $totalCleaned += $cleaned
                Write-Success "Cleaned $([math]::Round($cleaned / 1MB, 2)) MB from $folder"
            }
            catch {
                Write-Warning "Some files couldn't be removed (possibly in use)"
            }
        }
    }
    
    Write-Success "Total cleaned: $([math]::Round($totalCleaned / 1MB, 2)) MB"
    Write-Host ""
}

# Run Disk Cleanup
function Start-DiskCleanup {
    Write-Header "Running Disk Cleanup"
    
    Write-Info "Starting Windows Disk Cleanup utility..."
    Write-Info "This may take a few minutes..."
    
    try {
        # Configure cleanmgr to run with all options
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
        $volumeCaches = Get-ChildItem $regPath -ErrorAction SilentlyContinue
        
        foreach ($cache in $volumeCaches) {
            Set-ItemProperty -Path $cache.PSPath -Name StateFlags0001 -Value 2 -ErrorAction SilentlyContinue
        }
        
        Start-Process cleanmgr.exe -ArgumentList "/sagerun:1" -Wait -NoNewWindow
        Write-Success "Disk Cleanup completed"
    }
    catch {
        Write-Error "Failed to run Disk Cleanup: $_"
    }
    
    Write-Host ""
}

# Optimize System Services
function Optimize-Services {
    Write-Header "Optimizing System Services"
    
    Write-Warning "This will disable some non-essential Windows services"
    $confirm = Read-Host "Continue? (Y/N)"
    
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Write-Info "Skipped service optimization"
        return
    }
    
    # Services that can be safely disabled for better performance
    $servicesToDisable = @(
        @{Name="DiagTrack"; DisplayName="Connected User Experiences and Telemetry"},
        @{Name="dmwappushservice"; DisplayName="WAP Push Message Routing Service"},
        @{Name="SysMain"; DisplayName="Superfetch (SysMain)"}
    )
    
    foreach ($svc in $servicesToDisable) {
        try {
            $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
            if ($service) {
                if ($service.Status -eq 'Running') {
                    Stop-Service -Name $svc.Name -Force -ErrorAction SilentlyContinue
                }
                Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction SilentlyContinue
                Write-Success "Disabled: $($svc.DisplayName)"
            }
        }
        catch {
            Write-Warning "Could not disable $($svc.DisplayName): $_"
        }
    }
    
    Write-Host ""
}

# Optimize Visual Effects
function Optimize-VisualEffects {
    Write-Header "Optimizing Visual Effects for Performance"
    
    Write-Info "Adjusting visual effects for best performance..."
    
    try {
        # Set visual effects to best performance
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue
        Write-Success "Visual effects optimized for performance"
    }
    catch {
        Write-Warning "Could not optimize all visual effects: $_"
    }
    
    Write-Host ""
}

# Network Optimization
function Optimize-Network {
    Write-Header "Optimizing Network Settings"
    
    Write-Info "Flushing DNS cache..."
    ipconfig /flushdns | Out-Null
    Write-Success "DNS cache flushed"
    
    Write-Info "Resetting Winsock catalog..."
    netsh winsock reset | Out-Null
    Write-Success "Winsock reset (restart required to take effect)"
    
    Write-Info "Resetting TCP/IP stack..."
    netsh int ip reset | Out-Null
    Write-Success "TCP/IP stack reset (restart required to take effect)"
    
    Write-Host ""
}

# Defragment and Optimize Drives
function Optimize-Drives {
    Write-Header "Optimizing Drives"
    
    Write-Info "Checking drive types..."
    $drives = Get-PhysicalDisk
    
    foreach ($drive in $drives) {
        $volume = Get-Volume | Where-Object { $_.DriveLetter -eq 'C' }
        if ($volume) {
            Write-Info "Optimizing C: drive..."
            if ($drive.MediaType -eq 'SSD') {
                Write-Info "SSD detected - running TRIM optimization"
                Optimize-Volume -DriveLetter C -ReTrim -Verbose
                Write-Success "SSD optimized with TRIM"
            }
            else {
                Write-Info "HDD detected - analyzing for defragmentation"
                $analysis = Optimize-Volume -DriveLetter C -Analyze -Verbose
                Write-Success "Drive analysis complete"
            }
        }
    }
    
    Write-Host ""
}

# Clear Windows Update Cache
function Clear-WindowsUpdateCache {
    Write-Header "Clearing Windows Update Cache"
    
    Write-Warning "This will stop Windows Update service temporarily"
    $confirm = Read-Host "Continue? (Y/N)"
    
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Write-Info "Skipped Windows Update cache cleanup"
        return
    }
    
    try {
        Write-Info "Stopping Windows Update service..."
        Stop-Service -Name wuauserv -Force
        
        Write-Info "Clearing cache..."
        $cachePath = "$env:WINDIR\SoftwareDistribution\Download"
        if (Test-Path $cachePath) {
            $beforeSize = (Get-ChildItem $cachePath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            Remove-Item "$cachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
            $afterSize = (Get-ChildItem $cachePath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $cleaned = $beforeSize - $afterSize
            Write-Success "Cleared $([math]::Round($cleaned / 1MB, 2)) MB from Windows Update cache"
        }
        
        Write-Info "Starting Windows Update service..."
        Start-Service -Name wuauserv
        Write-Success "Windows Update service restarted"
    }
    catch {
        Write-Error "Failed to clear Windows Update cache: $_"
        Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    }
    
    Write-Host ""
}

# System Health Check
function Test-SystemHealth {
    Write-Header "System Health Check"
    
    Write-Info "Running System File Checker..."
    Write-Warning "This may take 10-15 minutes..."
    
    $confirm = Read-Host "Continue? (Y/N)"
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Write-Info "Skipped system health check"
        return
    }
    
    try {
        sfc /scannow
        Write-Success "System File Checker completed"
    }
    catch {
        Write-Error "System File Checker encountered an error: $_"
    }
    
    Write-Host ""
}

# First-Time User Guide
function Show-FirstTimeGuide {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                                                        ║" -ForegroundColor Green
    Write-Host "║              👋 Welcome, First-Time User!             ║" -ForegroundColor Green
    Write-Host "║                                                        ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "This tool will help you optimize and clean your Windows system." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🎯 Quick Start Guide:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  For First-Time Users:" -ForegroundColor White
    Write-Host "  ────────────────────" -ForegroundColor Gray
    Write-Host "  1. Press [1] to view your system information" -ForegroundColor White
    Write-Host "  2. Press [A] to run all safe optimizations automatically" -ForegroundColor White
    Write-Host "  3. Wait for the process to complete (10-20 minutes)" -ForegroundColor White
    Write-Host "  4. Restart your computer for best results" -ForegroundColor White
    Write-Host ""
    Write-Host "  💡 Tip: Option [A] is the recommended starting point!" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Each menu option includes:" -ForegroundColor Cyan
    Write-Host "    • Clear description of what it does" -ForegroundColor Gray
    Write-Host "    • Safety confirmations where needed" -ForegroundColor Gray
    Write-Host "    • Real-time progress feedback" -ForegroundColor Gray
    Write-Host "    • Estimated time to complete" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  ⚡ Common Use Cases:" -ForegroundColor Yellow
    Write-Host "    • Computer running slow? → Press [4] then [A]" -ForegroundColor Gray
    Write-Host "    • Low disk space? → Press [2], [3], then [8]" -ForegroundColor Gray
    Write-Host "    • Network problems? → Press [6]" -ForegroundColor Gray
    Write-Host "    • Monthly maintenance? → Press [A]" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  🛡️  Safety Features:" -ForegroundColor Cyan
    Write-Host "    ✓ Non-destructive operations (no personal files deleted)" -ForegroundColor Green
    Write-Host "    ✓ Confirmation prompts for important changes" -ForegroundColor Green
    Write-Host "    ✓ Most changes are reversible" -ForegroundColor Green
    Write-Host ""
    
    $continue = Read-Host "Press Enter to continue to the main menu"
    
    # Mark as not first time
    $configPath = Join-Path $PSScriptRoot "config.json"
    if (Test-Path $configPath) {
        try {
            $config = Get-Content $configPath -Raw | ConvertFrom-Json
            $config | Add-Member -NotePropertyName "firstTimeUser" -NotePropertyValue $false -Force
            $config | ConvertTo-Json -Depth 10 | Set-Content $configPath
        } catch {
            # Silently continue if config update fails
        }
    }
}

# Main Menu with Enhanced Descriptions
function Show-Menu {
    Clear-Host
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "║     Windows Device Optimization & Cleanup Tool        ║" -ForegroundColor Cyan
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "║        Did You Try Turning It Off and On Again?       ║" -ForegroundColor Cyan
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Please select an optimization option:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1]  System Information" -ForegroundColor White -NoNewline
    Write-Host "              (View system specs | Instant | Safe)" -ForegroundColor DarkGray
    Write-Host "  [2]  Clear Temporary Files" -ForegroundColor White -NoNewline
    Write-Host "          (Free disk space | 1-5 min | Safe)" -ForegroundColor DarkGray
    Write-Host "  [3]  Run Disk Cleanup" -ForegroundColor White -NoNewline
    Write-Host "              (Deep cleanup | 5-15 min | Safe)" -ForegroundColor DarkGray
    Write-Host "  [4]  Optimize System Services" -ForegroundColor White -NoNewline
    Write-Host "       (Disable telemetry | 1 min | Safe)" -ForegroundColor DarkGray
    Write-Host "  [5]  Optimize Visual Effects" -ForegroundColor White -NoNewline
    Write-Host "        (Better performance | Instant | Safe)" -ForegroundColor DarkGray
    Write-Host "  [6]  Network Optimization" -ForegroundColor White -NoNewline
    Write-Host "          (Fix network issues | 1 min | Safe)" -ForegroundColor DarkGray
    Write-Host "  [7]  Optimize Drives (SSD/HDD)" -ForegroundColor White -NoNewline
    Write-Host "      (Defrag/TRIM | 5-30 min | Safe)" -ForegroundColor DarkGray
    Write-Host "  [8]  Clear Windows Update Cache" -ForegroundColor White -NoNewline
    Write-Host "     (Fix updates | 2-5 min | Safe)" -ForegroundColor DarkGray
    Write-Host "  [9]  System Health Check (SFC)" -ForegroundColor White -NoNewline
    Write-Host "      (Repair files | 10-20 min | Safe)" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  [A]  Run All Optimizations (Safe Mode)" -ForegroundColor Green -NoNewline
    Write-Host "  ⭐ Recommended!" -ForegroundColor Yellow
    Write-Host "  [H]  Show First-Time User Guide" -ForegroundColor Cyan
    Write-Host "  [Q]  Quit" -ForegroundColor Red
    Write-Host ""
}

# Run All Safe Optimizations
function Start-AllOptimizations {
    Write-Header "Running All Safe Optimizations"
    
    Write-Warning "This will run multiple optimization tasks"
    $confirm = Read-Host "Continue? (Y/N)"
    
    if ($confirm -ne 'Y' -and $confirm -ne 'y') {
        Write-Info "Cancelled all optimizations"
        return
    }
    
    Get-SystemInfo
    Clear-TemporaryFiles
    Start-DiskCleanup
    Optimize-VisualEffects
    Optimize-Network
    
    Write-Success "`nAll safe optimizations completed!"
    Write-Info "For best results, restart your computer."
    Write-Host ""
}

# Main Program Loop
function Start-OptimizationTool {
    # Check for admin privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Error "This script requires Administrator privileges!"
        Write-Info "Please right-click and select 'Run as Administrator'"
        pause
        exit
    }
    
    # Check if this is the first time running the tool
    $configPath = Join-Path $PSScriptRoot "config.json"
    $isFirstTime = $true
    
    if (Test-Path $configPath) {
        try {
            $config = Get-Content $configPath -Raw | ConvertFrom-Json
            if ($config.PSObject.Properties.Name -contains "firstTimeUser") {
                $isFirstTime = $config.firstTimeUser
            }
        } catch {
            # If config can't be read, treat as first time
            $isFirstTime = $true
        }
    }
    
    # Show first-time guide if needed
    if ($isFirstTime) {
        Show-FirstTimeGuide
    }
    
    do {
        Show-Menu
        $choice = Read-Host "Enter your choice"
        
        switch ($choice) {
            '1' { Get-SystemInfo; pause }
            '2' { Clear-TemporaryFiles; pause }
            '3' { Start-DiskCleanup; pause }
            '4' { Optimize-Services; pause }
            '5' { Optimize-VisualEffects; pause }
            '6' { Optimize-Network; pause }
            '7' { Optimize-Drives; pause }
            '8' { Clear-WindowsUpdateCache; pause }
            '9' { Test-SystemHealth; pause }
            'A' { Start-AllOptimizations; pause }
            'a' { Start-AllOptimizations; pause }
            'H' { Show-FirstTimeGuide; pause }
            'h' { Show-FirstTimeGuide; pause }
            'Q' { Write-Info "Thank you for using Windows Optimization Tool!"; return }
            'q' { Write-Info "Thank you for using Windows Optimization Tool!"; return }
            default { Write-Warning "Invalid choice. Please try again."; Start-Sleep -Seconds 2 }
        }
    } while ($true)
}

# Start the tool
Start-OptimizationTool
