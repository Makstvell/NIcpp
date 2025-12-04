# Build Instructions - Using Prebuilt Libraries

This project demonstrates how to use **independently built** static and dynamic libraries.

## Overview

The project has two separate parts:

1. **External Libraries** - Built independently first
   - `mathlib.lib` (static library)
   - `stringutils.dll` (dynamic library)

2. **Main Application (NI)** - Links to prebuilt libraries
   - Does NOT include original library headers
   - Links against prebuilt `.lib` files

## Step-by-Step Build Process

### STEP 1: Build External Libraries

Open **Developer Command Prompt for VS 2022** and run:

```cmd
cd c:\Users\maxim\Desktop\NI\external_libs
BUILD_ALL.bat
```

**What this does:**
- Compiles `mathlib.cpp` → creates `mathlib.lib`
- Compiles `stringutils.cpp` → creates `stringutils.dll` + `stringutils.lib`
- Copies all files to `external_libs/prebuilt/` folder

**Output:**
```
external_libs/prebuilt/
├── lib/
│   ├── mathlib.lib          ← Static library
│   └── stringutils.lib      ← Import library for DLL
├── bin/
│   └── stringutils.dll      ← Dynamic library
└── include/
    ├── mathlib.h
    └── stringutils.h
```

### STEP 2: Build Main Application

Still in the Developer Command Prompt:

```cmd
cd c:\Users\maxim\Desktop\NI
cmake -B build -G "Visual Studio 17 2022"
cmake --build build --config Release
```

**What this does:**
- CMake imports the prebuilt libraries using `IMPORTED` targets
- Links `NI.exe` against `mathlib.lib` (static)
- Links `NI.exe` against `stringutils.lib` (import library for DLL)
- Copies `stringutils.dll` to the output directory

### STEP 3: Run the Application

```cmd
cd build\Release
NI.exe
```

**Expected Output:**
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
...
```

## How It Works

### Static Library (mathlib.lib)

1. **Built independently** in `external_libs/mathlib_project/`
2. **Linked at compile time** using CMake `IMPORTED` target
3. **Code embedded** into `NI.exe`
4. **No runtime files** needed

```cmake
add_library(mathlib_external STATIC IMPORTED)
set_target_properties(mathlib_external PROPERTIES
    IMPORTED_LOCATION "external_libs/prebuilt/lib/mathlib.lib"
)
```

### Dynamic Library (stringutils.dll)

1. **Built independently** in `external_libs/stringutils_project/`
2. **Linked at compile time** using import library (`.lib`)
3. **Code loaded at runtime** from DLL
4. **DLL must be present** next to `NI.exe`

```cmake
add_library(stringutils_external SHARED IMPORTED)
set_target_properties(stringutils_external PROPERTIES
    IMPORTED_LOCATION "external_libs/prebuilt/bin/stringutils.dll"
    IMPORTED_IMPLIB "external_libs/prebuilt/lib/stringutils.lib"
)
```

### Main Application Linking

```cpp
// src/main.cpp
#include "mathlib_link.h"      // NOT the original mathlib.h
#include "stringutils_link.h"  // NOT the original stringutils.h

int main() {
    // Call functions from prebuilt libraries
    int result = MathAdd(10, 20);
    char* upper = StringToUpper("hello");
    StringFree(upper);
}
```

## Key Points

✅ **Libraries built completely independently**
- Can be distributed as binary packages
- Can be built with different tools/compilers
- Simulates using third-party libraries

✅ **Main project does NOT include original headers**
- Uses custom linking headers (`mathlib_link.h`, `stringutils_link.h`)
- Only declares function signatures
- Links against binary `.lib` files

✅ **Static vs Dynamic difference is clear**
- Static: Code in `NI.exe`, no external files
- Dynamic: Code in `stringutils.dll`, must be present at runtime

## Troubleshooting

**Error: "Cannot find mathlib.lib"**
- You forgot to build the external libraries first
- Run `external_libs/BUILD_ALL.bat`

**Error: "Cannot find stringutils.dll"**
- The DLL was not copied to the output directory
- CMake should do this automatically via `POST_BUILD` command
- Manually copy from `external_libs/prebuilt/bin/stringutils.dll` to `build/Release/`

**Error: "Developer Command Prompt not found"**
- Search for "Developer Command Prompt for VS 2022" in Start Menu
- Or use "x64 Native Tools Command Prompt for VS 2022"

## Alternative: Manual Build (without BUILD_ALL.bat)

### Build Static Library Manually:
```cmd
cd external_libs\mathlib_project
cl /c /EHsc mathlib.cpp
lib mathlib.obj /OUT:mathlib.lib
```

### Build Dynamic Library Manually:
```cmd
cd external_libs\stringutils_project
cl /LD /DSTRINGUTILS_BUILD /EHsc stringutils.cpp /Fe:stringutils.dll
```

Then manually copy files to `external_libs/prebuilt/` structure.
