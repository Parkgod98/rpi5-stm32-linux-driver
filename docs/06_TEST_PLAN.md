# 테스트 계획

코드가 Compile된 것만으로 프로젝트를 완료한 것으로 보지 않습니다. 각 계층마다 명확하게 관찰 가능한 Pass/Fail 기준을 둡니다.

## Layer 1 — HW
- 정해진 MOSI Pattern이 STM32에 정확히 도달한다.
- STM32의 정해진 MISO Response가 Pi에 정확히 도달한다.
- Reboot / Reflash 후에도 동일한 결과가 재현된다.

## Layer 2 — userspace SPI
- `ECHO`: 초기 기준 1,000회 연속 성공
- `SET_LED`: Command에 따라 실제 HW 상태 변경
- `GET_STATUS`: 반환 값과 실제 HW 상태 일치
- 잘못된 Opcode에 정의된 Error Response 반환

## Layer 3 — Protocol
- 잘못된 Magic 거부
- 지원하지 않는 Version 거부
- 범위를 넘은 Payload Length 거부
- 잘못된 CRC 거부
- 잘못된 Sequence 거부
- 모든 v1 Opcode에 최소 하나의 정상 Test 존재

## Layer 4 — Device Tree / Binding
- Custom Device 생성 확인
- Custom Driver Binding 확인
- `probe()` / `remove()` Log로 Lifecycle 확인
- 반복 Load/Unload 성공

## Layer 5 — Kernel Transaction Layer
- Kernel Driver를 통해 GET_INFO / GET_STATUS / SET_LED / ECHO 성공
- SPI Transfer 실패가 호출자에게 전달됨
- Timeout이 제한된 시간 안에 종료됨
- CRC와 Sequence 오류가 호출자와 Log/Counter에서 확인됨

## Layer 6 — UAPI
- `/dev/f103bridge`를 통한 정상 Command 성공
- 잘못된 `ioctl` / `read` 입력 안전하게 거부
- Application이 Driver Error를 명확하게 처리
- Device가 없거나 Permission이 부족한 경우 이해 가능한 결과 제공

## Layer 7 — IRQ / Event
- 실제 STM32 Event가 `poll()` 또는 Blocking `read()`에서 대기 중인 userspace를 깨움
- Burst Event 검증
- userspace가 대기하지 않을 때 발생한 Event 처리 검증
- userspace가 대기 중일 때 Driver Remove 수행 검증

## Layer 8 — Fault Injection

반드시 의도적으로 발생시킬 오류:

| Fault | 기대 동작 |
|---|---|
| Bad CRC | Transaction 거부, Error Count 증가, Crash 없음 |
| Wrong Sequence | 오래되거나 다른 Response 거부 |
| Dropped Response | 제한된 Timeout 후 종료 |
| Delayed Response | Timeout 또는 정의된 Late Response 처리 |
| STM32 Reset | 현재 Operation은 안전하게 실패하고 이후 Recovery 확인 |
| Malformed Payload | Parser가 안전하게 거부 |
| 빠른 반복 Request | Deadlock / Panic 없음 |

## Layer 9 — 장시간 / 반복 테스트
- 기준 환경에서 `ECHO` 10,000회
- Driver Load/Unload 반복
- LED/Status Operation 반복
- CPU Load 상태에서 동일 테스트

## Evidence 기록 기준

중요한 Test는 아래 정보를 남겨 동일한 Claim을 다시 검증할 수 있어야 합니다.

- 실행한 Command
- OS / Kernel Version
- Test 횟수
- 결과 요약
- 관련 Log

Raw Log는 `results/logs/`에 저장하고, 사람이 읽어야 하는 결과 요약은 문서에 남깁니다.
