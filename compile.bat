@echo off
REM Compile FastNotification Native DLL
REM Requires: Visual Studio 2022, Windows SDK

echo Building FastNotification native DLL...

REM Set up Visual Studio environment
set VS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Community
if not exist "%VS_PATH%" (
    set VS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Professional
)
if not exist "%VS_PATH%" (
    set VS_PATH=C:\Program Files\Microsoft Visual Studio\2022\Enterprise
)
if not exist "%VS_PATH%" (
    set "VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\Community"
)
if not exist "%VS_PATH%" (
    set "VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\Professional"
)
if not exist "%VS_PATH%" (
    set "VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\Enterprise"
)
if not exist "%VS_PATH%" (
    set "VS_PATH=C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools"
)

call "%VS_PATH%\VC\Auxiliary\Build\vcvars64.bat"

REM Auto-detect Java if JAVA_HOME not set
if "%JAVA_HOME%"=="" (
    if exist "C:\Program Files\Java\jdk-25" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-25"
    ) else if exist "C:\Program Files\Java\jdk-17" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-17"
    ) else if exist "C:\Program Files\Java\jdk-21" (
        set "JAVA_HOME=C:\Program Files\Java\jdk-21"
    )
)

echo Using JAVA_HOME: %JAVA_HOME%

REM Choose implementation: WinRT (modern) or COM (desktop compatible)
REM Default: COM version for maximum compatibility
set SOURCE_FILE=native\FastNotification_COM.cpp
set EXTRA_LIBS=shell32.lib ole32.lib uuid.lib user32.lib gdi32.lib

REM Uncomment for WinRT version (requires MSIX/APPX):
REM set SOURCE_FILE=native\FastNotification.cpp
REM set EXTRA_LIBS=runtimeobject.lib

echo Building: %SOURCE_FILE%

REM Compile
cl.exe /EHsc /O2 /MD /LD /std:c++17 ^
    /I"%JAVA_HOME%\include" /I"%JAVA_HOME%\include\win32" ^
    /Fe:native\FastNotification.dll ^
    %SOURCE_FILE% ^
    %EXTRA_LIBS% ^
    /link /DLL /DEF:native\FastNotification.def /MACHINE:X64 /OPT:REF /OPT:ICF

if %ERRORLEVEL% == 0 (
    echo Build successful!
    echo Output: native\FastNotification.dll
    exit /b 0
) else (
    echo Build failed!
    exit /b 1
)
