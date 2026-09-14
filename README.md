# rpi5-stm32-linux-driver

Raspberry Pi 5와 STM32F103RB를 연결해 **Device Tree -> Linux SPI Driver -> `/dev` interface -> C++ userspace application**까지 직접 구현하는 HW-SW interface project입니다.

현재 단계는 **프로젝트 하네스/환경 구축**입니다. 실제 HW 동작이 검증되기 전에는 구현 완료로 간주하지 않습니다.

## Target architecture

```text
C++ Application
    |
    | read / ioctl / poll
    v
/dev/f103bridge
    |
    v
Custom Linux SPI Driver
    |
    v
Linux SPI Core / RPi5 SPI Controller
    |
    | MOSI / MISO / SCLK / CS
    v
STM32F103RB Firmware
    |
    +---- EVENT/READY GPIO ----> Raspberry Pi IRQ
```

## What this project will cover

- Embedded Linux
- Device Tree / driver binding
- Linux SPI subsystem
- custom SPI peripheral/protocol driver
- kernel/userspace interface
- GPIO IRQ and `poll()` based asynchronous event delivery
- CRC / sequence / timeout based robustness
- fault injection
- latency measurement and tracing

## Start here

When starting or resuming work, read in this order:

1. [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md)
2. [`docs/02_ROADMAP.md`](docs/02_ROADMAP.md)
3. [`AGENTS.md`](AGENTS.md)
4. the document for the current phase

Do not skip phases or infer completion from planned files.

## Development order

```text
Environment / inventory
        ↓
HW bring-up
        ↓
Userspace SPI (`spidev`)
        ↓
Protocol v1
        ↓
Device Tree
        ↓
Custom Linux SPI Driver
        ↓
/dev + C++ Application
        ↓
IRQ / poll
        ↓
Fault handling
        ↓
Performance / tracing
        ↓
Portfolio / interview hardening
```

## Key documents

- `docs/00_PROJECT_GOAL.md` — project scope and final success criteria
- `docs/01_ARCHITECTURE.md` — target stack and data flow
- `docs/02_ROADMAP.md` — phased roadmap and DONE criteria
- `docs/03_HW_SETUP.md` — confirmed hardware facts and wiring
- `docs/04_PROTOCOL_SPEC.md` — protocol v1 draft
- `docs/05_DRIVER_DESIGN.md` — kernel-driver design
- `docs/06_TEST_PLAN.md` — verification/fault test plan
- `docs/07_PERFORMANCE_PLAN.md` — benchmark methodology
- `docs/08_DEBUG_GUIDE.md` — layer-by-layer debugging guide
- `docs/09_INTERVIEW_NOTES.md` — interview question bank
- `docs/CURRENT_STATUS.md` — authoritative current progress

## Integrity rule

README와 포트폴리오에는 **실제 장비에서 검증된 내용만** 완료형으로 기록합니다. 계획과 결과를 섞지 않습니다.
