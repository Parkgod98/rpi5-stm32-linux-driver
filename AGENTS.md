# AGENTS.md

This repository is designed to be resumed safely after interruptions. Any AI assistant or developer working here must follow these rules.

## 1. Read before changing anything

Always read, in this order:

1. `docs/CURRENT_STATUS.md`
2. `docs/02_ROADMAP.md`
3. The design document relevant to the current phase
4. Existing code and test results for the current phase

Do not infer progress from the roadmap. `CURRENT_STATUS.md` is the authoritative progress record.

## 2. Never claim unverified completion

A feature is DONE only when its documented exit criteria are satisfied with evidence.

Examples:
- "SPI configured" is not DONE. A repeatable host-to-MCU transaction must succeed.
- "Driver implemented" is not DONE. The driver must bind, expose the intended interface, and pass the relevant test.
- "Error handling added" is not DONE. Fault injection must exercise the error path.

Never write README/portfolio claims for work that has not been verified on hardware.

## 3. One phase at a time

Do not skip ahead because later work looks interesting.

Required order:

`HW bring-up -> userspace SPI -> protocol -> Device Tree -> kernel driver -> userspace interface -> IRQ/event -> robustness -> performance -> documentation`

The current phase exit criteria must pass before the next phase starts, unless `CURRENT_STATUS.md` explicitly records an approved exception and reason.

## 4. Separate hardware, firmware, kernel, and application faults

Debug from the lowest confirmed layer upward.

Before blaming the kernel driver, verify:
- power and common ground
- wiring and pin mapping
- STM32 firmware state
- Raspberry Pi SPI availability
- userspace SPI communication
- protocol correctness

Do not hide timing bugs with arbitrary `sleep()` calls. If a delay is temporarily used to isolate a fault, document it and remove it before phase completion.

## 5. No guessed hardware values

Do not guess:
- GPIO numbers
- SPI bus/chip-select
- STM32 alternate-function pins
- active-high/active-low polarity
- kernel version-specific APIs

Confirm them from the actual board, schematic/manual, OS output, or source tree. Record the confirmed value in `docs/03_HW_SETUP.md`.

## 6. Keep code and documentation synchronized

When a design decision changes, update the relevant document in the same PR.

At the end of every working session update `docs/CURRENT_STATUS.md` with:
- current phase
- last verified result
- current blocker
- next three actions
- evidence/log locations
- things that must NOT be started yet

## 7. Prefer reproducible commands

Repeated commands belong in `scripts/` or the root `Makefile` rather than chat history.

Every build/test procedure must eventually be runnable from a documented command.

## 8. Kernel safety rules

- Treat kernel code as privileged code.
- Validate lengths and userspace inputs.
- Return meaningful negative errno values.
- Avoid unbounded waits.
- Protect shared state correctly.
- Never dereference userspace pointers directly.
- Keep IRQ handlers minimal; defer work when appropriate.
- Test unload/reload paths and error paths.

## 9. Scope of this project

The goal is a Linux SPI peripheral/protocol driver for a custom STM32F103RB-based device connected to Raspberry Pi 5. We are NOT implementing Raspberry Pi's SPI controller driver from scratch.

The target stack is:

`C++ app -> /dev interface -> custom Linux SPI driver -> Linux SPI core/controller -> SPI wires -> STM32F103RB firmware`

with an additional GPIO event line from STM32 to Raspberry Pi for asynchronous events.

## 10. Portfolio integrity

The project should eventually support claims such as:

> Raspberry Pi 5 and STM32F103RB were connected through a custom Linux device-driver stack, from Device Tree and kernel-space communication to a C++ userspace application, with robustness and latency verification.

Use only the subset that is actually completed and measured.
