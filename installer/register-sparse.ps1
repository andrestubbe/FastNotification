# Register Sparse Package during Installation
# 
# This script registers the FastNotification identity package with Windows.
# Call this from your installer (WiX, Inno Setup, NSIS, etc.) during setup.
#
# The app remains at its install location but gains access to Windows features.

param(
    [Parameter(Mandatory=$true)]
    [string]$InstallPath,
    
    [string]$PackageName = "AndreStubbe.FastNotification",
    [string]$PackagePath = "$PSScriptRoot\FastNotification-Identity.msix",
    
    [ValidateSet("PerUser", "PerMachine")]
    [string]$InstallMode = "PerUser"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FastNotification Registration" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Install Path: $InstallPath" -ForegroundColor Gray
Write-Host "Package: $PackagePath" -ForegroundColor Gray
Write-Host "Mode: $InstallMode" -ForegroundColor Gray
Write-Host ""

# Verify package exists
if (-not (Test-Path $PackagePath)) {
    Write-Error "Package not found: $PackagePath"
    Write-Error "Create package first with create-package.ps1"
    exit 1
}

# Verify install path exists
if (-not (Test-Path $InstallPath)) {
    Write-Error "Install path not found: $InstallPath"
    exit 1
}

# Check if already registered
$existingPackage = Get-AppxPackage -Name $PackageName -ErrorAction SilentlyContinue
if ($existingPackage) {
    Write-Warning "Package $PackageName is already registered."
    Write-Host "Unregistering existing package first..." -ForegroundColor Yellow
    
    if ($InstallMode -eq "PerMachine") {
        $packages = Get-AppxPackage -AllUsers -Name $PackageName
        $provisioned = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $PackageName }
        foreach ($p in $provisioned) { 
            Remove-AppxProvisionedPackage -PackageName $p.PackageName -Online 
        }
        foreach ($package in $packages) { 
            Remove-AppxPackage -Package $package.PackageFullName -AllUsers 
        }
    } else {
        Remove-AppxPackage -Package $existingPackage.PackageFullName
    }
    
    Write-Host "Existing package removed." -ForegroundColor Green
}

Write-Host "Step 1: Registering identity package..." -ForegroundColor Yellow

try {
    if ($InstallMode -eq "PerUser") {
        # Per-user installation (current user only)
        Write-Host "Registering for current user..." -ForegroundColor Gray
        
        Add-AppxPackage `
            -Path $PackagePath `
            -ExternalLocation $InstallPath `
            -ErrorAction Stop
            
    } else {
        # Per-machine installation (all users)
        Write-Host "Registering for all users (requires admin)..." -ForegroundColor Gray
        
        # Stage the package
        Add-AppxPackage `
            -Path $PackagePath `
            -ExternalLocation $InstallPath `
            -ErrorAction Stop
            
        # Provision for all users
        Add-AppxProvisionedPackage `
            -Online `
            -PackagePath $PackagePath `
            -SkipLicense `
            -ErrorAction Stop
    }
    
    Write-Host "Package registered successfully!" -ForegroundColor Green
    
} catch {
    Write-Error "Registration failed: $_"
    Write-Host "`nCommon issues:" -ForegroundColor Yellow
    Write-Host "- Certificate not trusted (for self-signed dev certs)" -ForegroundColor Gray
    Write-Host "- Package already exists with different version" -ForegroundColor Gray
    Write-Host "- Missing admin rights (for PerMachine)" -ForegroundColor Gray
    exit 1
}

# Verify registration
Write-Host "`nStep 2: Verifying registration..." -ForegroundColor Yellow

$registeredPackage = Get-AppxPackage -Name $PackageName
if ($registeredPackage) {
    Write-Host "Package found in system:" -ForegroundColor Green
    Write-Host "  Name: $($registeredPackage.Name)" -ForegroundColor Gray
    Write-Host "  Version: $($registeredPackage.Version)" -ForegroundColor Gray
    Write-Host "  InstallLocation: $($registeredPackage.InstallLocation)" -ForegroundColor Gray
    Write-Host "  PackageFullName: $($registeredPackage.PackageFullName)" -ForegroundColor Gray
    
    # Check if in notifications list
    $notifSettings = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name $PackageName -ErrorAction SilentlyContinue
    if ($notifSettings) {
        Write-Host "App appears in Windows Notification Settings ✓" -ForegroundColor Green
    } else {
        Write-Host "App should appear in Notification Settings after first use" -ForegroundColor Yellow
    }
    
} else {
    Write-Error "Verification failed - package not found after registration!"
    exit 1
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Registration complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nYour app can now use:" -ForegroundColor White
Write-Host "  ✓ Toast Notifications" -ForegroundColor Green
Write-Host "  ✓ Action Buttons" -ForegroundColor Green
Write-Host "  ✓ Progress Notifications" -ForegroundColor Green
Write-Host "  ✓ Live Tiles (if implemented)" -ForegroundColor Green
Write-Host "`nTo test, run your Java application with the WinRT DLL." -ForegroundColor Gray

# Return success
exit 0
