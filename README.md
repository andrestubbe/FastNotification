# FastNotification â€” Native Windows toast notifications for Java [ALPHA] - v0.1.0
**âš¡ Ultra-fast native Java notifications â€” Replace ugly Java SystemTray with real OS-native Toasts**

[![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Java](https://img.shields.io/badge/Java-17+-blue.svg)](https://www.java.com)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2B-lightgrey.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![JitPack](https://jitpack.io/v/andrestubbe/FastNotification.svg)](https://jitpack.io/#andrestubbe/FastNotification)
[![GitHub stars](https://img.shields.io/github/stars/andrestubbe/FastNotification.svg)](https://github.com/andrestubbe/FastNotification/stargazers)

```java
// Quick Start â€” Native Windows 11 Toast
FastNotifications.notify("Build finished", "FastImage compiled in 42ms");

// Full control â€” Custom icon, action buttons, urgency
FastNotifications.builder()
    .title("Download complete")
    .message("File saved to /downloads")
    .icon("fastjava.png")           // Your app icon, not Java coffee cup
    .urgency(Urgency.HIGH)
    .action("Open", this::openFile)
    .action("Dismiss", null)
    .timeout(Duration.seconds(5))
    .show();
```

**FastNotifications** is a **high-performance native notification library for Java** that replaces the ugly, limited `java.awt.SystemTray` with **real OS-native notifications**. Built for **Windows 11 native WinRT Toasts** with full customization.

> **Powered by FastCore** â€” Part of the FastJava ecosystem for native JVM acceleration.

**Keywords:** java notifications, windows toast java, java system tray alternative, native notifications java, winrt toast java, jni notifications, cross platform notifications java, java desktop notifications, java notification library

---

## Table of Contents

- [Why FastNotifications?](#why-fastnotifications)
- [Key Features](#key-features)
- [FastNotifications vs SystemTray](#fastnotifications-vs-systemtray)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
- [Integrations](#integrations)
- [Build from Source](#build-from-source)
- [Platform Support](#platform-support)
- [Project Structure](#project-structure)
- [License](#license)

---

## Why FastNotifications?

`java.awt.SystemTray` notifications are:
- **Ugly** â€” Always shows the Java coffee cup icon
- **Limited** â€” No action buttons, no progress bars, no priorities
- **Deprecated** â€” Uses old balloon API on Windows
- **Inconsistent** â€” Looks different on every OS

**Plus:** Windows 10/11 requires app registration for modern notifications â€” FastNotifications handles this with **3 integration levels**:

| Level | Effort | Result |
|-------|--------|--------|
| **Level 1** (5 min) | Build DLL â†’ Run | Basic notifications (Balloon) |
| **Level 2** (2 hrs) | + Sparse Package | Full WinRT Toasts (like Teams) |
| **Level 3** (3-10 days) | + MSIX + Store | Store distribution |

FastNotifications solves this with:
- **Flexible integration** â€” Choose your setup level
- **Native OS integration** â€” Real Windows 11 WinRT Toasts (Level 2+)
- **Custom app icons** â€” Your logo, not Java's
- **Rich features** â€” Action buttons, progress bars, urgency levels (Level 2+)
- **JNI-powered** â€” Direct OS API access, zero Java UI overhead

---

## Key Features

- **Windows 11 Native Toasts** â€” WinRT XML-based with full customization
- **Custom App Icons** â€” Replace the ugly Java coffee cup
- **Action Buttons** â€” "Open", "Dismiss", custom callbacks
- **Progress Notifications** â€” Download/install progress bars
- **Urgency Levels** â€” Low, Normal, High, Critical
- **Zero Dependencies** â€” Pure JNI, no JavaFX, no Swing, no AWT

---

## FastNotifications vs SystemTray

| Feature | SystemTray | FastNotifications |
|---------|------------|-------------------|
| Icon | âŒ Java coffee cup | âœ… Your custom icon |
| Windows 11 style | âŒ Deprecated balloon | âœ… Native WinRT Toast |
| Action buttons | âŒ None | âœ… Custom buttons |
| Progress bars | âŒ None | âœ… Native progress |
| Urgency/Priority | âŒ None | âœ… High, Critical |

---

## Installation

### Option 1: Maven (Recommended)
Add the JitPack repository and the dependencies to your `pom.xml`:

```xml
<repositories>
    <repository>
        <id>jitpack.io</id>
        <url>https://jitpack.io</url>
    </repository>
</repositories>

<dependencies>
    <!-- FastNotification Library -->
    <dependency>
        <groupId>com.github.andrestubbe</groupId>
        <artifactId>fastnotification</artifactId>
        <version>v0.1.0</version>
    </dependency>

    <!-- FastCore (Required Native Loader) -->
    <dependency>
        <groupId>com.github.andrestubbe</groupId>
        <artifactId>fastcore</artifactId>
        <version>v0.1.0</version>
    </dependency>
</dependencies>
```

### Option 2: Gradle (via JitPack)
```groovy
repositories {
    maven { url 'https://jitpack.io' }
}

dependencies {
    implementation 'com.github.andrestubbe:fastnotification:v0.1.0'
    implementation 'com.github.andrestubbe:fastcore:v0.1.0'
}
```

### Option 3: Direct Download (No Build Tool)
Download the latest JARs directly to add them to your classpath:

1. 📦 **[fastnotification-v0.1.0.jar](https://github.com/andrestubbe/FastNotification/releases/download/v0.1.0/fastnotification-v0.1.0.jar)** (The Core Library)
2. ⚙️ **[fastcore-v0.1.0.jar](https://github.com/andrestubbe/FastCore/releases/download/v0.1.0/fastcore-v0.1.0.jar)** (The Mandatory Native Loader)

> [!IMPORTANT]
> All JARs must be in your classpath for the native JNI calls to function correctly.


## Quick Start â€” Choose Your Setup Level

FastNotification offers **3 integration levels** for different needs:

| Level | Setup Time | Features | Best For |
|-------|-----------|----------|----------|
| **Level 1** | 5 minutes | Basic notifications (Balloon style) | Testing, internal tools |
| **Level 2** | 2 hours | Full Windows 11 Toasts with actions | Production apps |
| **Level 3** | 3-10 days | Microsoft Store integration | Store distribution |

### Level 1 â€” Quick Test (5 min)

```bash
# 1. Build native DLL [ALPHA] - v0.1.0
compile.bat

# 2. Compile Java [ALPHA] - v0.1.0
mvn compile

# 3. Run demo [ALPHA] - v0.1.0
java --% -cp "target\classes" -Djava.library.path="native" --enable-native-access=ALL-UNNAMED fastnotifications.Demo
```

```java
// Simple code
FastNotifications.notify("Hello", "From Java!");
```

> âš ï¸ **Note:** Windows 10/11 may hide balloon notifications. This is Microsoft's design, not a bug. See [Level 2](#level-2--production-setup) for full toasts.

### Level 2 â€” Production Setup (2 hours)

For **modern WinRT Toasts** (like Outlook/Teams):

1. **Create identity package** (one-time setup)
   ```powershell
   cd installer
   .\create-package.ps1 -SelfSigned
   .\register-sparse.ps1 -InstallPath "C:\Program Files\YourApp"
   ```

2. **Build WinRT DLL**
   ```bash
   # Edit compile.bat: uncomment WinRT lines
   compile.bat
   ```

3. **Use full features**
   ```java
   FastNotifications.builder()
       .title("Download complete")
       .message("Ready to install")
       .icon("app.png")
       .action("Install", this::install)
       .action("Later", null)
       .show();
   ```

ðŸ“– **Details:** See `installer/WINDOWS_NOTIFICATION_GUIDE.md`

### Level 3 â€” Microsoft Store

For Store distribution with auto-updates:

- Full MSIX packaging required
- Code-signing certificate needed
- Store submission process

ðŸ“– **Details:** See Microsoft Store developer documentation

---

## Basic Usage Examples

### Simple Notification

```java
import fastnotifications.FastNotifications;

// Level 1 & 2: Works with both DLLs
FastNotifications.notify("Build finished", "Completed in 42ms");
```

### Tagged Notifications (Updates Existing)

```java
// Show progress that updates in place
FastNotifications.notifyTagged("download-1", "Downloading", "50%...");
Thread.sleep(2000);
FastNotifications.notifyTagged("download-1", "Downloading", "100% - Done!");
```

### Builder API (Level 2+)

```java
FastNotifications.builder()
    .title("Task Completed")
    .message("Backup finished successfully")
    .icon("myapp.png")
    .urgency(Urgency.NORMAL)
    .action("View Results", () -> openResults())
    .action("Close", null)
    .timeout(Duration.seconds(10))
    .show();
```

### Progress Notification (Level 2+)

```java
ProgressNotification progress = FastNotifications.progress(
    "Installing", 
    "FastCore 1.2.0"
);

for (int i = 0; i <= 100; i += 10) {
    progress.update(i);
    Thread.sleep(100);
}

progress.complete("Installation finished");
```

---

## API Reference

### Core Methods

| Method | Description | Status |
|--------|-------------|--------|
| `notify(title, message)` | Simple toast notification | âœ… Working |
| `notify(title, message, icon)` | Toast with custom icon | âœ… Working |
| `notifyTagged(tag, title, message)` | Tagged notification (replaces existing) | âœ… Working |
| `notifyTagged(tag, title, message, icon)` | Tagged with icon | âœ… Working |
| `builder()` | Create advanced notification | âœ… Working |
| `progress(title, message)` | Progress notification | ðŸš§ Planned |

### NotificationBuilder

| Method | Description |
|--------|-------------|
| `tag(String id)` | Unique identifier (replaces existing with same tag) |
| `title(String text)` | Notification title |
| `message(String text)` | Body text |
| `icon(String path)` | PNG icon path (replaces Java coffee cup) |
| `urgency(Urgency)` | LOW, NORMAL, HIGH, CRITICAL |
| `timeout(Duration)` | Auto-dismiss timeout |
| `action(String, Runnable)` | Add button with callback |
| `show()` | Display notification |

### Urgency Levels

| Level | Windows Behavior |
|-------|-----------------|
| `LOW` | Quiet notification, no sound |
| `NORMAL` | Standard toast |
| `HIGH` | Persistent, shows on lock screen |
| `CRITICAL` | Forces immediate attention |

---

## Integrations

### FastRobot Debug Mode

Enable real-time toast notifications for bot actions:

```java
import fastnotifications.integrations.FastRobotDebug;

// Enable debug notifications
FastRobotDebug.enable();

// Now all FastRobot actions show toast:
// - "ðŸ–±ï¸ Click #1 at (500, 300)"
// - "âŒ¨ï¸ Key #5: Pressed: ENTER"
// - "ðŸ“¸ Screen Capture: 1920x1080 in 12ms"

// Show session summary
FastRobotDebug.showSummary();
```

See [FastRobotDebug.java](src/main/java/fastnotifications/integrations/FastRobotDebug.java) for full API.

---

## Build from Source

See [COMPILE.md](COMPILE.md) for detailed build instructions.

---

## Platform Support

| Platform | Version | Status | Notes |
|----------|---------|--------|-------|
| Windows 11 | v1.0 | âœ… Full support | WinRT Toast XML, all features |
| Windows 10 | v1.0 | âš ï¸ Partial | Requires v1903+, some features limited |
| macOS | â€” | âŒ Not planned | Use native macOS notifications |
| Linux | â€” | âŒ Not planned | Use DBus directly |

**Windows-only by design** â€” We focus on maximum performance on the most common platform.

---

## Architecture

```
fastnotifications (Java API)
    â†“ JNI
native/FastNotification.dll (C++/WinRT)
    â†“ Windows Runtime
Windows.UI.Notifications (WinRT)
    â†“
Windows 11 Notification Center
```

**Key Technologies:**
- **JNI** â€” Java-to-native bridge
- **WinRT** â€” Windows Runtime API for Toasts
- **FastCore** â€” Native library loading (optional dependency)

---

## Project Structure

```
FastNotification/
â”œâ”€â”€ native/
â”‚   â”œâ”€â”€ FastNotification.cpp         # WinRT implementation (Level 2+)
â”‚   â”œâ”€â”€ FastNotification_COM.cpp     # COM implementation (Level 1)
â”‚   â”œâ”€â”€ FastNotification.h           # C++ header
â”‚   â”œâ”€â”€ FastNotification.def         # JNI exports (REQUIRED!)
â”‚   â””â”€â”€ FastNotification.dll         # Built native library
â”œâ”€â”€ src/main/java/fastnotifications/
â”‚   â”œâ”€â”€ FastNotifications.java       # Main API
â”‚   â”œâ”€â”€ ProgressNotification.java    # Progress toasts
â”‚   â”œâ”€â”€ Demo.java                    # Example usage
â”‚   â””â”€â”€ integrations/
â”‚       â””â”€â”€ FastRobotDebug.java      # FastRobot integration
â”œâ”€â”€ installer/
â”‚   â”œâ”€â”€ WINDOWS_NOTIFICATION_GUIDE.md  # Windows architecture guide
â”‚   â”œâ”€â”€ sparse-manifest.xml            # Sparse package template
â”‚   â”œâ”€â”€ create-package.ps1             # Package builder script
â”‚   â”œâ”€â”€ register-sparse.ps1            # Registration script
â”‚   â”œâ”€â”€ register-app.reg               # Registry entries
â”‚   â””â”€â”€ install.ps1                    # Setup automation
â”œâ”€â”€ compile.bat                      # Native build script
â”œâ”€â”€ GETTING_STARTED.md               # Quick start guide
â”œâ”€â”€ REACTION.md                      # Developer notes
â”œâ”€â”€ pom.xml                          # Maven config
â””â”€â”€ README.md                        # This file
```

---

## Documentation

| Document | Purpose |
|----------|---------|
| [`GETTING_STARTED.md`](GETTING_STARTED.md) | Quick setup guide with 3 integration levels |
| [`installer/WINDOWS_NOTIFICATION_GUIDE.md`](installer/WINDOWS_NOTIFICATION_GUIDE.md) | Windows notification architecture & decision guide |

**Quick Navigation:**
- Just want to test? â†’ [Level 1 in GETTING_STARTED.md](GETTING_STARTED.md#level-1--quick-test-5-min)
- Building for production? â†’ [Level 2 in GETTING_STARTED.md](GETTING_STARTED.md#level-2--production-setup-2-hours)
- Understanding Windows quirks? â†’ [WINDOWS_NOTIFICATION_GUIDE.md](installer/WINDOWS_NOTIFICATION_GUIDE.md)

---

## License

MIT License â€” See [LICENSE](LICENSE) for details.

---

**FastNotifications** â€” *Part of the FastJava Ecosystem*  
- [FastCore](https://github.com/andrestubbe/FastCore) â€” JNI loader  
- [FastRobot](https://github.com/andrestubbe/FastRobot) â€” Ultra-fast automation  
- More at [github.com/andrestubbe](https://github.com/andrestubbe)

---

## Related Projects

- [FastRobot](https://github.com/andrestubbe/FastRobot) â€” Ultra-fast screen capture & automation
- [FastTheme](https://github.com/andrestubbe/FastTheme) â€” OS-aware theme detection
- [FastHotkey](https://github.com/andrestubbe/FastHotkey) â€” Global system hotkeys
- [FastClipboard](https://github.com/andrestubbe/FastClipboard) â€” Native clipboard access

---

## Keywords

**SEO Tags:** java notifications, windows toast java, java system tray alternative, native notifications java, winrt toast java, jni notifications, java desktop notifications, java notification library, java windows 11 toast, java winrt notifications

