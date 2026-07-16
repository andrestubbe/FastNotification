@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo [FastNotification] Running Demo (via JitPack)...
cd examples\00-basic-usage
call mvn compile exec:java -Dexec.mainClass=fastnotification.examples.BasicNotificationDemo
cd ..\..
pause
