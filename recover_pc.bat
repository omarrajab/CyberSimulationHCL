@echo off
REM ================================================================
REM RECOVER_PC.BAT - Emergency Recovery
REM Run as Administrator on the locked PC (or via Safe Mode)
REM ================================================================

echo [+] Killing watchdog and lockscreen...
taskkill /f /im wscript.exe >nul 2>&1
taskkill /f /im mshta.exe >nul 2>&1

echo [+] Cleaning user registries...

for /f "tokens=*" %%s in ('reg query HKU 2^>nul ^| findstr /i "S-1-5-21" ^| findstr /v "_Classes"') do (
    echo [+] Cleaning %%s
    reg delete "%%s\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /f >nul 2>&1
    reg delete "%%s\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /f >nul 2>&1
    reg delete "%%s\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /f >nul 2>&1
    reg delete "%%s\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLogoff /f >nul 2>&1
    reg delete "%%s\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoChangeStartMenu /f >nul 2>&1
    reg delete "%%s\Software\Policies\Microsoft\Windows\System" /v DisableCMD /f >nul 2>&1
)

echo [+] Restarting Explorer...
start explorer.exe

echo [+] Removing scheduled task...
schtasks /delete /tn CyberExercise_Lockout /f >nul 2>&1

echo [+] Removing exercise files...
rmdir /s /q "C:\CyberExercise" >nul 2>&1

echo.
echo [*] PC RECOVERED
echo.
pause
