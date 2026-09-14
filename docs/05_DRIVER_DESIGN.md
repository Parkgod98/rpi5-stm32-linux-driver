# Linux Driver Design

Status: design target. Implementation begins only after userspace SPI/protocol validation.

## Driver type

Custom Linux SPI peripheral/protocol driver bound through Device Tree.

Not in scope: Raspberry Pi SPI controller driver.

## Planned lifecycle

### probe
- obtain SPI device and configuration
- acquire optional GPIO/IRQ descriptors
- initialize locks/state/wait queue
- verify device identity with `GET_INFO` if appropriate
- register userspace interface (`miscdevice` preferred)
- enable interrupt path only after state is ready

### remove
- stop accepting new work
- disable/free IRQ path as appropriate
- wake blocked userspace with shutdown/error state
- deregister miscdevice
- release resources through managed APIs where practical

## Internal layers

1. **transport**: one SPI transfer/request-response primitive
2. **protocol**: frame encode/decode, CRC, sequence, status mapping
3. **device operations**: get info/status, set LED/period, echo
4. **event path**: IRQ, event state, wait queue
5. **UAPI**: read/ioctl/poll exposed to userspace

Keeping these concerns separate should make testing/debugging easier.

## Concurrency model

Initial design should serialize synchronous SPI transactions with a mutex unless evidence requires more concurrency. Correctness is more important than speculative parallelism.

State potentially shared with IRQ context must use an appropriate primitive; do not use a sleeping lock in hard IRQ context.

## Userspace interface

Preferred device node:

`/dev/f103bridge`

Candidate API:
- `read()` for status or event data
- `ioctl()` for typed control operations
- `poll()` for asynchronous events

The final API should be small and stable. Do not expose kernel-private structures directly.

## Error mapping

Candidate errno mapping, subject to implementation review:
- malformed userspace request -> `-EINVAL`
- device not available/shutting down -> `-ENODEV`
- timeout -> `-ETIMEDOUT`
- CRC/protocol integrity failure -> `-EBADMSG` or suitable alternative
- SPI transfer error -> propagated/normalized negative errno

Document actual choices when implemented.

## IRQ/event design

Hard IRQ handler should do the minimum required work. Depending on GPIO semantics, use threaded IRQ or defer processing if SPI transaction/work may sleep.

Target userspace behavior:

```text
poll(fd, ...)
  sleeps
STM32 asserts event GPIO
  kernel handles event
  wait queue wakes
poll returns readable/event state
```

## Kernel safety checklist

- [ ] no direct dereference of userspace pointers
- [ ] all UAPI lengths/ranges validated
- [ ] no unbounded waits
- [ ] SPI errors checked
- [ ] sequence/CRC failures observable
- [ ] module unload path tested repeatedly
- [ ] blocked readers/pollers handled during removal
- [ ] fault injection does not panic or deadlock kernel
