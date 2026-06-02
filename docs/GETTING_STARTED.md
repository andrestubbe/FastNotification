# Getting Started with FastNotification

## Quick Start (5 Minutes)

### 1. Download & Extract
```bash
git clone https://github.com/andrestubbe/FastNotification.git
cd FastNotification
```

### 2. Compile Native DLL
```bash
# Windows: run compile.bat
compile.bat
```

> **Note:** Requires Visual Studio 2022 (free). Alternatively: Use pre-compiled DLL from Releases.

### 3. Compile Java Code
```bash
mvn clean compile
```

### 4. Run Demo
```bash
java --% -cp "target\classes" -Djava.library.path="native" --enable-native-access=ALL-UNNAMED fastnotifications.Demo
```

---

## What You Should See

### When everything works:
Windows shows **3 notifications** in sequence:
1. Simple notification
2. Notification with icon  
3. Notification with Builder pattern

### If nothing appears:
This is **normal** on Windows 10/11! Microsoft has restricted notifications for Desktop Apps.

**See solution below:** [Choose Level 1, 2, or 3](#choose-level)

---

## Choose Level

FastNotification offers **3 integration levels** for different requirements:

```
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 1: Test immediately (30 seconds)                    │
│  ─────────────────────────────────                          │
│  • Balloon-style notifications                              │
│  • Works immediately, no setup required                     │
│  • Windows 11 sometimes hides these                       │
│                                                              │
│  Code: FastNotifications.notify("Title", "Message");         │
└─────────────────────────────────────────────────────────────┘
                              ↓ (need more?)
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 2: Production-ready (2 hours setup)                  │
│  ────────────────────────────────────────                   │
│  • Modern toast notifications                               │
│  • Action buttons, progress bars                            │
│  • Real installer required (Sparse Package)                 │
│                                                              │
│  See: installer/WINDOWS_NOTIFICATION_GUIDE.md             │
└─────────────────────────────────────────────────────────────┘
                              ↓ (need more?)
┌─────────────────────────────────────────────────────────────┐
│  LEVEL 3: Microsoft Store (3-10 days)                       │
│  ───────────────────────────────────                        │
│  • Full Store integration                                   │
│  • Automatic updates                                        │
│  • Code-signing certificate required                        │
│                                                              │
│  See: Microsoft Store Developer Documentation               │
└─────────────────────────────────────────────────────────────┘
```

### Recommendation:
- **Prototype/Internal:** Level 1
- **Tool for customers:** Level 2
- **Store distribution:** Level 3

---

## Level 1: Quick Start

### Java Code
```java
import fastnotifications.FastNotifications;

public class MyApp {
    static {
        // Load DLL (Windows)
        System.loadLibrary("FastNotification");
    }
    
    public void showNotification() {
        // Simple notification
        FastNotifications.notify("Hello", "This is a test!");
        
        // With tag (replaces old with same tag)
        FastNotifications.notifyTagged("update-1", "Download", "50% complete...");
        
        // Update after 2 seconds
        Thread.sleep(2000);
        FastNotifications.notifyTagged("update-1", "Download", "100% complete!");
    }
}
```

### What the User Sees
- **Windows 10:** Balloon in system tray (bottom right)
- **Windows 11:** May be disabled (see Troubleshooting)

> ⚠️ **Windows 11 often hides balloon notifications.** This is not a bug, it's Microsoft's design decision.

---

## Level 2: Modern Toasts

For **full modern notifications** (like Outlook/Teams):

### Step 1: Create Sparse Package (one-time)
```powershell
# As Administrator:
cd installer
.\create-package.ps1 -SelfSigned
.\register-sparse.ps1 -InstallPath "C:\Program Files\YourApp"
```

### Step 2: Build WinRT DLL
```bash
# Edit compile.bat: Select WinRT instead of COM
# Line 45: Change SOURCE_FILE to FastNotification.cpp
compile.bat
```

### Step 3: Use Action Buttons
```java
Notification.builder("Download")
    .message("File is downloading...")
    .tag("download-123")
    .actions(Arrays.asList(
        new Action("Cancel", () -> cancelDownload()),
        new Action("Pause", () -> pauseDownload())
    ))
    .show();
```

**Details:** See `installer/WINDOWS_NOTIFICATION_GUIDE.md`

---

## Troubleshooting

### "Nothing appears"

#### Check 1: Windows Settings
```
Settings → System → Notifications
→ "Get notifications" must be ON
→ Focus Assist must be OFF
```

#### Check 2: Silent Mode
Windows 11 has a "Silent Mode" that blocks all notifications:
```
Taskbar → Clock → Right-click → Check "Do not disturb"
```

#### Check 3: App Registration (for Level 2)
```powershell
# Check if package is registered
Get-AppxPackage | Where-Object { $_.Name -like "*FastNotification*" }

# If not: Register
Add-AppxPackage -Path "FastNotification-Identity.msix" -ExternalLocation "C:\YourPath"
```

### "DLL not found"
```bash
# Check Java argument:
-Djava.library.path="native"

# Or copy DLL to System32 (not recommended):
copy native\FastNotification.dll C:\Windows\System32\
```

### "Access Denied" when registering
Sparse Package requires **Administrator rights** for installation.

---

## FAQ

**Q: Why so complicated?**  
A: Microsoft wants everyone on the Microsoft Store. Therefore, extra hurdles for Desktop Apps.

**Q: Does this work on Mac/Linux?**  
A: No, only Windows. Native features require native code.

**Q: Do I need an installer?**  
A: For Level 1 (testing): No. For Level 2 (production): Yes, but only for the one-time registration.

**Q: What's the difference from JavaFX Notifications?**  
A: JavaFX shows notifications within the app. FastNotification shows native Windows notifications (even when app is minimized).

---

## Next Steps

1. **Now:** Try Level 1 (run `Demo.java`)
2. **Immediately:** Check if balloons appear
3. **Later:** Upgrade to Level 2 for production

**Help:** [GitHub Issues](https://github.com/andrestubbe/FastNotification/issues)
