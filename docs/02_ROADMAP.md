# 개발 Roadmap

이 문서는 프로젝트의 **Phase 진행 순서를 정하는 기준 문서**입니다. 각 Phase는 실제 환경에서 완료 조건을 모두 검증하고 그 결과를 `CURRENT_STATUS.md`에 기록했을 때만 완료됩니다.

## Phase 0 — 환경과 장비 확인

### 작업
- Raspberry Pi의 정확한 모델과 OS / Kernel Version을 확인합니다.
- STM32 보드 모델과 MCU를 실제 보드 표기로 확인합니다. `NUCLEO-F103RB` 여부도 이 단계에서 확정합니다.
- USB Cable, Debugger/Programmer, Jumper Wire, 필요 시 Breadboard 등 보유 장비를 확인합니다.
- STM32CubeIDE 또는 실제로 사용할 STM32 Build 환경을 설치하고 확인합니다.
- Raspberry Pi의 Build Tool, Git, C/C++ Compiler, Kernel Header/Source 호환성을 확인합니다.
- Raspberry Pi에서 SPI를 활성화하고 실제 노출 상태를 확인합니다.
- Version, 명령, 확인 결과를 문서에 기록합니다.

### 완료 조건
- [ ] `uname -a` 결과를 기록했다.
- [ ] Raspberry Pi 모델을 실제 장비에서 확인했다.
- [ ] STM32 Board/MCU 모델을 확인했다.
- [ ] 최소 Firmware를 STM32에 Flash할 수 있다.
- [ ] Raspberry Pi에서 SPI Device/Controller 상태를 확인했다.
- [ ] 정확한 Pin Mapping을 문서화했다. 단, 아직 통신 성공으로 간주하지 않는다.

## Phase 1 — HW Bring-up

### 작업
- 공통 GND와 SPI Signal을 연결합니다.
- 보수적인 낮은 SPI Clock에서 시작합니다.
- STM32에 최소 SPI Peripheral RX/TX 경로를 구현합니다.
- 고정된 Test Pattern으로 송수신을 검증합니다.

### 완료 조건
- [ ] 배선 사진 또는 Diagram을 저장했다.
- [ ] Pi가 보낸 고정 Byte Pattern을 STM32가 정확하게 수신한다.
- [ ] STM32의 고정 Response를 Pi가 정확하게 수신한다.
- [ ] Reboot / Reflash 후에도 동일하게 재현된다.

## Phase 2 — userspace SPI Prototype

### 작업
- Custom Kernel Driver보다 먼저 Python 또는 C/C++의 `spidev`로 Host 통신을 구현합니다.
- `ECHO`, `SET_LED`, `GET_STATUS`의 최소 기능을 구현합니다.
- Transaction Log를 남깁니다.
- 원인이 설명되지 않는 임시 Delay는 제거합니다.

### 완료 조건
- [ ] userspace에서 `ECHO`가 반복적으로 성공한다.
- [ ] `SET_LED`로 실제 HW 상태가 변경된다.
- [ ] `GET_STATUS`로 구조화된 상태를 읽는다.
- [ ] 기본 Transaction 1,000회를 원인을 알 수 없는 데이터 손상 없이 연속 수행한다.

## Phase 3 — Versioned Protocol

### 작업
- v1 Frame Layout을 확정합니다.
- Magic / Version / Opcode / Sequence / Payload Length / CRC를 정의합니다.
- Request/Response 의미와 Error Code를 정의합니다.
- READY/EVENT Timing을 정의합니다.
- Host와 STM32 양쪽 Parser에 Validation을 추가합니다.

### 완료 조건
- [ ] Protocol Specification이 실제 구현과 일치한다.
- [ ] 잘못된 Magic / Version / Length / CRC를 거부한다.
- [ ] Sequence 불일치를 감지한다.
- [ ] 모든 v1 Opcode에 대한 Test가 존재한다.
- [ ] 기준 설정에서 `ECHO` 10,000회를 통과하거나 실패 원인을 확인해 수정했다.

## Phase 4 — Device Tree와 Driver Binding

### 작업
- Custom Device Tree Overlay/Node를 작성합니다.
- 프로젝트 전용 `compatible` String을 정의합니다.
- 선택한 Chip Select에 기존 `spidev` Binding이 충돌하지 않도록 정리합니다.
- `of_match_table`을 사용하는 최소 Linux `spi_driver`를 작성합니다.

### 완료 조건
- [ ] 의도한 Custom Device가 Linux Device Model에 생성된다.
- [ ] Custom Driver가 자동으로 Binding된다.
- [ ] Log를 통해 `probe()`와 `remove()`를 확인한다.
- [ ] Module Load/Unload를 반복해도 정상 동작한다.

## Phase 5 — Kernel Transaction Layer

### 작업
- SPI Protocol Transaction Logic을 Custom Driver 내부로 옮깁니다.
- Serialization / Deserialization을 안전하게 구현합니다.
- Timeout, CRC, Sequence, Firmware Error를 처리합니다.
- Shared Transaction State를 보호합니다.

