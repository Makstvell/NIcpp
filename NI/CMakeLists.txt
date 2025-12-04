cmake_minimum_required(VERSION 3.20)

# Project name and language
project(NI LANGUAGES CXX)

# C++ standard (change 20 to 17 if needed)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# ======================================
# USING PREBUILT EXTERNAL LIBRARIES
# ======================================
# Path to prebuilt libraries
set(EXTERNAL_LIB_DIR "${CMAKE_SOURCE_DIR}/external_libs/prebuilt")

# Check if prebuilt libraries exist
set(MATHLIB_PATH "${EXTERNAL_LIB_DIR}/lib/mathlib.lib")
set(STRINGUTILS_LIB_PATH "${EXTERNAL_LIB_DIR}/lib/stringutils.lib")
set(STRINGUTILS_DLL_PATH "${EXTERNAL_LIB_DIR}/bin/stringutils.dll")

if(NOT EXISTS "${MATHLIB_PATH}")
    message(FATAL_ERROR
        "\n========================================\n"
        "ERROR: Prebuilt libraries not found!\n"
        "========================================\n"
        "Please build the external libraries first:\n"
        "  cd external_libs\n"
        "  BUILD_ALL.bat\n"
        "\n"
        "Or run start.bat which does everything automatically.\n"
        "========================================\n"
    )
endif()

# 1. Import STATIC LIBRARY (mathlib.lib)
# The static library code will be embedded into NI.exe
add_library(mathlib_external STATIC IMPORTED)
set_target_properties(mathlib_external PROPERTIES
    IMPORTED_LOCATION "${MATHLIB_PATH}"
    IMPORTED_LOCATION_DEBUG "${MATHLIB_PATH}"
    IMPORTED_LOCATION_RELEASE "${MATHLIB_PATH}"
)

# 2. Import DYNAMIC LIBRARY (stringutils.dll)
# The DLL will be loaded at runtime
add_library(stringutils_external SHARED IMPORTED)
set_target_properties(stringutils_external PROPERTIES
    IMPORTED_LOCATION "${STRINGUTILS_DLL_PATH}"
    IMPORTED_LOCATION_DEBUG "${STRINGUTILS_DLL_PATH}"
    IMPORTED_LOCATION_RELEASE "${STRINGUTILS_DLL_PATH}"
    IMPORTED_IMPLIB "${STRINGUTILS_LIB_PATH}"
    IMPORTED_IMPLIB_DEBUG "${STRINGUTILS_LIB_PATH}"
    IMPORTED_IMPLIB_RELEASE "${STRINGUTILS_LIB_PATH}"
)

# ======================================
# MAIN EXECUTABLE
# ======================================
# Collect application source files (non-recursive first)
file(GLOB MAIN_SRC "${CMAKE_SOURCE_DIR}/src/*.cpp")

# Recursively collect from core directory
file(GLOB_RECURSE CORE_SRC "${CMAKE_SOURCE_DIR}/src/core/*.cpp")

# Combine all sources
set(SRC_FILES ${MAIN_SRC} ${CORE_SRC})

add_executable(NI ${SRC_FILES})

# Include directories
target_include_directories(NI
    PRIVATE
        ${CMAKE_SOURCE_DIR}/src
        ${CMAKE_SOURCE_DIR}/src/core
        ${CMAKE_SOURCE_DIR}/src/external
)

# Link prebuilt libraries to the executable
target_link_libraries(NI
    PRIVATE
        mathlib_external        # Static library - embedded in NI.exe
        stringutils_external    # Dynamic library - needs stringutils.dll at runtime
)

# Copy DLL to output directory so it's available at runtime
add_custom_command(TARGET NI POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${STRINGUTILS_DLL_PATH}"
        "$<TARGET_FILE_DIR:NI>"
    COMMENT "Copying stringutils.dll to output directory"
)

# Print build information
message(STATUS "========================================")
message(STATUS "NI Project Configuration")
message(STATUS "========================================")
message(STATUS "Static Library:  ${MATHLIB_PATH}")
message(STATUS "Dynamic Library: ${STRINGUTILS_DLL_PATH}")
message(STATUS "Import Library:  ${STRINGUTILS_LIB_PATH}")
message(STATUS "========================================")
