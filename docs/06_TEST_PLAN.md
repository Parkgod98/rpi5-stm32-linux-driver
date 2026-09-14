# Test Plan

The project is not complete because code compiles. Each layer must have observable pass/fail criteria.

## Layer 1 — Hardware
- known MOSI pattern reaches STM32
- known MISO response reaches Pi
- repeated reboot/reflash does not change expected behavior

## Layer 2 — Userspace SPI
- ECHO: 1,000 consecutive successful transactions initially
- SET_LED: hardware state changes as commanded
- GET_STATUS: returned state matches hardware
- invalid opcode receives defined error response

## Layer 3 — Protocol
- wrong magic rejected
- unsupported version rejected
- oversized payload length rejected
- bad CRC rejected
- wrong sequence rejected
- every v1 opcode has at least one positive test

## Layer 4 — Device Tree / binding
- custom device instantiated
- custom driver binds
- probe/remove logs confirm lifecycle
- repeated load/unload works

## Layer 5 — Kernel transaction layer
- GET_INFO/GET_STATUS/SET_LED/ECHO work through kernel driver
- SPI transfer failure is surfaced
- timeout is bounded
- CRC and sequence errors are surfaced

## Layer 6 — UAPI
- expected commands work through `/dev/f103bridge`
- malformed ioctl/read inputs rejected
- application handles driver errors cleanly
- permission/absence cases are understandable

## Layer 7 — IRQ/event
- physical STM32 event wakes userspace blocked in `poll()` or blocking read
- burst events tested
- event while userspace is not waiting tested
- driver removal while userspace waits tested

## Layer 8 — Fault injection
Required injected failures:

| Fault | Expected behavior |
|---|---|
| bad CRC | transaction rejected, error counted, no crash |
| wrong sequence | stale/mismatched response rejected |
| dropped response | bounded timeout |
| delayed response | timeout or defined late-response handling |
| STM32 reset | current op fails cleanly; later recovery tested |
| malformed payload | parser rejects safely |
| repeated rapid requests | no deadlock/panic |

## Layer 9 — Long/repeat tests
- 10,000 ECHO transactions at baseline
- repeated driver load/unload cycle
- repeated LED/status operations
- test under CPU load

## Evidence standard

Every important test should preserve enough evidence to reproduce the claim:
- command used
- environment/kernel version
- test count
- result summary
- relevant logs

Raw logs belong under `results/logs/`. Summaries belong in documentation.
