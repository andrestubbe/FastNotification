# Create Sparse Package for FastNotification
# 
# This script creates a signed MSIX package that provides identity without
# moving your app into a container.
#
# Requirements:
# - Windows 10/11 SDK (MakeAppx.exe, SignTool.exe)
# - Code-signing certificate (self-signed works for development)
#
# Usage:
#   .\create-package.ps1 -CertPath "C:\Certs\MyCert.pfx" -CertPassword "password"
#   .\create-package.ps1 -SelfSigned  # For development only

param(
    [string]$ManifestPath = ".\sparse-manifest.xml",
    [string]$AssetsPath = ".\Assets",
    [string]$OutputPath = ".\FastNotification-Identity.msix",
    [string]$CertPath = "",
    [string]$CertPassword = "",
    [switch]$SelfSigned,
    [string]$TempDir = "$env:TEMP\FastNotification-Package"
)

$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "FastNotification Sparse Package Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for Windows SDK
$makeAppx = Get-Command "MakeAppx.exe" -ErrorAction SilentlyContinue
if (-not $makeAppx) {
    # Try common SDK locations
    $sdkPaths = @(
        "${env:ProgramFiles(x86)}\Windows Kits\10\bin\10.0.26100.0\x64\MakeAppx.exe",
        "${env:ProgramFiles(x86)}\Windows Kits\10\bin\10.0.22621.0\x64\MakeAppx.exe",
        "${env:ProgramFiles(x86)}\Windows Kits\10\bin\10.0.22000.0\x64\MakeAppx.exe",
        "${env:ProgramFiles(x86)}\Windows Kits\10\bin\10.0.19041.0\x64\MakeAppx.exe"
    )
    
    foreach ($path in $sdkPaths) {
        if (Test-Path $path) {
            $makeAppx = Get-Command $path
            break
        }
    }
}

if (-not $makeAppx) {
    Write-Error "Windows SDK not found! Install Windows SDK from https://developer.microsoft.com/windows/downloads/windows-sdk/"
    exit 1
}

Write-Host "Using MakeAppx: $($makeAppx.Source)" -ForegroundColor Gray

# Clean temp directory
if (Test-Path $TempDir) {
    Remove-Item -Path $TempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

# Copy manifest and assets
Write-Host "`nStep 1: Preparing package contents..." -ForegroundColor Yellow
Copy-Item -Path $ManifestPath -Destination $TempDir\AppxManifest.xml -Force

if (Test-Path $AssetsPath) {
    Copy-Item -Path $AssetsPath -Destination $TempDir\Assets -Recurse -Force
} else {
    Write-Warning "Assets folder not found at $AssetsPath. Creating minimal placeholder."
    New-Item -ItemType Directory -Path $TempDir\Assets -Force | Out-Null
    # Create a minimal 44x44 and 150x150 placeholder (you should replace these)
    # For now, we'll proceed without them - Windows will show a default
}

# Create unsigned package
Write-Host "`nStep 2: Creating unsigned MSIX package..." -ForegroundColor Yellow
$makeAppxArgs = "pack /d `"$TempDir`" /p `"$OutputPath`" /o"
$process = Start-Process -FilePath $makeAppx.Source -ArgumentList $makeAppxArgs -Wait -PassThru -NoNewWindow

if ($process.ExitCode -ne 0) {
    Write-Error "MakeAppx failed! Check your manifest syntax."
    exit 1
}

Write-Host "Unsigned package created: $OutputPath" -ForegroundColor Green

# Signing
Write-Host "`nStep 3: Signing package..." -ForegroundColor Yellow

if ($SelfSigned) {
    Write-Host "Creating self-signed certificate for development..." -ForegroundColor Cyan
    
    # Create self-signed cert
    $certName = "FastNotification-DevCert"
    $certStore = "Cert:\CurrentUser\My"
    
    # Check if cert already exists
    $existingCert = Get-ChildItem $certStore | Where-Object { $_.Subject -eq "CN=AndreStubbe" }
    if ($existingCert) {
        Write-Host "Using existing certificate..." -ForegroundColor Gray
        $cert = $existingCert[0]
    } else {
        Write-Host "Generating new self-signed certificate..." -ForegroundColor Gray
        $cert = New-SelfSignedCertificate `
            -Type Custom `
            -Subject "CN=AndreStubbe" `
            -KeyUsage DigitalSignature `
            -FriendlyName "FastNotification Dev Certificate" `
            -CertStoreLocation $certStore `
            -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}Subject Type:End Entity")
        
        Write-Host "Certificate created: $($cert.Thumbprint)" -ForegroundColor Green
        Write-Host "`nIMPORTANT: Install this certificate to Trusted Root for testing!" -ForegroundColor Yellow
        Write-Host "   certmgr.msc -> Trusted Root Certification Authorities -> Import" -ForegroundColor Gray
    }
    
    # Sign the package
    $signTool = Join-Path (Split-Path $makeAppx.Source) "SignTool.exe"
    if (Test-Path $signTool) {
        & $signTool sign /fd SHA256 /a /f $certStore /s My /n "AndreStubbe" /t http://timestamp.digicert.com $OutputPath
    } else {
        # Use PowerShell signing as fallback
        Set-AuthenticodeSignature -FilePath $OutputPath -Certificate $cert -TimestampServer "http://timestamp.digicert.com"
    }
    
} elseif ($CertPath) {
    # Use provided certificate
    if (-not (Test-Path $CertPath)) {
        Write-Error "Certificate not found: $CertPath"
        exit 1
    }
    
    $signTool = Join-Path (Split-Path $makeAppx.Source) "SignTool.exe"
    if ($CertPassword) {
        & $signTool sign /fd SHA256 /f $CertPath /p $CertPassword /t http://timestamp.digicert.com $OutputPath
    } else {
        & $signTool sign /fd SHA256 /f $CertPath /t http://timestamp.digicert.com $OutputPath
    }
} else {
    Write-Warning "No certificate provided. Package created but NOT SIGNED."
    Write-Warning "You must sign before installation:"
    Write-Warning "   SignTool.exe sign /fd SHA256 /f MyCert.pfx /p password MyPackage.msix"
}

# Cleanup
Remove-Item -Path $TempDir -Recurse -Force

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Package created successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Output: $OutputPath" -ForegroundColor White
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Test install: Add-AppxPackage -Path $OutputPath -ExternalLocation 'C:\Program Files\FastNotification'" -ForegroundColor Gray
Write-Host "2. Integrate into your installer (see register-sparse.ps1)" -ForegroundColor Gray
Write-Host "3. Distribute .msix alongside your application" -ForegroundColor Gray
