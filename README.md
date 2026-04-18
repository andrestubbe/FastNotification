# FastNotifications — Native Windows 11 Toast Notifications for Java

**⚡ Ultra-fast native Java notifications — Replace ugly Java SystemTray with real OS-native Toasts**

[![Build](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Java](https://img.shields.io/badge/Java-17+-blue.svg)](https://www.java.com)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%2B-lightgrey.svg)]()
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![JitPack](https://jitpack.io/v/andrestubbe/FastNotification.svg)](https://jitpack.io/#andrestubbe/FastNotification)
[![GitHub stars](https://img.shields.io/github/stars/andrestubbe/FastNotification.svg)](https://github.com/andrestubbe/FastNotification/stargazers)

```java
// Quick Start — Native Windows 11 Toast
FastNotifications.notify("Build finished", "FastImage compiled in 42ms");

// Full control — Custom icon, action buttons, urgency
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

> **Powered by FastCore** — Part of the FastJava ecosystem for native JVM acceleration.

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
- **Ugly** — Always shows the Java coffee cup icon
- **Limited** — No action buttons, no progress bars, no priorities
- **Deprecated** — Uses old balloon API on Windows
- **Inconsistent** — Looks different on every OS

**Plus:** Windows 10/11 requires app registration for modern notifications — FastNotifications handles this with **3 integration levels**:

| Level | Effort | Result |
|-------|--------|--------|
| **Level 1** (5 min) | Build DLL → Run | Basic notifications (Balloon) |
| **Level 2** (2 hrs) | + Sparse Package | Full WinRT Toasts (like Teams) |
| **Level 3** (3-10 days) | + MSIX + Store | Store distribution |

FastNotifications solves this with:
- **Flexible integration** — Choose your setup level
- **Native OS integration** — Real Windows 11 WinRT Toasts (Level 2+)
- **Custom app icons** — Your logo, not Java's
- **Rich features** — Action buttons, progress bars, urgency levels (Level 2+)
- **JNI-powered** — Direct OS API access, zero Java UI overhead

---

## Key Features

- **Windows 11 Native Toasts** — WinRT XML-based with full customization
- **Custom App Icons** — Replace the ugly Java coffee cup
- **Action Buttons** — "Open", "Dismiss", custom callbacks
- **Progress Notifications** — Download/install progress bars
- **Urgency Levels** — Low, Normal, High, Critical
- **Zero Dependencies** — Pure JNI, no JavaFX, no Swing, no AWT

---

## FastNotifications vs SystemTray

| Feature | SystemTray | FastNotifications |
|---------|------------|-------------------|
| Icon | ❌ Java coffee cup | ✅ Your custom icon |
| Windows 11 style | ❌ Deprecated balloon | ✅ Native WinRT Toast |
| Action buttons | ❌ None | ✅ Custom buttons |
| Progress bars | ❌ None | ✅ Native progress |
| Urgency/Priority | ❌ None | ✅ High, Critical |

---

## Installation

### Maven

```xml
<repositories>
    <repository>
        <id>jitpack.io</id>
        <url>https://jitpack.io</url>
    </repository>
</repositories>

<dependency>
    <groupId>com.github.andrestubbe</groupId>
    <artifactId>fastnotification</artifactId>
    <version>v1.0.0</version>
</dependency>
```

### Gradle

```groovy
repositories {
    maven { url 'https://jitpack.io' }
}

dependencies {
    implementation 'com.github.andrestubbe:fastnotification:v1.0.0'
}
```

---

## Quick Start — Choose Your Setup Level

FastNotification offers **3 integration levels** for different needs:

| Level | Setup Time | Features | Best For |
|-------|-----------|----------|----------|
| **Level 1** | 5 minutes | Basic notifications (Balloon style) | Testing, internal tools |
| **Level 2** | 2 hours | Full Windows 11 Toasts with actions | Production apps |
| **Level 3** | 3-10 days | Microsoft Store integration | Store distribution |

### Level 1 — Quick Test (5 min)

```bash
# 1. Build native DLL
compile.bat

# 2. Compile Java
mvn compile

# 3. Run demo
java --% -cp "target\classes" -Djava.library.path="native" --enable-native-access=ALL-UNNAMED fastnotifications.Demo
```

```java
// Simple code
FastNotifications.notify("Hello", "From Java!");
```

> ⚠️ **Note:** Windows 10/11 may hide balloon notifications. This is Microsoft's design, not a bug. See [Level 2](#level-2--production-setup) for full toasts.

### Level 2 — Production Setup (2 hours)

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

📖 **Details:** See `installer/WINDOWS_NOTIFICATION_GUIDE.md`

### Level 3 — Microsoft Store

For Store distribution with auto-updates:

- Full MSIX packaging required
- Code-signing certificate needed
- Store submission process

📖 **Details:** See Microsoft Store developer documentation

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
| `notify(title, message)` | Simple toast notification | ✅ Working |
| `notify(title, message, icon)` | Toast with custom icon | ✅ Working |
| `notifyTagged(tag, title, message)` | Tagged notification (replaces existing) | ✅ Working |
| `notifyTagged(tag, title, message, icon)` | Tagged with icon | ✅ Working |
| `builder()` | Create advanced notification | ✅ Working |
| `progress(title, message)` | Progress notification | 🚧 Planned |

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
// - "🖱️ Click #1 at (500, 300)"
// - "⌨️ Key #5: Pressed: ENTER"
// - "📸 Screen Capture: 1920x1080 in 12ms"

// Show session summary
FastRobotDebug.showSummary();
```

See [FastRobotDebug.java](src/main/java/fastnotifications/integrations/FastRobotDebug.java) for full API.

---

## Build from Source

### Prerequisites

- Java 17+
- Maven 3.8+
- Visual Studio 2022 (Windows)

### Build

```bash
git clone https://github.com/andrestubbe/FastNotification.git
cd FastNotification

mvn clean compile
mvn test
mvn package
```

---

## Platform Support

| Platform | Version | Status | Notes |
|----------|---------|--------|-------|
| Windows 11 | v1.0 | ✅ Full support | WinRT Toast XML, all features |
| Windows 10 | v1.0 | ⚠️ Partial | Requires v1903+, some features limited |
| macOS | — | ❌ Not planned | Use native macOS notifications |
| Linux | — | ❌ Not planned | Use DBus directly |

**Windows-only by design** — We focus on maximum performance on the most common platform.

---

## Architecture

```
fastnotifications (Java API)
    ↓ JNI
native/FastNotification.dll (C++/WinRT)
    ↓ Windows Runtime
Windows.UI.Notifications (WinRT)
    ↓
Windows 11 Notification Center
```

**Key Technologies:**
- **JNI** — Java-to-native bridge
- **WinRT** — Windows Runtime API for Toasts
- **FastCore** — Native library loading (optional dependency)

---

## Project Structure

```
FastNotification/
├── native/
│   ├── FastNotification.cpp         # WinRT implementation (Level 2+)
│   ├── FastNotification_COM.cpp     # COM implementation (Level 1)
│   ├── FastNotification.h           # C++ header
│   ├── FastNotification.def         # JNI exports (REQUIRED!)
│   └── FastNotification.dll         # Built native library
├── src/main/java/fastnotifications/
│   ├── FastNotifications.java       # Main API
│   ├── ProgressNotification.java    # Progress toasts
│   ├── Demo.java                    # Example usage
│   └── integrations/
│       └── FastRobotDebug.java      # FastRobot integration
├── installer/
│   ├── WINDOWS_NOTIFICATION_GUIDE.md  # Windows architecture guide
│   ├── sparse-manifest.xml            # Sparse package template
│   ├── create-package.ps1             # Package builder script
│   ├── register-sparse.ps1            # Registration script
│   ├── register-app.reg               # Registry entries
│   └── install.ps1                    # Setup automation
├── compile.bat                      # Native build script
├── COMPILE.md                       # Build instructions
├── GETTING_STARTED.md               # Quick start guide
├── REACTION.md                      # Developer notes
├── pom.xml                          # Maven config
└── README.md                        # This file
```

---

## Documentation

| Document | Purpose |
|----------|---------|
| [`GETTING_STARTED.md`](GETTING_STARTED.md) | Quick setup guide with 3 integration levels |
| [`installer/WINDOWS_NOTIFICATION_GUIDE.md`](installer/WINDOWS_NOTIFICATION_GUIDE.md) | Windows notification architecture & decision guide |
| [`COMPILE.md`](COMPILE.md) | Detailed build instructions for native DLL |

**Quick Navigation:**
- Just want to test? → [Level 1 in GETTING_STARTED.md](GETTING_STARTED.md#level-1--quick-test-5-min)
- Building for production? → [Level 2 in GETTING_STARTED.md](GETTING_STARTED.md#level-2--production-setup-2-hours)
- Understanding Windows quirks? → [WINDOWS_NOTIFICATION_GUIDE.md](installer/WINDOWS_NOTIFICATION_GUIDE.md)

---

## License

MIT License — See [LICENSE](LICENSE) for details.

---

**FastNotifications** — *Part of the FastJava Ecosystem*  
- [FastCore](https://github.com/andrestubbe/FastCore) — JNI loader  
- [FastRobot](https://github.com/andrestubbe/FastRobot) — Ultra-fast automation  
- More at [github.com/andrestubbe](https://github.com/andrestubbe)

---

## Related Projects

- [FastRobot](https://github.com/andrestubbe/FastRobot) — Ultra-fast screen capture & automation
- [FastTheme](https://github.com/andrestubbe/FastTheme) — OS-aware theme detection
- [FastHotkey](https://github.com/andrestubbe/FastHotkey) — Global system hotkeys
- [FastClipboard](https://github.com/andrestubbe/FastClipboard) — Native clipboard access

---

## Keywords

**SEO Tags:** java notifications, windows toast java, java system tray alternative, native notifications java, winrt toast java, jni notifications, java desktop notifications, java notification library, java windows 11 toast, java winrt notifications
