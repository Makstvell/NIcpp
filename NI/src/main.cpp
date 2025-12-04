#include "core/orchestrator/orchestrator.h"

// Include ONLY our linking headers, NOT the original library headers
#include "../external_libs/prebuilt/include/mathlib.h"
#include "../external_libs/prebuilt/include/stringutils.h"

#include <iostream>

int main()
{
    std::cout << "=== NI Application - Using Prebuilt Libraries ===" << std::endl << std::endl;

    // ==========================================
    // Example 1: Using PREBUILT STATIC Library (mathlib.lib)
    // The code from mathlib.lib is EMBEDDED into NI.exe
    // ==========================================
    std::cout << "--- Static Library Example (mathlib.lib) ---" << std::endl;

    int sum = MathAdd(15, 27);
    std::cout << "MathAdd(15, 27) = " << sum << std::endl;

    int product = MathMultiply(8, 9);
    std::cout << "MathMultiply(8, 9) = " << product << std::endl;

    int numbers[] = {10, 20, 30, 40, 50};
    double average = MathAverage(numbers, 5);
    std::cout << "MathAverage({10, 20, 30, 40, 50}) = " << average << std::endl;

    std::cout << std::endl;

    // ==========================================
    // Example 2: Using PREBUILT DYNAMIC Library (stringutils.dll)
    // The DLL is loaded at RUNTIME and must be in the same folder as NI.exe
    // ==========================================
    std::cout << "--- Dynamic Library Example (stringutils.dll) ---" << std::endl;

    const char* text = "Hello World";

    char* upper = StringToUpper(text);
    std::cout << "StringToUpper(\"" << text << "\") = \"" << upper << "\"" << std::endl;
    StringFree(upper);

    char* lower = StringToLower(text);
    std::cout << "StringToLower(\"" << text << "\") = \"" << lower << "\"" << std::endl;
    StringFree(lower);

    char* reversed = StringReverse(text);
    std::cout << "StringReverse(\"" << text << "\") = \"" << reversed << "\"" << std::endl;
    StringFree(reversed);

    const char* sentence = "The quick brown fox jumps";
    int wordCount = StringCountWords(sentence);
    std::cout << "StringCountWords(\"" << sentence << "\") = " << wordCount << std::endl;

    std::cout << std::endl;

    // ==========================================
    // Key Differences Explained:
    // ==========================================
    std::cout << "--- Understanding Static vs Dynamic ---" << std::endl;
    std::cout << "Static (mathlib.lib):" << std::endl;
    std::cout << "  - Code is inside NI.exe" << std::endl;
    std::cout << "  - No separate file needed" << std::endl;
    std::cout << "  - Linked at compile time" << std::endl;
    std::cout << std::endl;
    std::cout << "Dynamic (stringutils.dll):" << std::endl;
    std::cout << "  - Code is in separate DLL file" << std::endl;
    std::cout << "  - DLL must exist at runtime" << std::endl;
    std::cout << "  - Loaded when program starts" << std::endl;
    std::cout << std::endl;

    // ==========================================
    // Original: Start Orchestrator
    // ==========================================
    std::cout << "--- Starting Orchestrator ---" << std::endl;
    std::unique_ptr<NI::Orchestrator> orchestrator = std::make_unique<NI::Orchestrator>();
    orchestrator->Start();

    return 0;
}