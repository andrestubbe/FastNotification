# FastNotification Windows Setup Script
# Registers the application for Windows Toast notifications
# 
# NOTE: This script is run automatically by the installer (MSI/EXE).
# End users should NEVER run this manually.

param(
    [string]$InstallPath = "C:\Program Files\FastNotification",
    [string]$IconPath = "$InstallPath\icon.png"
)

Write-Host "Registering FastNotification for Windows Toast notifications..." -ForegroundColor Green

# Create registry entries for Toast support
$regPath = "HKCU:\Software\Classes\AppUserModelId\FastNotification"

if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set app display name
Set-ItemProperty -Path $regPath -Name "DisplayName" -Value "FastNotification"

# Set icon (if exists, otherwise Windows default)
if (Test-Path $IconPath) {
    Set-ItemProperty -Path $regPath -Name "IconUri" -Value $IconPath
}

# Mark as toast-capable
Set-ItemProperty -Path $regPath -Name "ShowInSettings" -Value 1 -Type DWord

# Create shortcut in Start Menu (required for Toast notifications)
$startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\FastNotification.lnk"
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($startMenuPath)
$shortcut.TargetPath = "$InstallPath\FastNotification.dll"
$shortcut.IconLocation = "$IconPath, 0"
$shortcut.Save()

Write-Host "Registration complete!" -ForegroundColor Green
Write-Host "Toast notifications are now enabled for FastNotification."
