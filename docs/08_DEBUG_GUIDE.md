# Debug Guide

Debug from the lowest confirmed layer upward.

## Symptom: no SPI response

Check in order:
1. board power and common GND
2. exact MOSI/MISO/SCLK/CS wiring
3. SPI bus enabled on Raspberry Pi
4. SPI mode and clock
5. STM32 SPI peripheral configuration and chip-select behavior
6. known-pattern transfer with userspace tool
7. protocol framing
8. kernel driver only after userspace path is known-good

## Symptom: response shifted/stale

Likely areas:
- STM32 response not prepared before host clocks data
- host reading in same transaction before peripheral has processed request
- stale DMA/interrupt buffer
- sequence handling bug

Preferred design response: separate request and response with READY/event synchronization rather than arbitrary sleeps.

## Symptom: CRC failures

Check:
- identical CRC variant and byte order on both sides
- exact covered byte range
- packed frame size
- uninitialized padding/bytes
- transfer length and stale buffer content

Create golden vectors before blaming the physical link.

## Symptom: custom driver does not probe

Check:
- Device Tree node is actually loaded
- selected SPI controller is enabled
- `compatible` string exactly matches `of_match_table`
- chip-select is not still claimed by conflicting device/spidev node
- module is loaded and kernel log has no parse/resource error

## Symptom: kernel hangs or unload fails

Check:
- unbounded waits
- sleeping in wrong context
- mutex held across path that waits on itself
- work/IRQ still active during remove
- userspace waiters not woken on teardown

## Session rule

When a bug takes more than one attempt, add to `CURRENT_STATUS.md`:
- exact symptom
- last known-good layer
- hypotheses tested
- evidence that eliminated each hypothesis
- next experiment

Avoid random edits. Change one variable at a time where possible.
