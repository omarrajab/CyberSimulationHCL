@echo off
REM ================================================================
REM CANCEL_PC.BAT - Cancel the exercise before 14:30
REM Run as Administrator
REM ================================================================

echo [+] Removing scheduled task...
schtasks /delete /tn CyberExercise_Lockout /f >nul 2>&1

echo [+] Removing exercise files...
rmdir /s /q "C:\CyberExercise" >nul 2>&1

echo.
echo [*] EXERCISE CANCELLED - PC is clean
echo.
pause
