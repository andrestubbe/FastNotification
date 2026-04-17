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

**Keywords:** java notifications, windows toast java, java system tray alternative, native notifications java, winrt toast java, jni notifications, cross platform notifications java, java desktop notifications, java notification library

---

## Table of Contents

- [Why FastNotifications?](#why-fastnotifications)
- [Key Features](#key-features)
- [FastNotifications vs SystemTray](#fastnotifications-vs-systemtray)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
- [Platform Features](#platform-features)
- [Build from Source](#build-from-source)
- [Platform Support](#platform-support)
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

### Static Methods

- `notify(String title, String message)` — Simple notification
- `notify(String title, String message, String iconPath)` — With custom icon
- `builder()` — Create a NotificationBuilder
- `progress(String title, String message)` — Create progress notification

### NotificationBuilder

- `title(String title)` — Notification title
- `message(String message)` — Body text
- `icon(String path)` — Path to icon image (PNG recommended)
- `urgency(Urgency level)` — LOW, NORMAL, HIGH, CRITICAL
- `timeout(Duration duration)` — Auto-dismiss timeout
- `action(String label, Runnable callback)` — Add action button
- `show()` — Display the notification

### ProgressNotification

- `update(int percent)` — Update progress (0-100)
- `update(int percent, String message)` — Update with new message
- `complete(String message)` — Mark as complete
- `dismiss()` — Close notification

---

## Platform Features

### Windows 11

- Toast XML templates
- AppLogoOverride (custom icon)
- Progress bars
- Action buttons
- Inline images
- Deep links


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

| Platform | Version | Status |
|----------|---------|--------|
| Windows 11 | v1.0 | ✅ Full WinRT Toast support |
| Windows 10 | v1.0 | ✅ WinRT Toast (partial) |

---

## Architecture

```
Java API (FastNotifications.java)
    ↓ JNI
Native Layer (C++)
    └── Windows: WinRT Toast API
    ↓
OS Notification System
```

---

## License

MIT License — free for commercial and private use. See [LICENSE](LICENSE) for details.

---

**Part of the FastJava Ecosystem** — *Making the JVM faster.*

---

## Related Projects

- [FastRobot](https://github.com/andrestubbe/FastRobot) — Ultra-fast screen capture & automation
- [FastTheme](https://github.com/andrestubbe/FastTheme) — OS-aware theme detection
- [FastHotkey](https://github.com/andrestubbe/FastHotkey) — Global system hotkeys
- [FastClipboard](https://github.com/andrestubbe/FastClipboard) — Native clipboard access

---

## Keywords

**SEO Tags:** java notifications, windows toast java, java system tray alternative, native notifications java, winrt toast java, jni notifications, java desktop notifications, java notification library, java windows 11 toast, java winrt notifications
