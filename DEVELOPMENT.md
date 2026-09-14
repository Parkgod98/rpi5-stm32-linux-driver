# Development Workflow

## Working model

- `main`: verified milestones only
- work happens on phase-oriented branches
- each PR should satisfy one coherent milestone or design change
- user reviews/merges PRs

Suggested branches:

- `feat/hw-bringup`
- `feat/spi-userspace`
- `feat/protocol-v1`
- `feat/device-tree`
- `feat/kernel-driver`
- `feat/userspace-api`
- `feat/irq-event`
- `feat/robustness`
- `feat/performance`

## Session start

1. Read `docs/CURRENT_STATUS.md`.
2. Read current phase in `docs/02_ROADMAP.md`.
3. Pull latest `main`.
4. Create/continue the branch for the current phase.
5. Reproduce the last verified result before extending it if the environment changed.

## Session end

Before stopping:

1. Run relevant tests.
2. Save useful logs/results.
3. Update `docs/CURRENT_STATUS.md`.
4. Update any design doc affected by changes.
5. Commit with a message describing the verified change, not an intention.

## Commit style

Examples:

- `feat: add userspace SPI echo transaction`
- `feat: bind f103 bridge through device tree`
- `test: add bad CRC fault injection`
- `fix: handle response timeout without stale sequence reuse`
- `docs: record phase 2 benchmark evidence`

## Pull request checklist

- scope matches current phase
- build commands documented
- actual hardware test result included when hardware behavior changes
- no unverified completion claims
- `CURRENT_STATUS.md` updated
- no magic delays/constants without explanation
- any new hardware assumption documented

## Generated code / AI assistance

AI may accelerate implementation, but generated code is not trusted by default.

For every generated kernel/firmware path:
- explain what it does
- compile it
- exercise it on actual hardware where applicable
- inspect error paths
- understand enough to answer interview questions about it

If the developer cannot explain a critical path, the phase is not interview-ready even if it works.
