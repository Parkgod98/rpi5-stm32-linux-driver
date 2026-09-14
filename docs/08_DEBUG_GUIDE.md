# 디버깅 가이드

가장 낮은 계층에서 확인된 사실부터 위로 올라갑니다.

## 증상: SPI Response가 없음

아래 순서대로 확인합니다.
1. Board 전원과 공통 GND
2. 실제 MOSI / MISO / SCLK / CS 배선
3. Raspberry Pi에서 SPI 활성화 여부
4. SPI Mode와 Clock
5. STM32 SPI Peripheral 설정과 Chip Select 동작
6. userspace Tool을 이용한 Known Pattern Transfer
7. Protocol Framing
8. userspace 경로가 정상임을 확인한 뒤 Kernel Driver

## 증상: Response가 한 Transaction 밀리거나 오래된 값이 옴

우선 확인할 영역:
- Host가 Clock을 보내기 전에 STM32가 Response를 준비하지 못함
- STM32가 Request를 처리하기 전에 Host가 같은 Transaction에서 Response를 읽으려 함
- 오래된 DMA / Interrupt Buffer
- Sequence 처리 Bug

우선 설계 방향은 임의의 `sleep()`이 아니라 Request와 Response를 분리하고 READY/EVENT Signal로 동기화하는 것입니다.

## 증상: CRC 오류

확인할 항목:
- 양쪽에서 동일한 CRC Variant와 Byte Order를 사용하는지
- CRC 계산 대상 Byte 범위가 같은지
- Packed Frame Size가 같은지
- 초기화되지 않은 Padding 또는 Byte가 있는지
- Transfer Length와 오래된 Buffer Data가 섞이지 않는지

Physical Link를 먼저 의심하기 전에 Golden Vector로 CRC 구현 자체를 검증합니다.

## 증상: Custom Driver의 `probe()`가 호출되지 않음

확인할 항목:
- Device Tree Node가 실제로 Load됐는지
- 선택한 SPI Controller가 활성화됐는지
- `compatible` String과 `of_match_table`이 정확히 일치하는지
- 같은 Chip Select를 다른 Device 또는 `spidev`가 점유하고 있지 않은지
- Module이 Load됐는지, Kernel Log에 Parse/Resource Error가 없는지

## 증상: Kernel이 멈추거나 Module Unload가 끝나지 않음

확인할 항목:
- 제한 없는 Wait
- 잘못된 Context에서 Sleep
- 자신이 기다리는 경로를 잡고 있는 Mutex
- `remove()` 이후에도 살아 있는 Work/IRQ
- Teardown 시 Wake-up되지 않은 userspace Waiter

## 작업 세션 규칙

Bug 해결이 한 번에 끝나지 않았다면 `CURRENT_STATUS.md`에 아래를 기록합니다.
- 정확한 증상
- 마지막으로 정상임을 확인한 Layer
- 검증한 가설
- 각 가설을 배제한 Evidence
- 다음 실험

무작위로 여러 부분을 동시에 바꾸지 않습니다. 가능한 한 한 번에 하나의 변수만 변경합니다.
