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

FastNotifications solves this with:
- **Native OS integration** — Real Windows 11 WinRT Toasts
- **Custom app icons** — Your logo, not Java's
- **Rich features** — Action buttons, progress bars, urgency levels, sounds
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

## Quick Start

### Basic Notification

```java
import fastnotifications.FastNotifications;

// Simple native toast
FastNotifications.notify("Hello World", "This is a native notification!");
```

### Builder API

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

### Progress Notification

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
│   ├── FastNotification.cpp       # WinRT implementation
│   ├── FastNotification.h         # C++ header
│   ├── FastNotification.def       # JNI exports (REQUIRED!)
│   └── FastNotification.dll       # Built native library
├── src/main/java/fastnotifications/
│   ├── FastNotifications.java       # Main API
│   ├── ProgressNotification.java    # Progress toasts
│   ├── Demo.java                    # Example usage
│   └── integrations/
│       └── FastRobotDebug.java      # FastRobot integration
├── compile.bat                      # Native build script
├── COMPILE.md                       # Build instructions
├── pom.xml                          # Maven config
└── README.md                        # This file
```

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
