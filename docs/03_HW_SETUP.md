# HW 구성 및 환경 확인

이 문서에는 **실제로 확인한 HW 정보만** 기록합니다. 아직 확인하지 않은 값은 추측하지 않고 `TBD`로 유지합니다.

## 장비 목록

| 항목 | 값 | 확인 상태 |
|---|---|---|
| Host Board | Raspberry Pi 5 | 예정, 실물 확인 필요 |
| Host OS | TBD | 미확인 |
| Kernel | TBD | 미확인 |
| MCU | STM32F103RB | 예정, 실물 확인 필요 |
| STM32 Board | TBD | 미확인 |
| Programmer / Debugger | TBD | 미확인 |
| 전원 공급 방식 | TBD | 미확인 |

## 예정 연결 구조

Raspberry Pi는 SPI Host, STM32는 SPI Peripheral로 동작합니다.

필요 Signal:

- MOSI
- MISO
- SCLK
- CS/NSS
- GND
- STM32 -> Raspberry Pi 방향 READY/EVENT GPIO 1개

전원 공급 방식을 명확하게 확인하기 전에는 두 보드의 Power Rail을 임의로 연결하지 않습니다. Signal 통신을 위해 공통 GND는 필요합니다.

## Pin Mapping

실제 보드의 Pinout을 확인한 뒤에만 채웁니다.

| Signal | Raspberry Pi 5 | STM32F103RB Board | 비고 |
|---|---|---|---|
| MOSI | TBD | TBD | |
| MISO | TBD | TBD | |
| SCLK | TBD | TBD | |
| CS/NSS | TBD | TBD | |
| EVENT/READY | TBD | TBD | STM32 -> Pi |
| GND | TBD | TBD | 공통 GND |

## SPI 설정

| Parameter | 초기 값 | 최종 값 |
|---|---:|---:|
| Mode | TBD | TBD |
| Bits/Word | 8 예정 | TBD |
| Clock | 낮은 값부터 시작, TBD | TBD |
| CS Polarity | TBD | TBD |

## Phase 0에서 저장할 환경 정보

아래 명령의 실제 출력은 가능한 한 원문 그대로 기록합니다.

```bash
uname -a
cat /proc/device-tree/model; echo
cat /etc/os-release
ls /dev/spidev* 2>/dev/null || true
```

## Bring-up 확인 목록

- [ ] 두 Board의 정확한 모델을 확인했다.
- [ ] Schematic / Pinout을 확인했다.
- [ ] 전원 공급 방식을 확인했다.
- [ ] 공통 GND를 연결했다.
- [ ] Raspberry Pi에서 SPI를 활성화했다.
- [ ] 낮은 SPI Clock 등 보수적인 초기 Parameter를 정했다.
- [ ] Known Pattern TX Test가 성공한다.
- [ ] Known Pattern RX Test가 성공한다.
- [ ] 배선 Diagram 또는 사진을 저장했다.

## HW 통신 문제 발생 시 확인 순서

1. 전원과 공통 GND
2. 실제 Pin Mapping과 배선
3. SPI Mode와 Clock
4. CS 동작
5. STM32 SPI Peripheral 상태
6. 측정 장비가 있다면 Logic Level Signal 확인
7. Host Software

Physical Layer와 userspace 통신이 정상임을 확인하기 전에는 Kernel Driver부터 의심하거나 수정하지 않습니다.
