# rpi5-stm32-linux-driver

Raspberry Pi 5와 STM32F103RB를 연결해 **Device Tree -> Linux SPI Driver -> `/dev` interface -> C++ userspace Application**까지 직접 구현하는 HW-SW Interface 프로젝트입니다.

현재 단계는 **프로젝트 하네스와 개발 환경을 구축하는 Phase 0**입니다. 실제 HW에서 검증되기 전에는 계획된 기능을 완료된 것으로 간주하지 않습니다.

## 목표 구조

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

## 이 프로젝트에서 다루는 내용

- Embedded Linux
- Device Tree와 Driver Binding
- Linux SPI Subsystem
- Custom SPI Peripheral/Protocol Driver
- Kernel / userspace Interface
- GPIO IRQ와 `poll()` 기반 비동기 Event 전달
- CRC / Sequence / Timeout 기반 통신 안정성
- Fault Injection
- Latency 측정과 Tracing

## 작업을 시작하거나 다시 이어갈 때

항상 아래 순서로 확인합니다.

1. [`docs/CURRENT_STATUS.md`](docs/CURRENT_STATUS.md)
2. [`docs/02_ROADMAP.md`](docs/02_ROADMAP.md)
3. [`AGENTS.md`](AGENTS.md)
4. 현재 Phase와 관련된 설계 문서

계획 문서만 보고 진행 상태를 추측하거나 Phase를 건너뛰지 않습니다.

## 개발 순서

```text
환경 / 장비 확인
        ↓
HW Bring-up
        ↓
userspace SPI (`spidev`)
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
Fault Handling
        ↓
Performance / Tracing
        ↓
포트폴리오 / 면접 대비
```

## 핵심 문서

- `docs/00_PROJECT_GOAL.md` — 프로젝트 목표, 범위, 최종 완료 조건
- `docs/01_ARCHITECTURE.md` — 전체 Stack과 Data Flow
- `docs/02_ROADMAP.md` — Phase별 작업과 완료 조건
- `docs/03_HW_SETUP.md` — 실제 확인한 HW 정보와 배선
- `docs/04_PROTOCOL_SPEC.md` — Protocol v1 설계
- `docs/05_DRIVER_DESIGN.md` — Linux Kernel Driver 설계
- `docs/06_TEST_PLAN.md` — 기능/오류 검증 계획
- `docs/07_PERFORMANCE_PLAN.md` — Benchmark와 성능 측정 방법
- `docs/08_DEBUG_GUIDE.md` — 계층별 Debug 순서
- `docs/09_INTERVIEW_NOTES.md` — 면접 질문과 설명 준비
- `docs/CURRENT_STATUS.md` — 현재 진행 상태의 기준 문서
- `docs/git-conventions.md` — Branch / Commit / PR 작업 규칙

## 기록 원칙

README와 포트폴리오에는 **실제 장비에서 검증된 내용만 완료형으로 기록**합니다. 계획, 구현 중인 기능, 실제 결과를 구분합니다.
