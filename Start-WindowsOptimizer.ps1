<#
.SYNOPSIS
    One-Click Launcher for Windows Optimization Tool
    
.DESCRIPTION
    This is the simplest way to run the Windows Optimization Tool.
    Just run this script and it will:
    - Check for Administrator privileges
    - Configure necessary settings automatically
    - Launch the optimization tool
    
.EXAMPLE
    .\Start-WindowsOptimizer.ps1
    
.NOTES
    Author: Windows Optimization Tool
    Version: 1.0
    
    This is the recommended way to launch the tool for first-time and regular users.
#>

# Function to check and request admin privileges
function Test-AdminPrivileges {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Host ""
        Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
        Write-Host "║     Administrator Privileges Required                 ║" -ForegroundColor Yellow
        Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "This tool needs Administrator privileges to optimize your system." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Relaunching with Administrator privileges..." -ForegroundColor Green
        Write-Host ""
        
        Start-Sleep -Seconds 2
        
        # Relaunch as Administrator
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        exit
    }
}

# Function to auto-configure and launch
function Start-Optimizer {
    Clear-Host
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "║        Windows Optimization Tool - Quick Start        ║" -ForegroundColor Cyan
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "║        Did You Try Turning It Off and On Again?       ║" -ForegroundColor Cyan
    Write-Host "║                                                        ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "🚀 Preparing to launch..." -ForegroundColor Green
    Write-Host ""
    
    # Get script directory
    $scriptDir = $PSScriptRoot
    $optimizerScript = Join-Path $scriptDir "Optimize-Windows.ps1"
    
    # Verify the main script exists
    if (-not (Test-Path $optimizerScript)) {
        Write-Host "✗ Error: Cannot find Optimize-Windows.ps1" -ForegroundColor Red
        Write-Host ""
        Write-Host "Please make sure you're running this from the correct directory." -ForegroundColor Yellow
        Write-Host "Expected location: $optimizerScript" -ForegroundColor Gray
        Write-Host ""
        pause
        exit
    }
    
    # Auto-configure execution policy if needed
    $currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
    if ($currentPolicy -eq 'Restricted' -or $currentPolicy -eq 'Undefined') {
        Write-Host "⚙ Configuring PowerShell execution policy..." -ForegroundColor Yellow
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue
            Write-Host "  ✓ Execution policy configured" -ForegroundColor Green
        } catch {
            Write-Host "  ℹ Continuing with bypass mode..." -ForegroundColor Cyan
        }
        Write-Host ""
    }
    
    # Unblock script if needed
    try {
        Unblock-File -Path $optimizerScript -ErrorAction SilentlyContinue
    } catch {
        # Silent fail - not critical
    }
    
    Write-Host "✓ Ready to launch!" -ForegroundColor Green
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    
    Start-Sleep -Seconds 1
    
    # Launch the optimizer
    & $optimizerScript
}

# Main execution
Test-AdminPrivileges
Start-Optimizer
