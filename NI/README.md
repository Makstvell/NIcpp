# NI Project - Static and Dynamic Library Example

Complete C++ project demonstrating how to use independently-built static and dynamic libraries.

## Quick Start

### Option 1: Automatic (Recommended)

Double-click **`start.bat`** from Windows Explorer.

This will:
- Automatically find and load Visual Studio environment
- Build external libraries
- Build main project
- Run the application

### Option 2: Manual (If automatic fails)
3. Run: `build.bat`

## What This Demonstrates

### Static Library (mathlib.lib)
- Built independently in `external_libs/mathlib_project/`
- Code **embedded into NI.exe** at link time
- No separate file needed at runtime
- Uses `extern "C"` functions

### Dynamic Library (stringutils.dll)
- Built independently in `external_libs/stringutils_project/`
- Code **loaded at runtime** from DLL
- DLL must be in same folder as NI.exe
- Creates two files: `.lib` (for linking) and `.dll` (for runtime)

### Main Application
- Does NOT include original library headers
- Uses custom linking headers instead
- Simulates real-world usage of third-party libraries

## Project Structure

```
NI/
├── start.bat                    ← Auto-build everything
├── build.bat                    ← Simple build (requires Dev Prompt)
├── CMakeLists.txt               ← Main project configuration
│
├── external_libs/               ← Independent library projects
│   ├── BUILD_ALL.bat
│   ├── mathlib_project/         ← Static library source
│   ├── stringutils_project/     ← Dynamic library source
│   └── prebuilt/                ← Build output
│       ├── lib/
│       │   ├── mathlib.lib
│       │   └── stringutils.lib
│       ├── bin/
│       │   └── stringutils.dll
│       └── include/
│
├── src/
│   ├── main.cpp                 ← Application entry point
│   ├── external/                ← Linking headers (NOT originals)
│   │   ├── mathlib_link.h
│   │   └── stringutils_link.h
│   └── core/
│       └── orchestrator/
│
└── build/                       ← CMake output
    └── Release/
        ├── NI.exe
        └── stringutils.dll
```

## Documentation

- **[QUICK_START.md](QUICK_START.md)** - Quick reference guide
- **[BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)** - Detailed build instructions
- **[CHANGES_SUMMARY.md](CHANGES_SUMMARY.md)** - What was changed/fixed

## Troubleshooting

### "cl is not recognized"

**Solution:** You need Visual Studio environment variables loaded.

Either:
1. Use `start.bat` (loads automatically)
2. Or open **Developer Command Prompt for VS 2022** and run `build.bat`

### "Cannot find mathlib.lib"

**Solution:** External libraries weren't built.

```cmd
cd external_libs
BUILD_ALL.bat
cd ..
```

Or just run `start.bat` which does everything.

### "Visual Studio environment not found"

**Solution:** Install Visual Studio 2019 or 2022 with C++ tools.

Download from: https://visualstudio.microsoft.com/

Make sure to select "Desktop development with C++" during installation.

## Requirements

- **Visual Studio 2019 or 2022** with C++ tools
- **CMake 3.20 or later**
- **Windows 10/11**

## Expected Output

When you run the application, you should see:

```
=== NI Application - Using Prebuilt Libraries ===

--- Static Library Example (mathlib.lib) ---
MathAdd(15, 27) = 42
MathMultiply(8, 9) = 72
MathAverage({10, 20, 30, 40, 50}) = 30

--- Dynamic Library Example (stringutils.dll) ---
StringToUpper("Hello World") = "HELLO WORLD"
StringToLower("Hello World") = "hello world"
StringReverse("Hello World") = "dlroW olleH"
StringCountWords("The quick brown fox jumps") = 5

--- Understanding Static vs Dynamic ---
Static (mathlib.lib):
  - Code is inside NI.exe
  - No separate file needed
  - Linked at compile time

Dynamic (stringutils.dll):
  - Code is in separate DLL file
  - DLL must exist at runtime
  - Loaded when program starts

--- Starting Orchestrator ---
[Orchestrator output...]
```

## License

MIT License - See individual files for details.

## Key Learning Points

1. **How to build libraries independently** from your main project
2. **How to link against prebuilt `.lib` files** using CMake IMPORTED targets
3. **Difference between static and dynamic linking** in practice
4. **How to use libraries without original headers** (binary distribution scenario)
5. **Windows DLL import/export** with `__declspec(dllexport/dllimport)`
6. **Professional build automation** with error handling
