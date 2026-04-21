# Windows 11/10 Toast Notification Guide for Desktop Apps

## Overview

Windows 11/10 offers **3 ways** for Desktop Apps to show Toast Notifications:

| Method | Effort | Works | Recommended for |
|---------|---------|--------------|---------------|
| **A. MSIX Full Package** (Microsoft Store) | High | ✅ Fully | Store Publishing |
| **B. Sparse Package** (External Location) | Medium | ✅ Fully | Enterprise/Custom Installer |
| **C. COM Balloon (Legacy)** | Low | ⚠️ Fallback | Simple Integration |

---

## Option A: Full MSIX Package (Microsoft Store)

### What is this?
App is fully packaged in MSIX container and distributed via Microsoft Store or sideloading.

### Advantages
- ✅ All Windows features immediately available
- ✅ Automatic updates via Store
- ✅ Sandboxing & Security

### Disadvantages
- ❌ Filesystem and Registry access restricted
- ❌ Java JVM must be included in package (large!)
- ❌ Complex build process

### Effort
| Step | Time | Description |
|---------|------|--------------|
| Create MSIX Manifest | 2-4h | XML with App Identity |
| Package JVM + JAR | 1-2h | ~200MB Package Size |
| Buy Certificate | 1-3 days | Code-Signing for Store |
| Store Submission | 1-7 days | Microsoft Review |
| **Total** | **3-10 days** | |

### Required
- Code-Signing Certificate (~$100-400/year)
- Windows 10/11 SDK
- MSIX Packaging Tool

---

## Option B: Sparse Package (Identity + External Location) ⭐ RECOMMENDED

### What is this?
A minimal MSIX package (only identity, ~50KB) is registered. Your app stays at original location (e.g., `C:\Program Files\FastNotification`).

### Advantages
- ✅ All Windows features available
- ✅ App stays unchanged (no container)
- ✅ Easier than Full MSIX
- ✅ Works with existing installer (WiX, Inno, NSIS)

### Disadvantages
- ⚠️ Code-Signing certificate needed (can be self-signed for internal apps)
- ⚠️ One registration per user/machine needed

### Effort
| Step | Time | Description |
|---------|------|--------------|
| Create Manifest | 30min | Use our template |
| Sign Package | 30min | With certificate |
| Adapt Installer | 1h | PowerShell registration |
| **Total** | **2-3 Hours** | |

### What you need
1. **App Identity** (Name, Publisher, Version)
2. **Code-Signing Certificate** (can be self-signed for development)
3. **Icons** (44x44, 150x150, Store logo)
4. **Installer Integration** (see `register-sparse.ps1`)

### Our Templates
- `installer\sparse-manifest.xml` - Ready manifest
- `installer\register-sparse.ps1` - Registration in installer
- `installer\create-package.ps1` - Create & sign package

---

## Option C: COM Balloon (Legacy)

### What is this?
Uses the old `Shell_NotifyIcon` API for tray balloons (not modern toasts).

### Advantages
- ✅ Works immediately
- ✅ No registration needed
- ✅ Works on Windows 7/8/10/11

### Disadvantages
- ❌ Shows balloon, not modern toast
- ❌ On Windows 11 balloons are often suppressed
- ❌ No action buttons
- ❌ No progress bars
- ❌ Shows Windows logo instead of app icon

### Effort
| Step | Time | Description |
|---------|------|--------------|
| Include DLL | 5min | Use `FastNotification_COM.dll` |
| **Total** | **5 Minutes** | |

### When to use?
- Quick prototype
- Internal tools
- Windows 7/8 compatibility

---

## Decision Guide

```
Want to publish in Microsoft Store? ──YES──→ Option A: Full MSIX
                                    │
                                    └─NO──┬─ Enterprise/Environment with PKI? ──YES──→ Option B: Sparse Package
                                          │
                                          └─ Quick & simple? ──YES──→ Option C: COM Balloon
```

### For FastNotification Products

| Product Type | Recommended Option |
|-------------|-------------------|
| **Open Source Library** | B (Sparse) - full features, easy for users |
| **Enterprise Tool** | B (Sparse) - MSI integration |
| **Microsoft Store App** | A (Full MSIX) |
| **Quick Prototype** | C (COM) - test immediately |

---

## Technical Details

### AppUserModelID (AUMID)
The unique identity of your app:
```
[Company].[AppName][.OptionalSuffix]
Example: "AndreStubbe.FastNotification.v1"
```

Must be consistent in:
- MSIX Manifest (Name)
- Start Menu Shortcut (System.AppUserModel.ID)
- Java Code (optional, if used)

### COM Toast Activator (only for WinRT/Sparse)
For action buttons in toasts you need:
- A COM server with GUID
- Registration in Registry (LocalServer32)
- Implementation of `INotificationActivationCallback` interface

See: `FastNotification.cpp` (WinRT Version)

### Certificates

| Type | Price | Validity | Usage |
|-----|-------|------------|---------|
| **Self-signed** | Free | Local/Development | Only on your PC |
| **Enterprise CA** | Internal Cost | Domain | Company Network |
| **Commercial** | $100-400/year | Global | All Windows PCs |

Recommended providers: DigiCert, Sectigo (Comodo), GlobalSign

---

## Troubleshooting

### "Notifications don't appear"
1. Check Windows Settings → System → Notifications
2. Is your app in the list? If no → Registration failed
3. Focus Assist active? → Disable

### "Shows Windows logo instead of my icon"
- Check icon paths in manifest
- Images must be present in package/install folder
- Formats: PNG with transparency

### "App not in notification settings"
- Start menu shortcut missing or has wrong AUMID
- MSIX package not registered

---

## Next Steps

### For Sparse Package (Recommended):
1. Get certificate (or create self-signed)
2. Adapt `installer\sparse-manifest.xml` (Name, Publisher)
3. Place icons in `installer\Assets\`
4. Run `create-package.ps1`
5. Integrate package in your installer (`register-sparse.ps1`)

### For Full MSIX:
1. Install MSIX Packaging Tool
2. Create Application Packaging Project in Visual Studio
3. Include all dependencies (JVM, JARs)
4. Prepare Store publishing

### For COM Balloon:
1. Use `compile.bat` (automatically builds COM version)
2. Test if balloons appear in your Windows version

---

**Microsoft Documentation:**
- [Send Toast from Desktop C++](https://learn.microsoft.com/en-us/windows/apps/design/shell/tiles-and-notifications/send-local-toast-desktop-cpp-wrl)
- [Grant Identity via Sparse Package](https://learn.microsoft.com/en-us/windows/apps/desktop/modernize/grant-identity-to-nonpackaged-apps)
- [AppUserModelID Registration](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/hh802762(v=vs.85))
