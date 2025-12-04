# External Libraries - Build Instructions

This folder contains two independent library projects that will be built separately and then used in the main NI project.

## Directory Structure

```
external_libs/
├── mathlib_project/          # Static library source
│   ├── mathlib.h
│   ├── mathlib.cpp
│   ├── CMakeLists.txt
│   └── build.bat
├── stringutils_project/      # Dynamic library source
│   ├── stringutils.h
│   ├── stringutils.cpp
│   ├── CMakeLists.txt
│   └── build.bat
├── BUILD_ALL.bat             # Build both libraries
└── prebuilt/                 # Output folder (created after build)
    ├── lib/                  # .lib files
    ├── bin/                  # .dll files
    └── include/              # .h files
```

## How to Build

### Option 1: Build Everything (Recommended)

Open **Developer Command Prompt for VS 2022** and run:

```bash
cd c:\Users\maxim\Desktop\NI\external_libs
BUILD_ALL.bat
```

This will:
1. Build the static library (mathlib.lib)
2. Build the dynamic library (stringutils.dll + stringutils.lib)
3. Copy all output files to `prebuilt/` folder

### Option 2: Build Individually

**Build Static Library:**
```bash
cd mathlib_project
build.bat
```

**Build Dynamic Library:**
```bash
cd stringutils_project
build.bat
```

## Output Files

After building, you'll have:

| File | Type | Description |
|------|------|-------------|
| `prebuilt/lib/mathlib.lib` | Static Library | Contains compiled code |
| `prebuilt/lib/stringutils.lib` | Import Library | Links to DLL |
| `prebuilt/bin/stringutils.dll` | Dynamic Library | Runtime code |
| `prebuilt/include/*.h` | Headers | Function declarations |

## Using in Main Project

The main NI project will:
1. Link against `mathlib.lib` (static) - code embedded in NI.exe
2. Link against `stringutils.lib` (import) - loads stringutils.dll at runtime
3. Copy `stringutils.dll` to build output directory

**Important:** The DLL must be in the same directory as NI.exe when running!

## Differences

**Static Library (mathlib.lib):**
- Code is compiled INTO your executable
- No separate file needed at runtime
- Larger executable size

**Dynamic Library (stringutils.dll):**
- Code is SEPARATE from your executable
- DLL file must be present at runtime
- Smaller executable size
- Can update DLL without recompiling executable
