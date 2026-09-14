# Roadmap

This roadmap is authoritative for phase order. A phase is complete only when all exit criteria are verified on the actual environment and recorded in `CURRENT_STATUS.md`.

## Phase 0 — Environment and inventory

### Tasks
- Confirm exact Raspberry Pi model and OS/kernel version.
- Confirm exact STM32 board (for example NUCLEO-F103RB if applicable) and MCU.
- Confirm available cables, debugger/programmer, jumper wires, breadboard if needed.
- Install/verify STM32CubeIDE or chosen STM32 build environment.
- Verify Raspberry Pi build tools, Git, C/C++ compiler, kernel headers/source compatibility.
- Enable SPI on Raspberry Pi.
- Record all versions and commands.

### Exit criteria
- [ ] `uname -a` recorded.
- [ ] Raspberry Pi model recorded.
- [ ] STM32 board/MCU identity recorded.
- [ ] STM32 can be flashed with a minimal firmware.
- [ ] SPI device/controller visibility confirmed on Raspberry Pi.
- [ ] Exact pin mapping is documented but hardware is not yet assumed functional.

## Phase 1 — Hardware bring-up

### Tasks
- Wire common ground and SPI signals.
- Start at a conservative SPI clock.
- Implement minimal STM32 SPI peripheral receive/transmit path.
- Validate with a fixed deterministic test pattern.

### Exit criteria
- [ ] Wiring photo/diagram stored or referenced.
- [ ] Pi sends a known byte pattern and STM32 receives it correctly.
- [ ] STM32 returns a known response and Pi receives it correctly.
- [ ] Repeatable success across reboot/reflash.

## Phase 2 — Userspace SPI prototype

### Tasks
- Use `spidev` from Python or C/C++ for initial host communication.
- Implement `ECHO` and simple LED/status commands.
- Add transaction logging.
- Remove temporary debug delays unless explicitly justified.

### Exit criteria
- [ ] `ECHO` works repeatedly from userspace.
- [ ] `SET_LED` changes real hardware state.
- [ ] `GET_STATUS` returns structured data.
- [ ] At least 1,000 consecutive basic transactions complete without unexplained corruption.

## Phase 3 — Versioned protocol

### Tasks
- Freeze v1 frame layout.
- Add magic/version/opcode/sequence/payload length/CRC.
- Define request/response semantics and error codes.
- Define READY/event timing behavior.
- Add parser validation on both sides.

### Exit criteria
- [ ] Protocol specification committed.
- [ ] Invalid magic/version/length/CRC rejected.
- [ ] Sequence mismatch detected.
- [ ] Protocol tests cover every v1 opcode.
- [ ] 10,000 `ECHO` transactions pass at baseline settings or any failures are understood and fixed.

## Phase 4 — Device Tree and driver binding

### Tasks
- Write custom Device Tree overlay/node.
- Define custom `compatible` string.
- Ensure conflicting `spidev` binding is removed/avoided for the selected CS.
- Create minimal Linux `spi_driver` with `of_match_table`.

### Exit criteria
- [ ] Device appears in Linux device model as intended.
- [ ] Custom driver binds automatically.
- [ ] `probe()` and `remove()` paths verified through logs.
- [ ] Module load/unload is repeatable.

## Phase 5 — Kernel transaction layer

### Tasks
- Move SPI protocol transaction logic into custom driver.
- Implement serialization/deserialization safely.
- Add timeout, CRC, sequence, and firmware error handling.
- Protect shared transaction state.

### Exit criteria
- [ ] Kernel driver performs `GET_INFO`, `GET_STATUS`, `SET_LED`, and `ECHO` successfully.
- [ ] No userspace `spidev` path is required for normal operation.
- [ ] Repeated load/unload does not leak or crash.
- [ ] Error paths return meaningful errno values.

## Phase 6 — `/dev` userspace interface

### Tasks
- Register `miscdevice` (preferred unless design changes).
- Define stable UAPI header.
- Implement `read` and/or `ioctl` operations.
- Implement `f103ctl` C++ CLI.

### Target CLI

```text
f103ctl info
f103ctl status
f103ctl led on
f103ctl led off
f103ctl period <ms>
f103ctl echo <count>
```

### Exit criteria
- [ ] `/dev/f103bridge` appears only when driver is bound.
- [ ] C++ application exercises all v1 synchronous commands.
- [ ] Invalid userspace inputs are rejected safely.
- [ ] UAPI structures are documented.

## Phase 7 — IRQ and asynchronous event delivery

### Tasks
- Add STM32 event/READY GPIO behavior.
- Configure GPIO/IRQ from Device Tree or descriptor API.
- Keep hard IRQ handler minimal.
- Add wait queue/event state.
- Expose events through `poll()` or blocking `read()`.

### Exit criteria
- [ ] Real STM32 event wakes blocked userspace without polling loop.
- [ ] Repeated events are not silently lost under normal test load.
- [ ] Driver unload with waiting userspace is handled cleanly.
- [ ] IRQ storm/stuck-line behavior is considered and tested at least minimally.

## Phase 8 — Robustness and fault injection

### Faults to inject
- bad CRC
- wrong sequence
- dropped response
- delayed response/timeout
- STM32 reset during host operation
- malformed payload length
- repeated rapid commands

### Exit criteria
- [ ] Every injected fault has an expected host-visible result.
- [ ] Kernel never panics, deadlocks, or waits forever.
- [ ] Error counters/logs make root cause observable.
- [ ] Driver recovers for subsequent valid transactions when recovery is expected.

## Phase 9 — Performance and tracing

### Tasks
- Add repeatable benchmark script/application mode.
- Measure round-trip latency for `ECHO` and at least one real command.
- Record p50/p95/p99/max and success rate.
- Repeat under CPU load.
- Use `perf`, `ftrace`, or relevant tracing only where it helps explain behavior.

### Exit criteria
- [ ] Baseline results saved under `results/`.
- [ ] CPU-load results saved.
- [ ] Methodology documented enough to reproduce.
- [ ] At least one measured bottleneck/observation is explained from evidence.

## Phase 10 — Portfolio and interview hardening

### Tasks
- Rewrite README from actual results.
- Add final architecture and wiring diagrams.
- Add measured results, not planned numbers.
- Record major bugs and how they were diagnosed.
- Complete interview questions with answers in own words.
- Re-run clean setup/build/test checklist.

### Exit criteria
- [ ] README contains no future-tense claims presented as completed work.
- [ ] Fresh clone instructions work.
- [ ] Core demo can be reproduced.
- [ ] User can explain every layer and major design decision without assistance.

## Branch strategy

Suggested feature branches:

- `feat/hw-bringup`
- `feat/spi-userspace`
- `feat/protocol-v1`
- `feat/device-tree`
- `feat/kernel-driver`
- `feat/userspace-api`
- `feat/irq-event`
- `feat/robustness`
- `feat/performance`

`main` should contain only reviewed/verified milestones.
