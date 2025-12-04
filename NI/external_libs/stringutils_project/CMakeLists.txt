# MIT License
# Standalone Dynamic Library Build

cmake_minimum_required(VERSION 3.10)
project(StringUtilsDLL VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)

# Create shared library (DLL)
add_library(stringutils SHARED stringutils.cpp)

# Define export macro when building
target_compile_definitions(stringutils PRIVATE STRINGUTILS_BUILD)

# Install rules
install(TARGETS stringutils
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)

install(FILES stringutils.h
    DESTINATION include
)
