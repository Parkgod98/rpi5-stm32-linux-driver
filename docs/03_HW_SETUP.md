# Hardware Setup

This file must contain only confirmed hardware facts. Unknown values stay `TBD` until verified.

## Inventory

| Item | Value | Verified? |
|---|---|---|
| Host board | Raspberry Pi 5 | expected, verify physically |
| Host OS | TBD | no |
| Kernel | TBD | no |
| MCU | STM32F103RB | expected, verify physically |
| STM32 board | TBD | no |
| Programmer/debugger | TBD | no |
| Power method | TBD | no |

## Planned connection

Raspberry Pi acts as SPI host. STM32 acts as SPI peripheral.

Required signals:

- MOSI
- MISO
- SCLK
- CS/NSS
- GND
- one GPIO from STM32 to Raspberry Pi for READY/EVENT

Do not connect power rails between boards until the chosen power method is explicitly verified. Common ground is required for signaling.

## Pin mapping

Fill only after confirming actual board pinouts.

| Signal | Raspberry Pi 5 | STM32F103RB board | Notes |
|---|---|---|---|
| MOSI | TBD | TBD | |
| MISO | TBD | TBD | |
| SCLK | TBD | TBD | |
| CS/NSS | TBD | TBD | |
| EVENT/READY | TBD | TBD | STM32 -> Pi |
| GND | TBD | TBD | common ground |

## SPI configuration

| Parameter | Initial value | Final value |
|---|---:|---:|
| mode | TBD | TBD |
| bits/word | 8 planned | TBD |
| clock | conservative, TBD | TBD |
| CS polarity | TBD | TBD |

## Phase 0 capture

Record these outputs verbatim when available:

```bash
uname -a
cat /proc/device-tree/model; echo
cat /etc/os-release
ls /dev/spidev* 2>/dev/null || true
```

## Bring-up checklist

- [ ] Boards identified exactly
- [ ] Schematics/pinouts checked
- [ ] Power method confirmed
- [ ] Common ground connected
- [ ] SPI enabled on Raspberry Pi
- [ ] Conservative SPI parameters selected
- [ ] Known-pattern TX test succeeds
- [ ] Known-pattern RX test succeeds
- [ ] Wiring diagram/photo saved

## Hardware debugging order

When communication fails, check in this order:

1. power and common ground
2. exact physical pin mapping
3. SPI mode and clock
4. CS behavior
5. STM32 SPI peripheral state
6. logic-level signal activity if measurement equipment is available
7. host software

Do not jump directly to kernel-driver debugging before the physical/userspace path is known-good.
