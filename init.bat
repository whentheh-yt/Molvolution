@echo off

set "PROJECT_DIR=%~dp0"
if "%PROJECT_DIR:~-1%"=="\" set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"

set "CANDIDATE1=%PROJECT_DIR%\love.exe"
set "CANDIDATE2=%ProgramFiles%\LOVE\love.exe"
set "CANDIDATE3=%ProgramFiles(x86)%\LOVE\love.exe"

set "LOVE_EXE="
if exist "%CANDIDATE1%" set "LOVE_EXE=%CANDIDATE1%"
if not defined LOVE_EXE if exist "%CANDIDATE2%" set "LOVE_EXE=%CANDIDATE2%"
if not defined LOVE_EXE if exist "%CANDIDATE3%" set "LOVE_EXE=%CANDIDATE3%"
if not defined LOVE_EXE set "LOVE_EXE=love"

if "%LOVE_EXE%"=="love" (
    where love >nul 2>nul
    if errorlevel 1 (
        echo ERROR: Could not find love.exe.
        echo Put love.exe in the project folder, install LOVE, or add it to your PATH.
        pause
        exit /b 1
    )
)

echo Launching LOVE with project: "%PROJECT_DIR%"
"%LOVE_EXE%" "%PROJECT_DIR%"
exit /b %ERRORLEVEL%
