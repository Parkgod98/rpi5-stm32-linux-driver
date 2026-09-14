# 시스템 구조

## 목표 Stack

```text
+------------------------------+
| C++ userspace Application    |
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
| Custom Linux SPI Driver      |
| - probe/remove               |
| - request/response           |
| - CRC/sequence validation    |
| - timeout/error handling     |
| - IRQ/event queue            |
+--------------+---------------+
               |
               | Linux SPI Core
               v
+------------------------------+
| Raspberry Pi 5 SPI Controller|
+--------------+---------------+
               |
               | MOSI/MISO/SCLK/CS
               v
+------------------------------+
| STM32F103RB Firmware         |
| - SPI Peripheral             |
| - Protocol Parser            |
| - Command Handler            |
| - CRC/Sequence               |
| - EVENT/READY GPIO           |
+------------------------------+
               |
               | GPIO Event/IRQ
               +---------------------> Raspberry Pi GPIO IRQ
```

## Data Flow

### 동기식 제어 경로

`SET_LED` 예시:

```text
f103ctl
 -> ioctl()
 -> Custom Driver
 -> SPI Request Frame
 -> STM32 Command Parser
 -> GPIO/LED 상태 변경
 -> SPI Response Frame
 -> Driver 검증
 -> ioctl 반환
 -> 사용자에게 결과 표시
```

### 상태 조회 경로

```text
f103ctl status
 -> Driver GET_STATUS Transaction
 -> STM32 Status Snapshot
 -> CRC + Sequence 검증
 -> 구조화된 Status를 userspace에 반환
```

### 비동기 Event 경로

목표 구조:

```text
STM32 Event/Button
 -> STM32가 EVENT/READY GPIO Assert
 -> Raspberry Pi GPIO IRQ
 -> Kernel IRQ Handler
 -> 필요 시 Deferred Work / Event State 갱신
 -> Wait Queue Wake-up
 -> userspace poll()/Blocking Read 해제
 -> f103ctl에서 Event 출력
```

## 설계 원칙

1. **Kernel 통합 전에 Correctness 확보**: 먼저 userspace `spidev`로 물리 통신과 Protocol을 검증합니다.
2. **역할을 명확히 구분**: Raspberry Pi는 SPI Host/Controller 측 Initiator, STM32는 SPI Peripheral로 동작합니다.
3. **무한 대기 금지**: Firmware Response를 끝없이 기다리지 않고 Timeout을 둡니다.
4. **Protocol 무결성 확인**: Sequence와 CRC로 오래된 Response와 손상된 Frame을 검출합니다.
5. **오류를 관찰 가능하게 설계**: Counter와 Log를 남겨 원인을 추적할 수 있게 합니다.
6. **IRQ에서는 최소 작업만 수행**: Hard IRQ Context에서 긴 SPI 작업이나 복잡한 처리를 하지 않습니다.
7. **안정적인 UAPI 유지**: userspace가 Kernel 내부 구조에 직접 의존하지 않게 합니다.

## 면접에서 반드시 구분할 내용

이 프로젝트는 Linux/Raspberry Pi가 이미 제공하는 SPI Controller 지원을 사용합니다. 직접 구현하는 Kernel Component는 STM32 기반 Device를 위한 **SPI Peripheral/Protocol Driver**이며, SPI Controller Driver를 새로 만드는 것이 아닙니다.

## 실제 HW에서 확인하기 전까지 확정하지 않는 항목

아래 항목은 추측으로 채우지 않습니다.

- Raspberry Pi에서 사용할 정확한 SPI Bus와 Chip Select
- EVENT/READY에 사용할 Raspberry Pi GPIO
- STM32에서 사용할 SPI Instance와 Alternate Function Pin Mapping
- IRQ Polarity와 Trigger Mode
- 초기 SPI Clock과 Mode
- READY와 EVENT를 하나의 Line으로 사용할지 분리할지

확정된 값은 `docs/03_HW_SETUP.md`에 기록합니다.
