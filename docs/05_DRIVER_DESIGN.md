# Linux Driver 설계

현재 상태는 **설계 단계**입니다. userspace SPI와 Protocol 검증이 끝난 뒤에 구현을 시작합니다.

## Driver 종류

Device Tree를 통해 Binding되는 STM32F103RB 기반 Device용 Custom Linux SPI Peripheral/Protocol Driver를 구현합니다.

Raspberry Pi SPI Controller Driver 자체 구현은 범위에 포함하지 않습니다.

## 예정 Lifecycle

### `probe()`
- SPI Device와 설정 정보를 가져옵니다.
- 필요하면 GPIO/IRQ Descriptor를 획득합니다.
- Lock, State, Wait Queue를 초기화합니다.
- 필요하다면 `GET_INFO`로 Device Identity를 확인합니다.
- userspace Interface를 등록합니다. 초기안은 `miscdevice`입니다.
- 내부 상태가 준비된 뒤 IRQ 경로를 활성화합니다.

### `remove()`
- 새로운 작업 접수를 중단합니다.
- IRQ 경로를 비활성화하고 필요한 Resource를 해제합니다.
- 대기 중인 userspace가 있다면 Shutdown/Error 상태로 깨웁니다.
- `miscdevice`를 해제합니다.
- 가능한 Resource는 Managed API를 이용해 Lifecycle을 단순화합니다.

## Driver 내부 계층

1. **Transport**: 하나의 SPI Transfer 또는 Request/Response Primitive
2. **Protocol**: Frame Encode/Decode, CRC, Sequence, Status Mapping
3. **Device Operation**: GET_INFO, GET_STATUS, SET_LED, SET_PERIOD, ECHO
4. **Event Path**: IRQ, Event State, Wait Queue
5. **UAPI**: userspace에 노출하는 `read/ioctl/poll`

각 책임을 분리해 Test와 Debug가 한 계층씩 가능하도록 설계합니다.

## Concurrency 설계

초기에는 동기식 SPI Transaction을 Mutex로 직렬화합니다. 실제 측정이나 요구사항이 더 높은 동시성을 요구하기 전까지는 Correctness를 우선합니다.

IRQ Context와 공유하는 State에는 Context에 맞는 동기화 수단을 사용해야 합니다. Hard IRQ Context에서는 Sleep할 수 있는 Lock을 사용하지 않습니다.

## userspace Interface

목표 Device Node:

`/dev/f103bridge`

API 후보:
- `read()` — 상태 또는 Event Data 조회
- `ioctl()` — Type이 명확한 제어 Operation
- `poll()` — 비동기 Event 대기

최종 API는 작고 안정적으로 유지합니다. Kernel 내부 Structure를 그대로 userspace에 노출하지 않습니다.

## Error Mapping

구현 전 후보이며 실제 구현 시 다시 검토합니다.

- 잘못된 userspace 요청 -> `-EINVAL`
- Device가 없거나 Shutdown 중 -> `-ENODEV`
- Timeout -> `-ETIMEDOUT`
- CRC / Protocol 무결성 오류 -> `-EBADMSG` 또는 적절한 errno
- SPI Transfer Error -> 원본 Error를 전달하거나 일관된 negative errno로 정규화

실제 선택은 구현 후 문서에 확정합니다.

## IRQ / Event 설계

Hard IRQ Handler에서는 필요한 최소 작업만 수행합니다. GPIO 의미와 SPI 처리 방식에 따라 Sleep 가능한 처리가 필요하면 Threaded IRQ 또는 Deferred Work를 사용합니다.

목표 userspace 동작:

```text
poll(fd, ...)
  대기
STM32가 Event GPIO Assert
  Kernel에서 Event 처리
  Wait Queue Wake-up
poll()이 반환되고 Event 확인 가능
```

## Kernel 안전성 확인 목록

- [ ] userspace Pointer를 직접 Dereference하지 않는다.
- [ ] 모든 UAPI Length와 범위를 검증한다.
- [ ] 무한 대기가 없다.
- [ ] SPI Error를 확인한다.
- [ ] Sequence/CRC 오류를 Log/Counter로 관찰할 수 있다.
- [ ] Module Unload를 반복해서 검증한다.
- [ ] `remove()` 중 대기 중인 Reader/Poller를 안전하게 처리한다.
- [ ] Fault Injection으로 Kernel Panic이나 Deadlock이 발생하지 않는다.
