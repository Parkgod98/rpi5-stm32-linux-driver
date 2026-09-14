# Project Goal

## Objective

Build a reproducible end-to-end Linux device-driver project that connects a Raspberry Pi 5 host to an STM32F103RB-based peripheral.

The project must demonstrate the whole path from hardware to application:

`STM32 firmware <-> SPI/GPIO <-> Raspberry Pi Linux kernel driver <-> /dev interface <-> C++ application`

The project is intended to deepen practical understanding of:

- Embedded Linux
- Linux device model
- Device Tree and driver binding
- Linux SPI subsystem
- kernel/user boundary
- asynchronous event handling
- HW-SW interface design
- error handling and robustness
- latency/performance measurement

## Functional target

The STM32 side behaves as a custom peripheral that exposes a small command protocol.

Initial command set:

- `GET_INFO`: firmware/protocol version
- `GET_STATUS`: uptime, LED state, button/event state, error counters
- `SET_LED`: control an STM32 output
- `SET_PERIOD`: configure a periodic/event parameter
- `ECHO`: deterministic round-trip test for validation and benchmarking

The STM32 can also signal an asynchronous event to Raspberry Pi using a dedicated GPIO/IRQ line.

## System target

The completed Linux side should include:

- Device Tree description for the SPI peripheral
- custom Linux `spi_driver`
- driver `probe`/`remove` lifecycle
- SPI request/response transaction layer
- bounded timeout handling
- protocol validation including sequence and CRC
- `/dev` userspace interface, preferably via `miscdevice`
- control path through `ioctl` and/or `read/write`
- asynchronous event path to userspace through `poll()` or blocking read
- C++ CLI application
- reproducible fault tests
- repeatable latency benchmark

## Explicit non-goals

This project does NOT initially aim to:

- write the Raspberry Pi SPI controller driver from scratch
- implement DMA engine drivers
- implement PCIe/USB/DRM controller drivers
- build a production-grade general-purpose MCU framework
- optimize before correctness and observability are established

## Definition of final success

The project is considered complete when all of the following are true:

1. Hardware wiring and pin mapping are documented and reproducible.
2. Raspberry Pi userspace can communicate with STM32 using SPI before any custom kernel driver is introduced.
3. The packet protocol is versioned and rejects malformed/CRC-invalid responses.
4. Device Tree instantiates the custom peripheral and the kernel driver binds automatically.
5. A userspace program controls/queries the STM32 through the custom driver instead of `spidev`.
6. STM32 events propagate to userspace through an interrupt-driven path.
7. Injected CRC errors, dropped responses, and timeout conditions are handled without kernel crash/deadlock.
8. A repeatable benchmark records at least success rate and p50/p95/p99/max round-trip latency.
9. Architecture, protocol, test plan, results, and interview notes reflect the actual implementation.
10. The entire stack can be explained without relying on generated text or hidden assumptions.
