@echo off
setlocal EnableDelayedExpansion

set "self=%~nx0"
set /a index=0

echo Listing batch files in the current directory (excluding self):
for %%f in (*.bat) do (
    if /I not "%%~nxf"=="%self%" (
        set /a index+=1
        REM Store full filename but display without .bat
        set "bat[!index!]=%%~nxf"
        set "displayName=%%~nf"
        echo   !index!^) !displayName!
    )
)

if %index%==0 (
    echo No other .bat files found in this directory.
    pause
    exit /b
)

echo.
echo Files are named this way so that it's sorted properly.
echo EEE means enable.
echo DDD means disable.
echo.
echo E) Run all scripts containing "enable"
echo D) Run all scripts containing "disable"
echo.

:prompt
set /p "choice=Enter the number of the script, or E or D: "

REM Normalize choice to uppercase for letters
set "choice_upper=%choice%"
for %%A in (%choice_upper%) do set "choice_upper=%%A"
for %%L in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do (
    if /I "%choice%"=="%%L" set "choice_upper=%%L"
)

if /I "%choice%"=="E" (
    call :runAll "enable"
    goto :eof
)

if /I "%choice%"=="D" (
    call :runAll "disable"
    goto :eof
)

REM Check if choice is numeric
for /f "delims=0123456789" %%x in ("%choice%") do (
    echo Invalid input. Please enter a valid number, E, or D.
    goto prompt
)

if %choice% gtr %index% (
    echo Invalid number. Choose a number between 1 and %index%.
    goto prompt
)

if %choice% lss 1 (
    echo Invalid number. Choose a number between 1 and %index%.
    goto prompt
)

set "target=!bat[%choice%]!"
echo Launching !target! with administrator privileges...
powershell -Command "Start-Process cmd -ArgumentList '/c cd /d \"%CD%\" ^&^& \"!target!\"' -Verb RunAs"
goto :eof

:runAll
setlocal
set "filter=%~1"
set "foundAny=0"
echo Running all batch files containing "%filter%" elevated...
for %%f in (*%filter%*.bat) do (
    if /I not "%%~nxf"=="%self%" (
        set "displayName=%%~nf"
        echo Launching !displayName!...
        powershell -Command "Start-Process cmd -ArgumentList '/c cd /d \"%CD%\" ^&^& \"%%~nxf\"' -Verb RunAs"
        set "foundAny=1"
    )
)
if !foundAny!==0 (
    echo No scripts found containing "%filter%".
)
endlocal
goto :eof
