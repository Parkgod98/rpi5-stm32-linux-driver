# 프로젝트 목표

## 목표

Raspberry Pi 5 Host와 STM32F103RB 기반 Peripheral을 연결해, HW부터 Application까지 이어지는 Linux Device Driver Stack을 직접 구현하고 반복해서 재현할 수 있는 프로젝트를 완성합니다.

전체 경로는 다음과 같습니다.

`STM32 Firmware <-> SPI/GPIO <-> Raspberry Pi Linux Kernel Driver <-> /dev interface <-> C++ Application`

이 프로젝트를 통해 아래 영역을 실제 구현과 검증으로 이해하는 것을 목표로 합니다.

- Embedded Linux
- Linux Device Model
- Device Tree와 Driver Binding
- Linux SPI Subsystem
- Kernel / userspace 경계
- 비동기 Event 처리
- HW-SW Interface 설계
- Error Handling과 Robustness
- Latency / Performance 측정

## 기능 목표

STM32는 작은 Command Protocol을 제공하는 Custom Peripheral로 동작합니다.

초기 Command Set:

- `GET_INFO`: Firmware / Protocol Version 조회
- `GET_STATUS`: Uptime, LED 상태, Button/Event 상태, Error Counter 조회
- `SET_LED`: STM32 Output 제어
- `SET_PERIOD`: 주기 또는 Event 관련 Parameter 설정
- `ECHO`: 기능 검증과 Benchmark를 위한 결정적 Round-trip Test

STM32는 별도의 GPIO/IRQ Line을 사용해 Raspberry Pi에 비동기 Event도 전달합니다.

## Linux 측 최종 목표

완료된 Linux 측 구현은 아래를 포함합니다.

- SPI Peripheral을 기술하는 Device Tree
- Custom Linux `spi_driver`
- Driver `probe()` / `remove()` Lifecycle
- SPI Request/Response Transaction Layer
- 제한 시간이 있는 Timeout 처리
- Sequence와 CRC를 포함한 Protocol 검증
- `miscdevice` 기반 `/dev` userspace Interface
- `ioctl()` 및 필요 시 `read()/write()`를 통한 제어
- `poll()` 또는 Blocking `read()`를 이용한 비동기 Event 전달
- C++ CLI Application
- 재현 가능한 Fault Test
- 반복 가능한 Latency Benchmark

## 이번 프로젝트에서 하지 않는 것

초기 범위에는 아래를 포함하지 않습니다.

- Raspberry Pi SPI Controller Driver 자체 구현
- DMA Engine Driver 구현
- PCIe / USB / DRM Controller Driver 구현
- 범용 Production MCU Framework 개발
- Correctness와 Observability 확보 전의 성급한 최적화

## 최종 완료 조건

아래 항목을 모두 만족해야 프로젝트를 완료한 것으로 봅니다.

1. HW 배선과 Pin Mapping이 문서화되어 동일하게 재현할 수 있다.
2. Custom Kernel Driver를 넣기 전에 Raspberry Pi userspace에서 `spidev`로 STM32와 SPI 통신이 실제 동작한다.
3. Packet Protocol에 Version이 존재하고, 잘못된 Frame과 CRC 오류를 감지해 거부한다.
4. Device Tree가 Custom Peripheral을 생성하고 Kernel Driver가 자동으로 Binding된다.
5. userspace Program이 `spidev`가 아닌 Custom Driver의 `/dev` Interface를 통해 STM32를 조회하고 제어한다.
6. STM32 Event가 Interrupt 기반 경로를 통해 userspace까지 전달된다.
7. CRC 오류, Response Drop, Timeout을 의도적으로 발생시켜도 Kernel Panic, Deadlock, 무한 대기가 발생하지 않는다.
8. 반복 가능한 Benchmark로 성공률과 p50/p95/p99/max Round-trip Latency를 기록한다.
9. Architecture, Protocol, Test Plan, 결과, 면접 문서가 실제 구현과 일치한다.
10. 생성된 답변이나 숨은 가정에 기대지 않고 전체 Stack과 주요 설계 결정을 직접 설명할 수 있다.
