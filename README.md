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

## Quick Start

```java
import fastnotifications.FastNotifications;
import java.time.Duration;

public class Demo {
    public static void main(String[] args) throws Exception {
        // 1. Quick notification
        FastNotifications.notify("Build finished", "FastImage compiled in 42ms");

        // 2. Full control — custom icon, action buttons, urgency
        FastNotifications.builder()
            .title("Download complete")
            .message("File saved to /downloads")
            .icon("fastjava.png")
            .urgency(FastNotifications.Urgency.HIGH)
            .action("Open", () -> System.out.println("Opening file..."))
            .action("Dismiss", null)
            .timeout(Duration.ofSeconds(5))
            .show();
    }
}
```

---

## Table of Contents

- [Why FastNotifications?](#why-fastnotifications)
- [Key Features](#key-features)
- [Real-World Use Cases](#real-world-use-cases)
- [Performance Benchmarks](#performance-benchmarks)
- [Integration Levels](#integration-levels)
- [API Reference](#api-reference)
- [Technical Demos & Benchmarks](#technical-demos--benchmarks)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Documentation](#documentation)
- [Platform Support](#platform-support)
- [License](#license)
- [Related Projects](#related-projects)

---


## Why FastNotifications?

Standard `java.awt.SystemTray` notifications suffer from fundamental architectural and visual limitations:

- **Ugly App Branding** — Hardcoded to display the legacy Java coffee cup icon instead of custom application identities.
- **Severely Limited Capabilities** — No interactive action buttons, no live progress bars, and no OS urgency levels.
- **Deprecated Windows Backend** — Relies on legacy Win32 balloon tooltips that modern Windows versions suppress.
- **Visual Inconsistency** — Renders unpredictably across different desktop platforms.

**FastNotifications** solves this by hooking directly into the modern Windows WinRT Notification subsystem:

| Feature | java.awt.SystemTray | notify-send / PowerShell | FastNotifications |
|:---|:---|:---|:---|
| **Windows Style** | Deprecated Win32 balloon tooltip | Spawns external PowerShell process | **Native WinRT XML Toast** |
| **App Branding** | Forced Java coffee cup icon | Generic shell icon | **Custom application identity & logo** |
| **Interactive Buttons** | Not supported | Complex script parameters | **Custom action buttons & callbacks** |
| **Progress & Urgency** | Not supported | Not supported | **Live progress bars & urgency levels** |

---

## Integration Levels

FastNotifications provides 3 flexible integration tiers depending on deployment needs:

| Level | Effort | Result |
|:---|:---|:---|
| **Level 1** (5 min) | Build DLL → Run | Basic notifications (Balloon fallback) |
| **Level 2** (2 hrs) | + Sparse Package | Full WinRT Toasts (like Microsoft Teams) |
| **Level 3** (3-10 days) | + MSIX + Store | Windows Store & Enterprise distribution |

---

## Key Features

- 🪟 **Windows 11 Native Toasts** — WinRT XML-based with full customization
- 🖼️ **Custom App Icons** — Replace the ugly Java coffee cup with your logo
- 🔘 **Action Buttons** — "Open", "Dismiss", custom callbacks
- 📊 **Progress Notifications** — Download/install progress bars
- 🚨 **Urgency Levels** — Low, Normal, High, Critical
- ⚡ **Zero Dependencies** — Pure JNI, no JavaFX, no Swing, no AWT

---

## Real-World Use Cases

- 🔔 **Developer Tooling & Build Watchers**: Instant native toast notifications on build failure, test completion, or deployment success.
- 📥 **Background Downloads & File Sync**: Real-time progress notifications and completion actions for file sync and downloading engines.
- 🤖 **Autonomous AI Agent HUD & Alerts**: Alert operators on task completion, approval requests, or anomaly detection without blocking CLI execution.
- 📈 **Trading & System Health Telemetry**: Flash high-urgency notifications for critical threshold breaches or market events.

---

## Performance Benchmarks

FastNotification is benchmarked via **JMH (Java Microbenchmark Harness)** to guarantee minimal overhead and zero garbage collection pressure when creating and dispatching notification payloads:

| Benchmark Operation | Throughput (ops/ms) | Ops per Second | Memory Allocation |
|:---|:---|:---|:---|
| **Builder Instantiation & Fluent Config** | **~92,900 ops/ms** | **> 92.9 Million** | **0 bytes GC pressure** |
| **Native Dispatch (Balloon/Toast Shell)** | **Direct Win32 Call** | **Instant Kernel Hook** | **Off-heap / native memory** |

In the official [JMH Benchmark](examples/Benchmark):

```text
Benchmark                                 Mode  Cnt      Score   Error   Units
Benchmark.benchmarkBuilderInstantiation  thrpt    3  92908.543          ops/ms
```

---

## Integration Levels

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

## Technical Demos & Benchmarks

Run standalone verification demos or execute JMH throughput microbenchmarks:

| Type | Target / Launcher | Source File | Description |
|:---|:---|:---|:---|
| **Interactive Demo** | [`run-demo.bat`](run-demo.bat) | [`Demo.java`](src/main/java/fastnotifications/Demo.java) | End-to-end verification of native balloon/toast notifications and builder fluent API |
| **Throughput Benchmark** | [`run-benchmark.bat`](run-benchmark.bat) | [`Benchmark.java`](examples/Benchmark/src/main/java/fastnotifications/benchmark/Benchmark.java) | JMH microbenchmark suite measuring zero-GC notification builder instantiation and dispatch throughput |

---

## Documentation

- **[CHANGELOG.md](docs/CHANGELOG.md)**: Version history and release notes.
- **[COMPILE.md](docs/COMPILE.md)**: Full compilation guide (MSVC C++17 build chain + JNI Setup).
- **[REFERENCE.md](docs/REFERENCE.md)**: Full API descriptions and method reference.
- **[PHILOSOPHY.md](docs/PHILOSOPHY.md)**: The engineering rationale for zero-allocation performance.
- **[ROADMAP.md](docs/ROADMAP.md)**: Future milestones and planned features.

---

## Platform Support

| Platform | Architecture | Status | Notes |
|:---|:---|:---|:---|
| **Windows 11** | `x86_64` | ✅ Fully Supported | WinRT XML Toast & COM Desktop Fallback |
| **Windows 10** | `x86_64` | ✅ Fully Supported | Windows Shell Tray & Modern Balloon Notifications |
| **Linux (DBus / libnotify)** | `x86_64` | 🔄 Planned | Desktop notification daemon bridge |
| **macOS (Apple Silicon / Intel)** | `Universal` | 🔄 Planned | Native NSUserNotificationCenter backend |

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
