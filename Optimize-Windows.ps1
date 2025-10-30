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

# Main Menu
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
    Write-Host "  [1]  System Information" -ForegroundColor White
    Write-Host "  [2]  Clear Temporary Files" -ForegroundColor White
    Write-Host "  [3]  Run Disk Cleanup" -ForegroundColor White
    Write-Host "  [4]  Optimize System Services" -ForegroundColor White
    Write-Host "  [5]  Optimize Visual Effects" -ForegroundColor White
    Write-Host "  [6]  Network Optimization" -ForegroundColor White
    Write-Host "  [7]  Optimize Drives (SSD/HDD)" -ForegroundColor White
    Write-Host "  [8]  Clear Windows Update Cache" -ForegroundColor White
    Write-Host "  [9]  System Health Check (SFC)" -ForegroundColor White
    Write-Host "  [A]  Run All Optimizations (Safe Mode)" -ForegroundColor Green
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
            'Q' { Write-Info "Thank you for using Windows Optimization Tool!"; return }
            'q' { Write-Info "Thank you for using Windows Optimization Tool!"; return }
            default { Write-Warning "Invalid choice. Please try again."; Start-Sleep -Seconds 2 }
        }
    } while ($true)
}

# Start the tool
Start-OptimizationTool
