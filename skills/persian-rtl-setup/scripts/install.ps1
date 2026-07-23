# ==============================================================================
# Antigravity & VS Code Persian RTL & Local Font Setup Skill Script
# ==============================================================================

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$LocalFontsDir = Join-Path (Split-Path -Parent $ScriptDir) "fonts"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Running Offline Local Antigravity Persian Skill Setup..." -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Install Fonts from Local Skill Directory (No internet needed)
$fontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
if (-not (Test-Path $fontDir)) {
    New-Item -ItemType Directory -Path $fontDir -Force | Out-Null
}

Write-Host "[1/3] Installing Local Font Bundles..." -ForegroundColor Yellow

if (Test-Path $LocalFontsDir) {
    $fontFiles = Get-ChildItem -Path $LocalFontsDir -Recurse -Include *.ttf,*.otf
    $regPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

    foreach ($f in $fontFiles) {
        $target = Join-Path $fontDir $f.Name
        Copy-Item $f.FullName $target -Force
        $fontName = $f.BaseName + " (TrueType)"
        New-ItemProperty -Path $regPath -Name $fontName -Value $target -PropertyType String -Force | Out-Null
    }
    Write-Host "Successfully installed font files system-wide!" -ForegroundColor Green
} else {
    Write-Host "Local font directory not found" -ForegroundColor Red
}

# 2. Update IDE User Settings
Write-Host "[2/3] Configuring IDE Settings..." -ForegroundColor Yellow

$appDataPaths = @(
    "$env:APPDATA\Antigravity\User",
    "$env:APPDATA\Code\User"
)

foreach ($path in $appDataPaths) {
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
    
    $settingsFile = Join-Path $path "settings.json"
    $existing = @{}
    if (Test-Path $settingsFile) {
        try {
            $existing = Get-Content $settingsFile -Raw | ConvertFrom-Json -AsHashtable
        } catch {
            $existing = @{}
        }
    }
    
    $existing["workbench.colorTheme"] = "Default Dark Modern"
    $existing["editor.fontFamily"] = "'Vazirmatn', 'Vazirmatn UI', 'Segoe UI', 'Tahoma', 'Fira Code', 'Consolas', monospace"
    $existing["editor.fontSize"] = 19
    $existing["editor.fontWeight"] = "500"
    $existing["editor.lineHeight"] = 30
    $existing["editor.unicodeHighlight.bidiCharacters"] = $true
    $existing["markdown.preview.fontFamily"] = "'Vazirmatn', 'Vazirmatn UI', 'Segoe UI', 'Tahoma', sans-serif"
    $existing["markdown.preview.fontSize"] = 19
    $existing["markdown.preview.lineHeight"] = 2.0
    $existing["chat.editor.fontFamily"] = "'Vazirmatn', 'Segoe UI', 'Tahoma', sans-serif"
    $existing["chat.editor.fontSize"] = 19

    if (-not $existing.ContainsKey("workbench.colorCustomizations")) {
        $existing["workbench.colorCustomizations"] = @{}
    }
    $colors = $existing["workbench.colorCustomizations"]
    $colors["editor.background"] = "#1e222a"
    $colors["editor.foreground"] = "#e1e6ef"
    $colors["sideBar.background"] = "#181b21"
    $colors["activityBar.background"] = "#14161b"
    $colors["statusBar.background"] = "#14161b"
    $colors["titleBar.activeBackground"] = "#181b21"

    $existing | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8
    Write-Host "Updated $settingsFile" -ForegroundColor Green
}

# 3. Create Global Antigravity AI Rules
Write-Host "[3/3] Setting Up Global AI Agent Rules..." -ForegroundColor Yellow
$globalRulesDir = "$env:USERPROFILE\.gemini\antigravity\rules"
if (-not (Test-Path $globalRulesDir)) {
    New-Item -ItemType Directory -Path $globalRulesDir -Force | Out-Null
}

$ruleContent = @'
---
description: Always format Persian responses with RTL right alignment, Vazirmatn 19px font, HTML tables with dir="rtl", and professional LTR log blocks.
globs: "*"
---

# Persian RTL and Formatting Rule

Whenever responding in Persian:
1. Always wrap the entire response in a `<div dir="rtl" style="font-family: 'Vazirmatn', 'Segoe UI', Tahoma, sans-serif; font-size: 19px; line-height: 2.0; text-align: right;">` container.
2. For all tables, use explicit HTML `<table dir="rtl" style="width:100%; border-collapse:collapse; text-align:right; direction:rtl;">` so columns order correctly from Right-to-Left (First column on far right).
3. For all logs, command outputs, file paths, and terminal snippets, display them in professional LTR log blocks using `<div dir="ltr" style="background:#161b22; color:#e6edf3; padding:12px; border-radius:8px; border-left:4px solid #58a6ff; font-family:Consolas, monospace; font-size:15px; text-align:left; margin:10px 0;">...</div>`.
'@

Set-Content -Path (Join-Path $globalRulesDir "persian_formatting.md") -Value $ruleContent -Encoding UTF8
Write-Host "Global Rule created: $globalRulesDir\persian_formatting.md" -ForegroundColor Green

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "Offline Skill Setup Completed Successfully!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
