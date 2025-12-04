// MIT License
// Standalone Dynamic Library

#ifndef STRINGUTILS_DLL_H
#define STRINGUTILS_DLL_H

#ifdef _WIN32
    #ifdef STRINGUTILS_BUILD
        #define STRINGUTILS_API __declspec(dllexport)
    #else
        #define STRINGUTILS_API __declspec(dllimport)
    #endif
#else
    #define STRINGUTILS_API
#endif

extern "C" {
    // Allocates and returns a new uppercase string (caller must free)
    STRINGUTILS_API char* StringToUpper(const char* str);

    // Allocates and returns a new lowercase string (caller must free)
    STRINGUTILS_API char* StringToLower(const char* str);

    // Allocates and returns a reversed string (caller must free)
    STRINGUTILS_API char* StringReverse(const char* str);

    // Returns word count (no allocation)
    STRINGUTILS_API int StringCountWords(const char* str);

    // Free memory allocated by library functions
    STRINGUTILS_API void StringFree(char* str);
}

#endif // STRINGUTILS_DLL_H
