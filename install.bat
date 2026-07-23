@echo off
title Antigravity Persian RTL & Vazirmatn Auto-Installer
color 0A
echo ==========================================================
echo   Starting Antigravity Persian RTL One-Click Installer...
echo ==========================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

echo.
echo Setup completed! Press any key to exit.
pause >nul
