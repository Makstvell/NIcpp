@echo off
REM Simple build script - Use this if start.bat doesn't work

echo ========================================
echo Simple Build Script
echo ========================================
echo.
echo This script assumes you're already in a
echo Developer Command Prompt for Visual Studio.
echo.
echo If cl.exe is not found, please:
echo   1. Open "Developer Command Prompt for VS 2022"
echo   2. Navigate here: cd c:\Users\maxim\Desktop\NI
echo   3. Run: build.bat
echo.
echo ========================================
echo.

REM Check if cl is available
where cl >nul 2>nul
if %errorlevel% neq 0 (
    echo ERROR: cl.exe not found!
    echo You are not in a Developer Command Prompt.
    echo.
    echo Please open "Developer Command Prompt for VS 2022"
    echo from the Start Menu and run this script again.
    echo.
    pause
    exit /b 1
)

echo [1/3] Building external libraries...
cd external_libs
call BUILD_ALL.bat
if errorlevel 1 (
    echo ERROR: Failed to build libraries!
    cd ..
    pause
    exit /b 1
)
cd ..
echo.

echo [2/3] Configuring and building main project...
cmake -B build -G "Visual Studio 17 2022"
if errorlevel 1 (
    echo ERROR: CMake configuration failed!
    pause
    exit /b 1
)

cmake --build build --config Release
if errorlevel 1 (
    echo ERROR: Build failed!
    pause
    exit /b 1
)
echo.

echo [3/3] Running application...
echo.
echo ========================================
build\Release\NI.exe
echo ========================================
echo.
pause
