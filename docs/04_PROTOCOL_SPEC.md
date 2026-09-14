# 통신 Protocol 설계

현재 상태: **Phase 3에서 확정할 Draft**입니다. Frame Field 크기와 Opcode는 userspace Bring-up 결과에 따라 바뀔 수 있습니다. Phase 3 완료 조건을 충족하기 전에는 v1을 확정된 것으로 보지 않습니다.

## 설계 목표

- 결정적인 Request/Response 동작
- 명시적인 Version 관리
- 데이터 손상 감지
- 오래되거나 순서가 어긋난 Response 감지
- STM32F103RB에서 단순하게 처리할 수 있는 Parser
- userspace와 Kernel 코드에서 함께 사용할 수 있는 구조

## 제안 Frame

초기안은 최대 크기가 고정된 Frame 안에 실제 `payload_len`을 명시하는 방식입니다.

```c
struct f103_frame_v1 {
    uint8_t  magic0;       // 0xA5
    uint8_t  magic1;       // 0x5A
    uint8_t  version;      // 1
    uint8_t  opcode;
    uint16_t sequence;
    uint16_t payload_len;
    uint8_t  payload[22];
    uint16_t crc16;
} __attribute__((packed));
```

예상 크기는 32 Byte입니다. v1 확정 전 양쪽 Build에서 Compile-time Assertion으로 실제 크기를 확인합니다.

## 제안 Command

| Opcode | 이름 | 방향 | 목적 |
|---:|---|---|---|
| `0x01` | GET_INFO | Pi -> STM32 | Firmware / Protocol 정보 조회 |
| `0x02` | GET_STATUS | Pi -> STM32 | 상태와 Counter 조회 |
| `0x10` | SET_LED | Pi -> STM32 | 눈으로 확인 가능한 제어 테스트 |
| `0x11` | SET_PERIOD | Pi -> STM32 | 주기 동작 Parameter 설정 |
| `0x20` | GET_STATS | Pi -> STM32 | Protocol / Error Counter 조회 |
| `0x30` | ECHO | Pi -> STM32 | 기능 검증과 Benchmark |

최종 Opcode 값은 아직 확정하지 않습니다.

## Frame 검증 순서

Receiver는 정의된 순서에 따라 최소한 아래를 검증합니다.

1. Frame 수신 여부와 Transfer Length
2. Magic
3. Protocol Version
4. Payload Length 범위
5. CRC
6. Opcode별 Payload 구조
7. 필요한 경우 Sequence 의미

잘못된 입력을 정상 Command로 해석해서는 안 됩니다.

## Sequence Number

Host는 Request마다 Sequence를 증가시킵니다. Response는 어떤 Request에 대한 응답인지 동일한 Sequence로 식별할 수 있어야 합니다. Host는 오래되거나 다른 Sequence의 Response를 거부합니다.

Sequence Wrap-around 동작은 v1 확정 전에 명시합니다.

## CRC

CRC16의 Polynomial, Initialization, Reflection, Final XOR 등 정확한 Variant는 아직 `TBD`입니다. Kernel 통합 전에 이 문서에 Variant를 확정하고 Golden Vector로 Host/Firmware 양쪽 결과를 검증합니다.

## SPI Request/Response Timing 문제

SPI Clock은 Host가 생성합니다. STM32 Peripheral은 자신이 원하는 시점에 독립적으로 Response Byte를 밀어낼 수 없습니다.

안정적인 Request/Response를 위한 우선 설계안:

```text
1. Pi가 Request Frame 전송
2. STM32가 Request 검증 및 처리
3. STM32가 READY/EVENT GPIO Assert
4. Pi가 GPIO Event 확인
5. Pi가 Clock을 제공해 STM32 Response Frame 수신
```

초기 Bring-up에서는 두 번의 Transaction 사이에 단순한 방식으로 동작을 검증할 수 있지만, 근거 없는 고정 Delay를 최종 Synchronization 방식으로 사용하지 않습니다.

## Response Status

각 Response에는 명시적인 Status/Error 값을 포함해야 합니다. 후보:

- OK
- UNKNOWN_OPCODE
- BAD_PAYLOAD
- BUSY
- INTERNAL_ERROR

정확한 위치와 표현 방식은 아직 `TBD`입니다.

## Fault Injection 지원

Test Build에서는 의도적으로 아래 Fault를 발생시킬 수 있게 합니다.

- Bad CRC
- Delayed Response
- Dropped Response
- Wrong Sequence

이 기능은 테스트를 위한 것이며 일반 제어 Command처럼 실수로 노출하지 않습니다.

## Protocol 확정 확인 목록

- [ ] Static Assertion으로 정확한 Frame Size를 확인했다.
- [ ] Endianness를 명시했다.
- [ ] CRC Variant를 Golden Vector와 함께 확정했다.
- [ ] 모든 Payload Layout을 문서화했다.
- [ ] 모든 Status/Error 값을 문서화했다.
- [ ] READY/EVENT Timing을 문서화했다.
- [ ] Sequence Wrap 동작을 문서화했다.
- [ ] Host와 Firmware Parser Test를 통과했다.
