# Device Tree

This directory will contain the custom overlay/node that instantiates the STM32F103RB-based SPI peripheral on Raspberry Pi 5.

Planned responsibilities:
- enable/select the intended SPI controller and chip-select
- instantiate the peripheral node
- define a project-specific `compatible` string
- describe optional READY/EVENT GPIO/IRQ
- avoid conflicting `spidev` ownership on the same chip-select

Do not hard-code final GPIO/bus values until they are verified and recorded in `docs/03_HW_SETUP.md`.
