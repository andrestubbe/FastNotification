# FastNotification 0.1.0 [ALPHA-2026-06-14] — Native Windows Toast Notifications for Java

[![Status](https://img.shields.io/badge/status-0.1.0-brightgreen.svg)](https://github.com/andrestubbe/FastNotification/releases/tag/0.1.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Java](https://img.shields.io/badge/Java-17+-blue.svg)](https://www.java.com)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010+-lightgrey.svg)]()
[![JitPack](https://img.shields.io/badge/JitPack-ready-green.svg)](https://jitpack.io/#andrestubbe/FastNotification)

**⚡ Ultra-fast native Java notifications — Replace ugly Java SystemTray with real OS-native Toasts.**

FastNotification is a high-performance native notification library for Java that replaces the ugly, limited
`java.awt.SystemTray` with real OS-native notifications. Built for Windows 11 native WinRT Toasts with full
customization.

[![FastNotification Showcase](docs/screenshot.png)](https://www.youtube.com/watch?v=BZsqQl7WqWk)

---

## Table of Contents

- [Why FastNotifications?](#why-fastnotifications)
- [Key Features](#key-features)
- [FastNotifications vs SystemTray](#fastnotifications-vs-systemtray)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [API Reference](#api-reference)
- [Integrations](#integrations)
- [Platform Support](#platform-support)
- [Documentation](#documentation)
- [License](#license)
- [Related Projects](#related-projects)

---

## Quick Start

```java
// Quick notification
FastNotifications.notify("Build finished", "FastImage compiled in 42ms");

// Full control — custom icon, action buttons, urgency
FastNotifications.builder()
    .title("Download complete")
    .message("File saved to /downloads")
    .icon("fastjava.png")
    .urgency(Urgency.HIGH)
    .action("Open", this::openFile)
    .action("Dismiss", null)
    .timeout(Duration.seconds(5))
    .show();
```

---

## Why FastNotifications?

`java.awt.SystemTray` notifications are:

- **Ugly** — Always shows the Java coffee cup icon
- **Limited** — No action buttons, no progress bars, no priorities
- **Deprecated** — Uses old balloon API on Windows
- **Inconsistent** — Looks different on every OS

**FastNotifications** supports **3 integration levels**:

| Level | Effort | Result |
|-------------------------|------------------|--------------------------------|
| **Level 1** (5 min) | Build DLL → Run | Basic notifications (Balloon) |
| **Level 2** (2 hrs) | + Sparse Package | Full WinRT Toasts (like Teams) |
| **Level 3** (3-10 days) | + MSIX + Store | Store distribution |

---

## Key Features

- 🪟 **Windows 11 Native Toasts** — WinRT XML-based with full customization
- 🖼️ **Custom App Icons** — Replace the ugly Java coffee cup with your logo
- 🔘 **Action Buttons** — "Open", "Dismiss", custom callbacks
- 📊 **Progress Notifications** — Download/install progress bars
- 🚨 **Urgency Levels** — Low, Normal, High, Critical
- ⚡ **Zero Dependencies** — Pure JNI, no JavaFX, no Swing, no AWT

---

## FastNotifications vs SystemTray

| Feature | SystemTray | FastNotifications |
|------------------|----------------------|----------------------|
| Icon | ☕ Java coffee cup | 🖼️ Your custom icon |
| Windows 11 style | ❌ Deprecated balloon | ✅ Native WinRT Toast |
| Action buttons | ❌ None | ✅ Custom buttons |
| Progress bars | ❌ None | ✅ Native progress |
| Urgency/Priority | ❌ None | ⚡ High, Critical |

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
        <artifactId>FastNotification</artifactId>
        <version>0.1.0</version>
    </dependency>

    <!-- FastCore (Required Native Loader) -->
    <dependency>
        <groupId>com.github.andrestubbe</groupId>
        <artifactId>FastCore</artifactId>
        <version>0.1.0</version>
    </dependency>
</dependencies>
```

### Option 2: Gradle (via JitPack)

```groovy
repositories {
    maven { url 'https://jitpack.io' }
}

dependencies {
    implementation 'com.github.andrestubbe:FastNotification:0.1.0'
    implementation 'com.github.andrestubbe:FastCore:0.1.0'
}
```

### Option 3: Direct Download (No Build Tool)

Download the latest JARs directly to add them to your classpath:

1. 📦 **[fastnotification-0.1.0.jar](https://github.com/andrestubbe/FastNotification/releases/download/0.1.0/fastnotification-0.1.0.jar)** (The Core Library)
2. ⚙️ **[fastcore-0.1.0.jar](https://github.com/andrestubbe/FastCore/releases/download/0.1.0/fastcore-0.1.0.jar)** (The Mandatory Native Loader)

> [!IMPORTANT]
> All JARs must be in your classpath for the native JNI calls to function correctly.

---

## Quick Start — Choose Your Setup Level

FastNotification offers **3 integration levels**:

| Level | Setup Time | Features | Best For |
|-------------|------------|-------------------------------------|-------------------------|
| **Level 1** | 5 minutes | Basic notifications (Balloon style) | Testing, internal tools |
| **Level 2** | 2 hours | Full Windows 11 Toasts with actions | Production apps |
| **Level 3** | 3-10 days | Microsoft Store integration | Store distribution |

### Level 1 — Quick Test (5 min)

```bash
compile.bat
mvn compile
java -cp "target\classes" fastnotifications.Demo
```

```java
FastNotifications.notify("Hello", "From Java!");
```

> [!NOTE]
> Windows 10/11 may hide balloon notifications by default. See Level 2 for full WinRT toasts.

### Level 2 — Production Setup (2 hours)

```powershell
cd installer
.\create-package.ps1 -SelfSigned
.\register-sparse.ps1 -InstallPath "C:\Program Files\YourApp"
```

```java
FastNotifications.builder()
    .title("Download complete")
    .message("Ready to install")
    .icon("app.png")
    .action("Install", this::install)
    .action("Later", null)
    .show();
```

---

## API Reference

### Core Methods

| Method | Description | Status |
|-------------------------------------------|------------------------------------------|------------|
| `notify(title, message)` | Simple toast notification | ✅ Working |
| `notify(title, message, icon)` | Toast with custom icon | ✅ Working |
| `notifyTagged(tag, title, message)` | Tagged notification (replaces existing) | ✅ Working |
| `builder()` | Create advanced notification | ✅ Working |
| `progress(title, message)` | Progress notification | 🚧 Planned |

### NotificationBuilder

| Method | Description |
|----------------------------|-----------------------------------------------------|
| `tag(String id)` | Unique identifier (replaces existing with same tag) |
| `title(String text)` | Notification title |
| `message(String text)` | Body text |
| `icon(String path)` | PNG icon path |
| `urgency(Urgency)` | LOW, NORMAL, HIGH, CRITICAL |
| `timeout(Duration)` | Auto-dismiss timeout |
| `action(String, Runnable)` | Add button with callback |
| `show()` | Display notification |

---

## Integrations

### FastRobot Debug Mode

```java
import fastnotifications.integrations.FastRobotDebug;

FastRobotDebug.enable();
// All FastRobot actions now show toasts
FastRobotDebug.showSummary();
```

---

## Platform Support

| Platform | Version | Status | Notes |
|------------|---------|----------------|----------------------------------------|
| Windows 11 | v1.0 | ✅ Full support | WinRT Toast XML, all features |
| Windows 10 | v1.0 | 🚧 Partial | Requires v1903+, some features limited |
| macOS | — | ❌ Not planned | Use native macOS notifications |
| Linux | — | ❌ Not planned | Use DBus directly |

---

## Documentation

* **[COMPILE.md](docs/COMPILE.md)**: Full compilation guide (MSVC C++17 build chain + JNI Setup).
* **[REFERENCE.md](docs/REFERENCE.md)**: Full API descriptions and method reference.
* **[PHILOSOPHY.md](docs/PHILOSOPHY.md)**: The engineering rationale for zero-allocation performance.
* **[ROADMAP.md](docs/ROADMAP.md)**: Future milestones and planned features.

---

## License

MIT License — See [LICENSE](LICENSE) file for details.

---

## Related Projects

- [FastCore](https://github.com/andrestubbe/FastCore) — Native Library Loader for Java
- [FastRobot](https://github.com/andrestubbe/FastRobot) — High-FPS Screen Capture & Native Automation for Java
- [FastTheme](https://github.com/andrestubbe/FastTheme) — Advanced UI Styling Engine for Java

---
**Part of the FastJava Ecosystem** — *Making the JVM faster. ⚡*
