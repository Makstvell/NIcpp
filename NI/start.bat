@echo off
setlocal enabledelayedexpansion

echo ========================================
echo NI Project - Complete Build Script
echo ========================================
echo.

REM ========================================
REM STEP 0: Initialize Visual Studio Environment
REM ========================================
echo [STEP 0/4] Initializing Visual Studio environment...
echo.

REM Check if already in VS environment
where cl >nul 2>nul
if %errorlevel% equ 0 (
    echo Visual Studio environment already loaded.
    echo.
    goto :build_libs
)

REM Try to find and load Visual Studio environment
echo Searching for Visual Studio installation...

REM Try VS 2022
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" (
    for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do (
        set "VS_PATH=%%i"
    )
)

if defined VS_PATH (
    echo Found Visual Studio at: !VS_PATH!
    echo Loading environment...

    REM Try x64 native tools first
    if exist "!VS_PATH!\VC\Auxiliary\Build\vcvars64.bat" (
        call "!VS_PATH!\VC\Auxiliary\Build\vcvars64.bat" >nul 2>&1
        echo Environment loaded successfully.
        echo.
        goto :build_libs
    )
) else (
    REM Fallback: Try common VS paths
    echo vswhere not found, trying common paths...

    set "VS2022=%ProgramFiles%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
    set "VS2022PRO=%ProgramFiles%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat"
    set "VS2019=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"

    if exist "!VS2022!" (
        call "!VS2022!" >nul 2>&1
        echo Loaded VS 2022 Community environment.
        echo.
        goto :build_libs
    )
    if exist "!VS2022PRO!" (
        call "!VS2022PRO!" >nul 2>&1
        echo Loaded VS 2022 Professional environment.
        echo.
        goto :build_libs
    )
    if exist "!VS2019!" (
        call "!VS2019!" >nul 2>&1
        echo Loaded VS 2019 environment.
        echo.
        goto :build_libs
    )
)

REM If we get here, VS environment couldn't be loaded
echo.
echo ========================================
echo ERROR: Visual Studio environment not found!
echo ========================================
echo.
echo Please either:
echo   1. Run this script from "Developer Command Prompt for VS"
echo   2. Or install Visual Studio 2019 or later with C++ tools
echo.
echo To open Developer Command Prompt:
echo   - Search "Developer Command Prompt" in Start Menu
echo   - Then navigate to this folder and run: start.bat
echo.
pause
exit /b 1

:build_libs
echo.

REM ========================================
REM STEP 1: Build External Libraries
REM ========================================
echo [STEP 1/4] Building external libraries...
echo.

cd external_libs

if not exist "mathlib_project\mathlib.cpp" (
    echo ERROR: Library source files not found!
    echo Please check that external_libs folder is complete.
    pause
    exit /b 1
)

REM Build libraries
call BUILD_ALL.bat
if errorlevel 1 (
    echo.
    echo ERROR: Failed to build external libraries!
    pause
    exit /b 1
)

cd ..
echo.
echo [STEP 1/4] External libraries built successfully!
echo.

REM ========================================
REM STEP 2: Clean Previous Build
REM ========================================
echo [STEP 2/4] Cleaning previous build...
if exist build (
    rmdir /s /q build
    echo Previous build directory removed.
) else (
    echo No previous build found.
)
echo.

REM ========================================
REM STEP 3: Configure CMake
REM ========================================
echo [STEP 3/4] Configuring CMake project...
echo.

REM Try Visual Studio 17 2022 first
cmake -S . -B build -G "Visual Studio 17 2022" 2>nul
if errorlevel 1 (
    echo Visual Studio 2022 not found, trying other generators...

    REM Try Visual Studio 16 2019
    cmake -S . -B build -G "Visual Studio 16 2019" 2>nul
    if errorlevel 1 (
        echo Visual Studio 2019 not found, trying NMake...

        REM Try NMake Makefiles
        cmake -S . -B build -G "NMake Makefiles" 2>nul
        if errorlevel 1 (
            echo.
            echo ERROR: No suitable CMake generator found!
            echo Please install Visual Studio 2019 or later.
            echo.
            pause
            exit /b 1
        ) else (
            echo Using NMake Makefiles
        )
    ) else (
        echo Using Visual Studio 2019
    )
) else (
    echo Using Visual Studio 2022
)

echo.
echo [STEP 3/4] CMake configuration completed!
echo.

REM ========================================
REM STEP 4: Build Project
REM ========================================
echo [STEP 4/4] Building NI project...
echo.

cmake --build build --config Release
if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    echo Check the error messages above.
    pause
    exit /b 1
)

echo.
echo ========================================
echo BUILD SUCCESSFUL!
echo ========================================
echo.
echo Executable: build\Release\NI.exe
echo DLL copied: build\Release\stringutils.dll
echo.
echo ========================================
echo Running NI.exe...
echo ========================================
echo.

REM ========================================
REM Run the executable
REM ========================================
if exist "build\Release\NI.exe" (
    build\Release\NI.exe
) else if exist "build\NI.exe" (
    build\NI.exe
) else (
    echo ERROR: NI.exe not found!
    echo Build may have failed silently.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Execution completed!
echo ========================================
pause