### 완료 조건
- [ ] Kernel Driver를 통해 `GET_INFO`, `GET_STATUS`, `SET_LED`, `ECHO`가 성공한다.
- [ ] 정상 동작에 userspace `spidev`가 더 이상 필요하지 않다.
- [ ] Driver Load/Unload를 반복해도 Leak이나 Crash가 발생하지 않는다.
- [ ] Error Path가 의미 있는 errno를 반환한다.

## Phase 6 — `/dev` userspace Interface

### 작업
- 설계가 바뀌지 않는다면 `miscdevice`를 등록합니다.
- 안정적인 UAPI Header를 정의합니다.
- `read()` 또는 `ioctl()` 중심의 Interface를 구현합니다.
- C++ CLI `f103ctl`을 구현합니다.

### 목표 CLI

```text
f103ctl info
f103ctl status
f103ctl led on
f103ctl led off
f103ctl period <ms>
f103ctl echo <count>
```

### 완료 조건
- [ ] Driver가 Binding된 동안에만 `/dev/f103bridge`가 존재한다.
- [ ] C++ Application에서 모든 v1 동기 Command를 실행할 수 있다.
- [ ] 잘못된 userspace 입력을 안전하게 거부한다.
- [ ] UAPI Structure와 사용법을 문서화했다.

## Phase 7 — IRQ와 비동기 Event 전달

### 작업
- STM32에 EVENT/READY GPIO 동작을 구현합니다.
- Device Tree 또는 Descriptor API를 이용해 GPIO/IRQ를 구성합니다.
- Hard IRQ Handler는 최소 작업만 수행합니다.
- Wait Queue와 Event State를 구성합니다.
- `poll()` 또는 Blocking `read()`를 통해 Event를 userspace에 노출합니다.

### 완료 조건
- [ ] 실제 STM32 Event가 Busy Polling 없이 Block된 userspace를 깨운다.
- [ ] 일반적인 Test Load에서 반복 Event가 조용히 유실되지 않는다.
- [ ] userspace가 대기 중인 상태에서도 Driver Unload가 안전하게 처리된다.
- [ ] 최소한의 IRQ Storm / Stuck Line 상황을 검토하고 테스트했다.

## Phase 8 — Robustness와 Fault Injection

### 의도적으로 발생시킬 오류
- 잘못된 CRC
- 잘못된 Sequence
- Response Drop
- Delayed Response / Timeout
- Host 동작 중 STM32 Reset
- 잘못된 Payload Length
- 빠른 반복 Command

### 완료 조건
- [ ] 모든 Fault에 대해 예상한 Host-visible 결과가 정의되어 있다.
- [ ] Kernel Panic, Deadlock, 무한 대기가 발생하지 않는다.
- [ ] Error Counter와 Log로 Root Cause를 추적할 수 있다.
- [ ] Recovery가 가능한 Fault 이후 정상 Transaction이 다시 동작한다.

## Phase 9 — Performance와 Tracing

### 작업
- 반복 가능한 Benchmark Script 또는 Application Mode를 만듭니다.
- `ECHO`와 실제 Command 최소 1개의 Round-trip Latency를 측정합니다.
- p50 / p95 / p99 / max와 성공률을 기록합니다.
- CPU Load를 준 상태에서도 동일한 테스트를 수행합니다.
- 동작을 설명하는 데 필요할 때만 `perf`, `ftrace` 등 Tracing Tool을 사용합니다.

### 완료 조건
- [ ] Baseline 결과를 `results/`에 저장했다.
- [ ] CPU Load 조건의 결과를 저장했다.
- [ ] 다른 사람이 반복할 수 있도록 측정 방법을 기록했다.
- [ ] 실제 측정 Evidence를 바탕으로 최소 하나의 병목 또는 관찰 결과를 설명할 수 있다.

## Phase 10 — 포트폴리오와 면접 대비

### 작업
- README를 실제 결과 기준으로 다시 작성합니다.
- 최종 Architecture와 Wiring Diagram을 추가합니다.
- 계획된 수치가 아니라 실제 측정 결과를 기록합니다.
- 주요 Bug와 원인 격리 과정을 정리합니다.
- 면접 질문에 본인의 말로 답을 작성합니다.
- Fresh Clone 기준 Setup / Build / Test 절차를 다시 수행합니다.

### 완료 조건
- [ ] README에 계획을 완료된 사실처럼 적은 문장이 없다.
- [ ] Fresh Clone 환경에서 문서의 절차가 동작한다.
- [ ] 핵심 Demo를 반복해서 재현할 수 있다.
- [ ] 도움 없이 모든 Layer와 주요 설계 결정을 설명할 수 있다.

## Branch 운영 계획

예정 작업 Branch:

- `feat/hw-bringup`
- `feat/spi-userspace`
- `feat/protocol-v1`
- `feat/device-tree`
- `feat/kernel-driver`
- `feat/userspace-api`
- `feat/irq-event`
- `test/fault-injection`
- `test/performance-benchmark`

`main`에는 Review와 검증이 끝난 Milestone만 반영합니다.
