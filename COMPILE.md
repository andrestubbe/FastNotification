# Building FastNotification from Source

## Prerequisites

- **JDK 17+** — [Download](https://adoptium.net/)
- **Maven 3.9+** — [Download](https://maven.apache.org/download.cgi)
- **Visual Studio 2022** — Community/Professional/Enterprise/BuildTools
  - Required: Desktop development with C++ workload
  - Required: Windows 10/11 SDK

## Quick Build

```bash
# Build native DLL first
compile.bat

# Build JAR
mvn clean package -DskipTests
```

## Build Commands

| Command | Purpose |
|---------|---------|
| `compile.bat` | Build native DLL (Windows) |
| `mvn clean compile` | Compile Java only |
| `mvn clean package` | Build JAR with DLL |
| `mvn clean package -DskipTests` | Fast build |

## Native DLL Build

The `compile.bat` script:
- Auto-detects Visual Studio 2022
- Auto-detects JAVA_HOME
- Uses `native\FastNotification.def` for JNI exports
- Outputs to `native\FastNotification.dll`

### Manual Compilation (if compile.bat fails)

```batch
"C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

cl.exe /EHsc /O2 /MD /LD /I"%JAVA_HOME%\include" /I"%JAVA_HOME%\include\win32" ^
    native\FastNotification.cpp ^
    runtimeobject.lib ^
    /link /DLL /DEF:native\FastNotification.def /MACHINE:X64 ^
    /OUT:native\FastNotification.dll
```

## Testing

```bash
# Run demo
mvn compile exec:java -Dexec.mainClass="fastnotifications.Demo"
```

## Troubleshooting

**"Cannot find DLL"** — Run `compile.bat` first

**"UnsatisfiedLinkError"** — Check:
1. DLL built successfully (`native\FastNotification.dll` exists)
2. DLL included in JAR (check `pom.xml` resources)
3. JNI exports defined in `native\FastNotification.def`

**"Java version mismatch"** — Ensure JDK 17+ and JAVA_HOME set

**"WinRT initialization failed"** — Requires Windows 10 1903+ or Windows 11

## Project Structure

```
FastNotification/
├── native/
│   ├── FastNotification.cpp     # WinRT implementation
│   ├── FastNotification.h       # C++ header
│   ├── FastNotification.def     # JNI exports (REQUIRED!)
│   └── FastNotification.dll     # Built native library
├── src/main/java/fastnotifications/
│   ├── FastNotifications.java     # Main API
│   ├── ProgressNotification.java
│   ├── Demo.java
│   └── integrations/
│       └── FastRobotDebug.java  # FastRobot integration
├── compile.bat                  # Native build script
├── COMPILE.md                   # This file
├── README.md                    # User documentation
└── pom.xml                      # Maven config
```
