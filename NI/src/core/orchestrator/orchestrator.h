#include <memory>

namespace NI
{
    class Orchestrator
    {
    public:
        Orchestrator();
        ~Orchestrator();

        void Start();

    private:
        std::unique_ptr<int> engine;
    };
}
