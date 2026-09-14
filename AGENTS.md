# AGENTS.md

이 저장소는 작업을 중단했다가 다시 시작해도 같은 계획선에서 안전하게 이어갈 수 있도록 구성합니다. 이 저장소를 다루는 AI Agent와 개발자는 아래 규칙을 반드시 따릅니다.

## 1. 작업 전 확인 순서

변경을 시작하기 전에 반드시 아래 순서로 읽습니다.

1. `docs/CURRENT_STATUS.md`
2. `docs/02_ROADMAP.md`
3. 현재 Phase와 관련된 설계 문서
4. 현재 Phase의 기존 코드와 테스트 결과

Roadmap만 보고 진행 상태를 추측하지 않습니다. 실제 진행 상태의 기준 문서는 `CURRENT_STATUS.md`입니다.

## 2. 검증하지 않은 내용을 완료로 처리하지 않기

기능은 문서에 정의된 완료 조건을 실제 증거와 함께 만족했을 때만 DONE으로 처리합니다.

예시:
- "SPI 설정 완료"만으로는 DONE이 아닙니다. Host와 MCU 사이의 반복 가능한 실제 transaction이 성공해야 합니다.
- "Driver 구현 완료"만으로는 DONE이 아닙니다. Driver binding, 의도한 interface 노출, 관련 테스트 통과까지 확인해야 합니다.
- "Error handling 추가"만으로는 DONE이 아닙니다. Fault injection으로 실제 오류 경로를 실행해야 합니다.

실제 HW에서 검증되지 않은 내용을 README나 포트폴리오에 완료형으로 기록하지 않습니다.

## 3. 한 번에 하나의 Phase만 진행

뒤 단계가 흥미롭다는 이유로 현재 단계를 건너뛰지 않습니다.

기본 순서:

`HW Bring-up -> userspace SPI -> Protocol -> Device Tree -> Kernel Driver -> userspace interface -> IRQ/Event -> Robustness -> Performance -> Documentation`

현재 Phase의 완료 조건을 통과하기 전에는 다음 Phase를 시작하지 않습니다. 예외가 필요하면 `CURRENT_STATUS.md`에 이유와 범위를 명시합니다.

## 4. HW, Firmware, Kernel, Application 문제를 분리해서 디버깅

가장 낮은 계층에서 확인된 사실부터 위로 올라갑니다.

Kernel Driver를 의심하기 전에 아래를 먼저 확인합니다.
- 전원과 공통 GND
- 실제 배선과 Pin Mapping
- STM32 Firmware 상태
- Raspberry Pi의 SPI 사용 가능 여부
- userspace SPI 통신
- Protocol 정합성

Timing 문제를 임의의 `sleep()`으로 숨기지 않습니다. 문제 격리를 위해 임시 delay를 사용할 수는 있지만, 이유를 기록하고 Phase 종료 전 제거합니다.

## 5. HW 의존 값은 추측하지 않기

아래 값은 추측해서 채우지 않습니다.
- GPIO 번호
- SPI Bus / Chip Select
- STM32 Alternate Function Pin
- Active High / Active Low
- Kernel 버전에 따라 달라지는 API

실제 보드, Schematic/Manual, OS 출력 또는 Source Tree에서 확인한 뒤 `docs/03_HW_SETUP.md`에 기록합니다.

## 6. 코드와 문서를 항상 같이 갱신

설계 결정이 바뀌면 같은 PR에서 관련 문서도 수정합니다.

매 작업 세션 종료 시 `docs/CURRENT_STATUS.md`에 아래를 갱신합니다.
- 현재 Phase
- 마지막으로 검증된 결과
- 현재 Blocker
- 다음 행동 3개
- Evidence / Log 위치
- 아직 시작하면 안 되는 작업

## 7. 반복 명령은 재현 가능하게 만들기

반복해서 사용하는 명령은 채팅 기록에만 남기지 않고 `scripts/` 또는 Root `Makefile`로 옮깁니다.

Build/Test 절차는 최종적으로 문서화된 명령 하나로 재현할 수 있어야 합니다.

## 8. Kernel 코드 안전 규칙

- Kernel 코드는 Privileged Code로 취급합니다.
- 길이와 userspace 입력을 검증합니다.
- 의미 있는 negative errno를 반환합니다.
- 무한 대기를 만들지 않습니다.
- Shared State에는 적절한 동기화 수단을 사용합니다.
- userspace pointer를 직접 dereference하지 않습니다.
- Hard IRQ Handler에서는 최소한의 작업만 수행하고 필요하면 Threaded IRQ나 Deferred Work를 사용합니다.
- Module unload/reload와 Error Path를 반복 검증합니다.

## 9. 프로젝트 범위

이 프로젝트의 목표는 Raspberry Pi 5에 연결된 STM32F103RB 기반 Device를 위한 **Linux SPI Peripheral/Protocol Driver**를 구현하는 것입니다.

Raspberry Pi의 SPI Controller Driver 자체를 새로 만드는 프로젝트가 아닙니다.

목표 Stack:

`C++ App -> /dev interface -> Custom Linux SPI Driver -> Linux SPI Core/Controller -> SPI -> STM32F103RB Firmware`

비동기 Event 전달을 위해 STM32에서 Raspberry Pi로 연결되는 별도 GPIO Event Line도 사용합니다.

## 10. 포트폴리오 정합성

최종적으로 아래와 같은 설명을 실제 구현과 측정 결과로 뒷받침할 수 있어야 합니다.

> Raspberry Pi 5와 STM32F103RB를 연결하고 Device Tree, Linux SPI Driver, C++ userspace Application까지 직접 구현해 HW가 OS를 거쳐 상위 Application으로 연결되는 전체 흐름을 구성했으며, 오류 상황과 Latency까지 검증했습니다.

위 문장 중 실제로 완료하고 측정한 범위만 사용합니다.

## 11. 문서 언어 규칙

- README, Roadmap, 설계 문서, 작업 로그, PR 본문은 기본적으로 **한글**로 작성합니다.
- `Device Tree`, `SPI`, `Kernel`, `Driver`, `IRQ`, `poll()`, `CRC`, `UAPI`, `userspace`처럼 기술적으로 영어 표기가 자연스러운 용어는 그대로 사용합니다.
- 단순한 설명 문장이나 제목을 불필요하게 영어로 작성하지 않습니다.
- 사용자가 문서를 읽고 설계의 옳고 그름을 직접 판단할 수 있도록, 중요한 결정의 이유와 아직 확정되지 않은 항목을 명확히 구분합니다.
