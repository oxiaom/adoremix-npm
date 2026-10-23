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
  powershell -NoProfile -ExecutionPolicy Bypass -Command "iwr https://cdn.jsdelivr.net/gh/oxiaom/adoremix-npm@main/scripts/install.ps1 -OutFile $env:TEMP\adoremix-install.ps1 -UseBasicParsing; & $env:TEMP\adoremix-install.ps1"
)

echo.
echo Done. Press any key to close.
pause >nul
