# STM32 Firmware

Target: STM32F103RB SPI-peripheral firmware.

Implementation starts in Phase 1 after exact board/pin mapping is confirmed.

Planned internal areas:
- SPI peripheral bring-up
- protocol parser
- command handlers
- CRC/sequence handling
- READY/EVENT GPIO
- fault injection hooks for test builds

Do not generate a full Cube project until the exact board/toolchain is confirmed in `docs/03_HW_SETUP.md`.
