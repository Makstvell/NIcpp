// MIT License
// Standalone Static Library

#ifndef MATHLIB_H
#define MATHLIB_H

// Export function declarations
extern "C" {
    int MathAdd(int a, int b);
    int MathMultiply(int a, int b);
    double MathAverage(const int* values, int count);
}

#endif // MATHLIB_H
