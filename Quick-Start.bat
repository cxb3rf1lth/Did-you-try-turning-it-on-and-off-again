@echo off
REM Quick Start Launcher for Windows Optimization Tool
REM This batch file provides the easiest way to launch the tool
REM Just double-click this file!

echo.
echo ================================================================
echo      Windows Optimization Tool - Quick Start Launcher
echo ================================================================
echo.
echo Starting the optimizer...
echo.

REM Check if PowerShell is available
where powershell >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: PowerShell is not found on your system.
    echo Please ensure PowerShell is installed.
    pause
    exit /b 1
)

REM Launch the optimizer with proper permissions
powershell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"%~dp0Start-WindowsOptimizer.ps1\"' -Verb RunAs}"

exit /b 0
