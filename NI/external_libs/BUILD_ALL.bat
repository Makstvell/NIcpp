@echo off
echo ========================================
echo Building External Libraries
echo ========================================
echo.

REM Build Static Library
echo [1/2] Building Static Library...
cd mathlib_project
call build.bat
cd ..
echo.

REM Build Dynamic Library
echo [2/2] Building Dynamic Library...
cd stringutils_project
call build.bat
cd ..
echo.

echo ========================================
echo Copying libraries to prebuilt folder...
echo ========================================

REM Create prebuilt directories
if not exist "prebuilt\lib" mkdir prebuilt\lib
if not exist "prebuilt\include" mkdir prebuilt\include
if not exist "prebuilt\bin" mkdir prebuilt\bin

REM Copy static library
copy mathlib_project\mathlib.lib prebuilt\lib\
copy mathlib_project\mathlib.h prebuilt\include\

REM Copy dynamic library
copy stringutils_project\stringutils.dll prebuilt\bin\
copy stringutils_project\stringutils.lib prebuilt\lib\
copy stringutils_project\stringutils.h prebuilt\include\

echo.
echo ========================================
echo Build Complete!
echo ========================================
echo.
echo Prebuilt libraries are in: prebuilt\
echo   - prebuilt\lib\mathlib.lib (static)
echo   - prebuilt\lib\stringutils.lib (import library)
echo   - prebuilt\bin\stringutils.dll (dynamic)
echo   - prebuilt\include\*.h (headers)
echo.

pause
