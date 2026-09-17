@echo off
setlocal
chcp 65001 > nul
cd /d "%~dp0"

echo ===================================================
echo  FastNotification Demo
echo ===================================================
echo [1/3] Building Native Library...
call compile.bat
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Native build failed!
    pause
    exit /b %ERRORLEVEL%
)

echo [2/3] Building FastNotification Core...
call mvn clean install -DskipTests -q
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Core build failed!
    pause
    exit /b %ERRORLEVEL%
)

echo [3/3] Running Demo...
java "--enable-preview" "-Djava.library.path=release;native;src\main\resources\native" -cp "target\classes;src\main\resources" fastnotifications.Demo
pause
