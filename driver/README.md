# Linux Driver

Target: custom Linux SPI peripheral/protocol driver for the STM32F103RB-based device.

Implementation begins only after userspace `spidev` communication and protocol v1 are verified.

Planned components:
- SPI `probe/remove`
- request/response transaction layer
- CRC/sequence/timeout handling
- miscdevice `/dev/f103bridge`
- stable UAPI
- GPIO IRQ/event delivery
- wait queue + `poll()`
- error/stat counters

Do not implement a Raspberry Pi SPI controller driver here; that is outside project scope.
