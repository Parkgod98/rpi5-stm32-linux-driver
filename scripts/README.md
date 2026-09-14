# Scripts

Repeated commands belong here instead of chat history.

Planned groups:
- `setup/` — environment checks and dependency/setup helpers
- `build/` — firmware/userspace/driver/DT build helpers
- `load/` — module/overlay load-unload helpers
- `test/` — integration tests
- `fault/` — fault injection runners
- `benchmark/` — latency/performance runners

Every script should:
- fail loudly on unexpected errors
- print the environment/target it is operating on when relevant
- avoid hiding failures with unconditional `|| true`
- be referenced from docs or root Makefile
