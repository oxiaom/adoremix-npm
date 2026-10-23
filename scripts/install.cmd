@echo off
chcp 65001 >nul
title AdoreMix Installer
echo.
echo ==============================================
echo   AdoreMix Installer (Windows x64)
echo ==============================================
echo.

set "LOCAL_PS1=%~dp0install.ps1"
if exist "%LOCAL_PS1%" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%LOCAL_PS1%"
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/oxiaom/adoremix-npm/main/scripts/install.ps1 | iex"
)

echo.
echo Done. Press any key to close.
pause >nul
