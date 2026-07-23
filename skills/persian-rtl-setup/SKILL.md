---
name: persian-rtl-setup
description: Automatically configures Antigravity IDE and VS Code for Persian RTL right alignment, Vazirmatn font installation, Slate Dark theme, and professional LTR log blocks.
---

# Persian RTL & Vazirmatn Setup Skill for Antigravity

This skill enables full Persian RTL (Right-to-Left) support, installs Vazirmatn fonts, sets up Slate Dark theme, and configures agent formatting rules across all projects.

## Capabilities & Automated Actions

When this skill is activated:
1. **Font Setup**: Downloads and installs all weight variants of the Vazirmatn font family into Windows fonts (`%LOCALAPPDATA%\Microsoft\Windows\Fonts`) and Windows Registry.
2. **IDE Settings**: Configures `settings.json` for 19px Vazirmatn font, 2.0 line-height, Bidi highlighting, and Slate Dark theme (`#1e222a`).
3. **Agent Rules**: Creates global AI rule (`~/.gemini/antigravity/rules/persian_formatting.md`) so all future agent responses render right-aligned in Persian with isolated LTR log blocks.
4. **Markdown RTL Wrapper**: Ensures Markdown files (like `README.md`) are wrapped in explicit HTML `<div dir="rtl">` so preview panes render correctly right-aligned.

## Execution Instruction

To execute the automated setup for this skill:
```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.gemini\antigravity\skills\persian-rtl-setup\scripts\install.ps1"
```
