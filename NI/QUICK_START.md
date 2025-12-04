# Quick Start Guide

## One-Command Build and Run

### Easy Way (From Windows Explorer)

Just **double-click `start.bat`** in Windows Explorer!

The script will automatically:
- Find and load Visual Studio environment
- Build everything
- Run the application

### Alternative (From Command Line)

If the easy way doesn't work, open **Developer Command Prompt for VS 2022** and run:

```cmd
build.bat
```

This will automatically:
1. Build external libraries (mathlib.lib, stringutils.dll)
2. Clean previous build
3. Configure CMake
4. Build NI.exe
5. Run the application

---

## What Was Fixed

### CMakeLists.txt Improvements

1. **Added library existence check**
   - Provides clear error message if libraries not built
   - Prevents confusing linker errors

2. **Fixed IMPORTED library properties**
   - Added DEBUG and RELEASE configurations
   - Proper handling of both static and dynamic libraries

3. **Improved file globbing**
   - Separated MAIN_SRC and CORE_SRC
   - Better control over source file collection

4. **Added status messages**
   - Shows library paths during configuration
   - Easier to debug path issues

### start.bat Features

1. **Automatic library building**
   - Calls external_libs/BUILD_ALL.bat first
   - Ensures libraries exist before main build

2. **Smart CMake generator detection**
   - Tries Visual Studio 2022
   - Falls back to Visual Studio 2019
   - Falls back to NMake Makefiles
   - Clear error if no generator found

3. **Error handling**
   - Stops on first error
   - Shows clear error messages
   - Prevents cascading failures

4. **Automatic execution**
   - Runs NI.exe after successful build
   - Handles different build directory structures

---

## Manual Build Steps (if needed)

### Step 1: Build Libraries
```cmd
cd external_libs
BUILD_ALL.bat
cd ..
```

### Step 2: Build Main Project
```cmd
cmake -B build -G "Visual Studio 17 2022"
cmake --build build --config Release
```

### Step 3: Run
```cmd
build\Release\NI.exe
```

---

## Project Structure

```
NI/
├── start.bat                          ← ONE COMMAND TO BUILD ALL
├── CMakeLists.txt                     ← Fixed: imports prebuilt libraries
├── BUILD_INSTRUCTIONS.md              ← Detailed documentation
│
├── external_libs/                     ← External library projects
│   ├── BUILD_ALL.bat                  ← Builds both libraries
│   ├── mathlib_project/               ← Static library source
│   │   ├── mathlib.cpp
│   │   ├── mathlib.h
│   │   └── build.bat
│   ├── stringutils_project/           ← Dynamic library source
│   │   ├── stringutils.cpp
│   │   ├── stringutils.h
│   │   └── build.bat
│   └── prebuilt/                      ← Output (created after build)
│       ├── lib/
│       │   ├── mathlib.lib            ← Static library
│       │   └── stringutils.lib        ← Import library for DLL
│       ├── bin/
│       │   └── stringutils.dll        ← Dynamic library
│       └── include/
│           ├── mathlib.h
│           └── stringutils.h
│
├── src/
│   ├── main.cpp                       ← Uses prebuilt libraries
│   ├── external/                      ← Linking headers (NOT original)
│   │   ├── mathlib_link.h             ← Declares mathlib functions
│   │   └── stringutils_link.h         ← Declares stringutils functions
│   └── core/
│       └── orchestrator/
│           ├── orchestrator.h
│           └── orchestrator.cpp
│
└── build/                             ← CMake build output
    └── Release/
        ├── NI.exe                     ← Main executable
        └── stringutils.dll            ← Copied automatically
```

---

## Key Concepts

### Static Library (mathlib.lib)
- **Built once**: `external_libs/mathlib_project/`
- **Code embedded**: Into NI.exe at link time
- **No runtime file**: Everything in the .exe
- **CMake imports**: Using `STATIC IMPORTED` target

### Dynamic Library (stringutils.dll)
- **Built once**: `external_libs/stringutils_project/`
- **Separate at runtime**: DLL must exist with .exe
- **Two files created**:
  - `stringutils.lib` - Import library (for linking)
  - `stringutils.dll` - Actual code (for runtime)
- **CMake imports**: Using `SHARED IMPORTED` target
- **Auto-copied**: To build output by CMake POST_BUILD

### Main Application (NI.exe)
- **Does NOT include** original library headers
- **Uses linking headers**: `mathlib_link.h`, `stringutils_link.h`
- **Links against prebuilt**: `.lib` files
- **Demonstrates difference**: Between static and dynamic linking

---

## Common Errors and Solutions

### Error: "Prebuilt libraries not found"
**Solution:** Run `external_libs\BUILD_ALL.bat` or use `start.bat`

### Error: "Cannot open file 'mathlib.lib'"
**Solution:** Libraries weren't built. Check `external_libs/prebuilt/` exists

### Error: "stringutils.dll not found" (at runtime)
**Solution:** CMake should copy it automatically. Check `build/Release/` folder

### Error: "No suitable CMake generator found"
**Solution:**
- Open **Developer Command Prompt for VS**
- Or install Visual Studio with C++ tools
- Or install CMake and add to PATH

### Error: "cl is not recognized"
**Solution:** Must use **Developer Command Prompt**, not regular cmd

---

## Testing Your Build

After running `start.bat`, you should see:

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

If you see this output, everything is working correctly!

---

## Next Steps

1. **Modify libraries**: Edit files in `external_libs/` projects
2. **Rebuild libraries**: Run `external_libs\BUILD_ALL.bat`
3. **Rebuild main project**: CMake will pick up new `.lib` files automatically
4. **Or rebuild everything**: Just run `start.bat` again

---

## Need Help?

- Full details: [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)
- Library examples: [examples/README.md](examples/README.md)
- CMake issues: Check CMake output for paths
- Linker errors: Verify `external_libs/prebuilt/` structure
