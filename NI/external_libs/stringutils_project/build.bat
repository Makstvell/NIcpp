@echo off
REM Build script for Dynamic Library (DLL)

echo Building Dynamic Library (stringutils.dll)...

REM Compile and create DLL in one step
cl /LD /DSTRINGUTILS_BUILD /EHsc stringutils.cpp /Fe:stringutils.dll

echo Done! Created stringutils.dll and stringutils.lib

REM Clean up intermediate files
del stringutils.obj
del stringutils.exp

pause
