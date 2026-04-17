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

call "%VS_PATH%\VC\Auxiliary\Build\vcvars64.bat"

REM Compile with WinRT support
cl.exe /EHsc /O2 /MD /LD /std:c++17 ^
    /I"%JAVA_HOME%\include" /I"%JAVA_HOME%\include\win32" ^
    /Fe:native\FastNotification.dll ^
    native\FastNotification.cpp ^
    runtimeobject.lib ^
    /link /DLL /DEF:native\FastNotification.def /MACHINE:X64 /OPT:REF /OPT:ICF

if %ERRORLEVEL% == 0 (
    echo Build successful!
    echo Output: native\FastNotification.dll
) else (
    echo Build failed!
)

pause
