# 개발 흐름

이 저장소는 작업을 며칠 또는 몇 주 중단해도 같은 계획선에서 바로 이어갈 수 있도록 운영합니다.

## 기본 원칙

- `main`에는 검증이 끝난 결과만 반영합니다.
- 모든 일반 작업은 최신 `main`에서 작업 브랜치를 만들어 진행합니다.
- 한 브랜치는 하나의 목적만 가집니다.
- 브랜치·커밋·PR 규칙은 `docs/git-conventions.md`를 기준으로 합니다.
- PR은 사용자가 직접 확인한 뒤 병합합니다.

예정 브랜치 예시:

- `feat/hw-bringup`
- `feat/spi-userspace`
- `feat/protocol-v1`
- `feat/device-tree`
- `feat/kernel-driver`
- `feat/userspace-api`
- `feat/irq-event`
- `test/fault-injection`
- `test/performance-benchmark`

## 작업 시작

1. `docs/CURRENT_STATUS.md`를 읽습니다.
2. `docs/02_ROADMAP.md`에서 현재 Phase와 완료 조건을 확인합니다.
3. 현재 Phase의 설계 문서와 기존 결과를 확인합니다.
4. 최신 `main`에서 규칙에 맞는 작업 브랜치를 생성합니다.
5. 환경이 바뀌었다면 마지막 검증 결과부터 다시 재현합니다.

## 작업 종료

작업을 멈추기 전 반드시 아래를 수행합니다.

1. 현재 변경에 필요한 빌드·테스트를 실행합니다.
2. 재현에 필요한 로그와 결과를 저장합니다.
3. `docs/CURRENT_STATUS.md`를 갱신합니다.
4. 설계가 바뀌었다면 관련 문서도 같은 PR에서 수정합니다.
5. 실제로 검증한 내용 기준으로 커밋합니다.

## 커밋 예시

- `feat: SPI 사용자 영역 ECHO 통신 추가`
- `feat: Device Tree 기반 STM32 디바이스 바인딩 추가`
- `test: CRC 오류 주입 검증 추가`
- `fix: 응답 Timeout 이후 Sequence 상태 복구`
- `docs: Phase 2 검증 결과 기록`

## PR 확인 항목

- 현재 Roadmap Phase와 PR 범위가 일치하는가
- 실제 HW 동작이 바뀌었다면 실기기 검증 결과가 있는가
- `docs/CURRENT_STATUS.md`가 최신 상태인가
- 관련 설계·테스트 문서가 함께 갱신됐는가
- 검증하지 않은 기능을 완료했다고 적지 않았는가
- HW 의존 값은 추측이 아니라 실제 장비/문서로 확인했는가
- 임의의 `sleep()`이나 근거 없는 Magic Number로 문제를 숨기지 않았는가

## AI를 이용한 개발

AI는 구현 속도를 높이기 위한 도구로 사용하되, 생성된 코드를 검증 없이 신뢰하지 않습니다.

Kernel/Firmware 경로의 코드는 최소한 아래를 만족해야 합니다.

- 코드가 하는 일을 설명할 수 있어야 합니다.
- 실제 환경에서 빌드해야 합니다.
- HW 동작이 관련된 경우 실제 장비에서 검증해야 합니다.
- 정상 경로뿐 아니라 오류 경로도 확인해야 합니다.
- 면접에서 핵심 동작을 코드 없이 설명할 수 있어야 합니다.

동작하더라도 핵심 경로를 설명할 수 없다면 면접 준비가 끝난 것으로 보지 않습니다.
