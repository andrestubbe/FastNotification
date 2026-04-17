# FastNotification Installer Components

## Overview

These files are used by the **installer** (MSI/EXE) to register FastNotification 
for Windows Toast notifications. **End users should never run these manually.**

## Files

| File | Purpose | When Used |
|------|---------|-----------|
| `register-app.reg` | Windows Registry entries | Imported by installer |
| `install.ps1` | PowerShell setup script | Run by installer |
| `README.md` | Documentation | For developers only |

## Why Registry?

Windows 10/11 requires apps to be registered before showing Toast notifications:
- **AppUserModelId** — Unique app identifier
- **DisplayName** — Name shown in notification settings  
- **IconUri** — Custom app icon (replaces Windows logo)
- **Start Menu Shortcut** — Required for Toast API

## User Experience

```
User runs:  FastNotification-Setup.exe
           ↓
Installer: Extracts DLL → Creates registry entries → Creates shortcut
           ↓  
Result:    FastNotification Java API works immediately with native Toasts
```

## Manual Testing (Developers Only)

If you want to test without building an installer:

```powershell
# Run as Administrator
.\installer\install.ps1 -InstallPath "C:\Your\Path"
```

Then restart your Java application.

## Troubleshooting

**"Notifications not showing"**
- Check if shortcut exists in Start Menu
- Verify registry entry: `HKCU\Software\Classes\AppUserModelId\FastNotification`
- Restart Windows Explorer or log out/in

**"Showing Windows logo instead of my icon"**
- Icon file must exist at path specified in registry
- Use absolute paths (not relative)
- Supported formats: PNG, ICO

## Production Deployment

For production MSI/EXE installers, integrate these scripts:
- **WiX Toolset**: Use `<RegistryKey>` and `<Shortcut>` elements
- **Inno Setup**: Use `[Registry]` and `[Icons]` sections  
- **NSIS**: Use `WriteRegStr` and `CreateShortcut`

See Microsoft documentation: 
https://docs.microsoft.com/en-us/windows/apps/design/shell/tiles-and-notifications/send-local-toast
