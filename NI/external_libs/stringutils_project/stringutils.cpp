// MIT License
// Standalone Dynamic Library Implementation

#include "stringutils.h"
#include <cstring>
#include <cctype>
#include <cstdlib>

extern "C" {
    char* StringToUpper(const char* str)
    {
        if (!str) return nullptr;

        size_t len = strlen(str);
        char* result = (char*)malloc(len + 1);

        for (size_t i = 0; i < len; ++i)
        {
            result[i] = toupper(str[i]);
        }
        result[len] = '\0';

        return result;
    }

    char* StringToLower(const char* str)
    {
        if (!str) return nullptr;

        size_t len = strlen(str);
        char* result = (char*)malloc(len + 1);

        for (size_t i = 0; i < len; ++i)
        {
            result[i] = tolower(str[i]);
        }
        result[len] = '\0';

        return result;
    }

    char* StringReverse(const char* str)
    {
        if (!str) return nullptr;

        size_t len = strlen(str);
        char* result = (char*)malloc(len + 1);

        for (size_t i = 0; i < len; ++i)
        {
            result[i] = str[len - 1 - i];
        }
        result[len] = '\0';

        return result;
    }

    int StringCountWords(const char* str)
    {
        if (!str) return 0;

        int count = 0;
        bool inWord = false;

        while (*str)
        {
            if (isspace(*str))
            {
                inWord = false;
            }
            else if (!inWord)
            {
                inWord = true;
                count++;
            }
            str++;
        }

        return count;
    }

    void StringFree(char* str)
    {
        if (str)
        {
            free(str);
        }
    }
}
