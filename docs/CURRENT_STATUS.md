# Current Status

Last updated: 2026-09-14

## Current phase

**Phase 0 — Environment and inventory**

No hardware or software implementation is considered complete yet.

## Last verified result

- Repository created: `Parkgod98/rpi5-stm32-linux-driver`
- Project harness branch created: `chore/project-harness`
- Architecture and roadmap documents initialized

## Current blocker / required user input

Before hardware-specific implementation begins, confirm:

1. Exact STM32 board model printed on the board. Expected candidate: `NUCLEO-F103RB`, but do not assume.
2. Raspberry Pi 5 is available and boots normally.
3. Available jumper wires and how the STM32 board will be powered/programmed.
4. Raspberry Pi OS/kernel details from the commands below.

## Next actions

### On Raspberry Pi 5

Run and capture:

```bash
uname -a
cat /proc/device-tree/model; echo
cat /etc/os-release
lsblk
ls /dev/spidev* 2>/dev/null || true
lsmod | grep -E 'spi|gpio' || true
```

If SPI is not enabled, do not guess the fix from memory; follow the Raspberry Pi OS version in use and document the exact procedure.

### On STM32 side

- Confirm exact board model with a photo or printed identifier.
- Confirm STM32CubeIDE (or chosen toolchain) can detect/program the board.
- Do not configure final SPI pins until the exact board pin mapping is verified.

## Evidence collected

None yet from physical hardware.

Future logs should go under:

- `results/logs/`
- `results/latency/`
- `results/traces/`

## Do NOT start yet

Until Phase 0/1 evidence exists, do not:

- write the final Device Tree overlay
- assume GPIO numbers
- claim a working kernel driver
- write portfolio claims as completed work
- optimize SPI clock rate
- add IRQ/poll logic

## Resume protocol

If this project is resumed after a break:

1. Read this file.
2. Read `02_ROADMAP.md` for current phase exit criteria.
3. Inspect the latest merged PR and evidence.
4. Perform only the next listed actions unless new evidence changes the plan.
5. Update this file before ending the session.
