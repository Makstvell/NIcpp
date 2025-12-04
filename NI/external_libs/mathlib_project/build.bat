@echo off
REM Build script for Static Library

echo Building Static Library (mathlib)...

REM Compile to object file
cl /c /EHsc mathlib.cpp /Fo:mathlib.obj

REM Create static library
lib mathlib.obj /OUT:mathlib.lib

echo Done! Created mathlib.lib

REM Clean up intermediate files
del mathlib.obj

pause
