# MIT License
# Standalone Static Library Build

cmake_minimum_required(VERSION 3.10)
project(MathLibStatic VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)

# Create static library
add_library(mathlib STATIC mathlib.cpp)

# Install rules
install(TARGETS mathlib
    ARCHIVE DESTINATION lib
)

install(FILES mathlib.h
    DESTINATION include
)
