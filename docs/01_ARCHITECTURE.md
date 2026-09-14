# Architecture

## Target stack

```text
+------------------------------+
| C++ userspace application    |
| f103ctl                      |
+--------------+---------------+
               |
               | read/ioctl/poll
               v
+------------------------------+
| /dev/f103bridge              |
| miscdevice interface         |
+--------------+---------------+
               |
               v
+------------------------------+
| Custom Linux SPI driver      |
| - probe/remove               |
| - request/response           |
| - CRC/sequence validation    |
| - timeout/error handling     |
| - IRQ/event queue            |
+--------------+---------------+
               |
               | Linux SPI core
               v
+------------------------------+
| Raspberry Pi 5 SPI controller|
+--------------+---------------+
               |
               | MOSI/MISO/SCLK/CS
               v
+------------------------------+
| STM32F103RB firmware         |
| - SPI peripheral             |
| - protocol parser            |
| - command handlers           |
| - CRC/sequence               |
| - event/READY GPIO           |
+------------------------------+
               |
               | GPIO event/IRQ
               +---------------------> Raspberry Pi GPIO IRQ
```

## Data flows

### Synchronous control path

Example: `SET_LED`

```text
f103ctl
 -> ioctl()
 -> custom driver
 -> SPI request frame
 -> STM32 command parser
 -> GPIO/LED update
 -> SPI response frame
 -> driver validation
 -> ioctl return
 -> user-visible result
```

### Status query path

```text
f103ctl status
 -> driver GET_STATUS transaction
 -> STM32 status snapshot
 -> CRC + sequence validation
 -> structured status returned to userspace
```

### Asynchronous event path

Target design:

```text
STM32 event/button
 -> STM32 asserts EVENT/READY GPIO
 -> Raspberry Pi GPIO IRQ
 -> kernel IRQ handler
 -> deferred/event state update if required
 -> wake up wait queue
 -> userspace poll()/blocking read wakes
 -> f103ctl prints event
```

## Design principles

1. **Correctness before kernel integration**: establish the physical link and protocol using userspace `spidev` first.
2. **Explicit ownership**: Raspberry Pi is the SPI host/controller-side initiator; STM32 is the SPI peripheral.
3. **Bounded waits**: no infinite blocking on firmware response.
4. **Protocol integrity**: sequence number and CRC allow detection of stale/corrupt responses.
5. **Observable failures**: counters and logs must make failures diagnosable.
6. **Minimal IRQ work**: avoid long SPI work or complex processing directly in hard IRQ context.
7. **Stable UAPI**: userspace should not depend on internal kernel structures.

## Important distinction for interview

The project uses the existing Raspberry Pi/Linux SPI controller support. The custom kernel component is a **SPI peripheral/protocol driver** for the STM32-based device, not a new SPI controller driver.

## Decisions still to confirm on hardware

Do not fill these by assumption:

- exact Raspberry Pi SPI bus and chip select
- exact Raspberry Pi GPIO used for event/READY
- exact STM32 SPI instance and AF pin mapping
- IRQ polarity and trigger mode
- initial SPI clock frequency/mode
- whether READY and EVENT are one line or separate lines

Confirmed values belong in `docs/03_HW_SETUP.md`.
