// MIT License
// Standalone Static Library Implementation

#include "mathlib.h"

extern "C" {
    int MathAdd(int a, int b)
    {
        return a + b;
    }

    int MathMultiply(int a, int b)
    {
        return a * b;
    }

    double MathAverage(const int* values, int count)
    {
        if (count == 0) return 0.0;

        int sum = 0;
        for (int i = 0; i < count; ++i)
        {
            sum += values[i];
        }

        return static_cast<double>(sum) / count;
    }
}
