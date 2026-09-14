# Git 작업 규칙

## 목적

이 저장소의 브랜치, 커밋, Pull Request 형식을 일관되게 유지합니다. 기존 개인 저장소인 `Hamster_Algorithm`, `MyScheduler`, `Portfolio-site`에서 사용해온 규칙을 기준으로 하되, Linux Device Driver 프로젝트 특성에 맞게 검증 항목을 보강합니다.

## 브랜치

형식:

```text
<type>/<english-kebab-case>
```

허용 type:

- `feat`: 기능 구현
- `fix`: 오류 수정
- `docs`: 문서 변경
- `refactor`: 동작 변경 없는 구조 개선
- `test`: 테스트·검증 추가
- `chore`: 환경·설정·기타 유지보수
- `ci`: CI/Harness 변경

예시:

```text
feat/spi-userspace
feat/device-tree
feat/kernel-driver
feat/irq-event
fix/spi-timeout
fix/driver-unload
refactor/protocol-parser
test/fault-injection
test/performance-benchmark
docs/interview-notes
chore/project-harness
ci/kernel-build-check
```

규칙:

- 설명은 소문자 영문, 숫자, 하이픈만 사용합니다.
- 한 브랜치는 하나의 목적만 가집니다.
- 일반 작업은 최신 `main`에서 시작합니다.
- `main` 직접 커밋은 저장소 최초 bootstrap 외에는 금지합니다.
- Roadmap Phase가 다르면 가능하면 브랜치도 분리합니다.

## 커밋

형식:

```text
<type>: <한글로 구체적인 작업 설명>
```

예시:

```text
feat: SPI 사용자 영역 ECHO 통신 추가
feat: Device Tree 기반 STM32 디바이스 바인딩 추가
feat: Linux SPI 드라이버 probe 경로 구현
fix: SPI 응답 Timeout 이후 상태 복구
test: CRC 오류 주입 검증 추가
test: 1만 회 왕복 지연시간 측정 추가
docs: Phase 3 통신 규격과 검증 결과 기록
chore: 프로젝트 개발 하네스 구축
```

규칙:

- 한 커밋은 하나의 논리적 변경을 담습니다.
- 무엇을 했는지 한글로 구체적으로 씁니다.
- `수정`, `작업`, `update`처럼 범위를 알 수 없는 메시지를 단독으로 쓰지 않습니다.
- 계획만 추가한 경우 완료형 구현 커밋처럼 적지 않습니다.
- HW 동작을 주장하는 커밋은 가능하면 같은 작업 흐름에서 실제 검증 결과를 남깁니다.

## Pull Request

제목 형식:

```text
<type>: <한글 설명>
```

브랜치 type과 PR type은 동일하게 맞춥니다.

예시:

```text
feat: SPI 사용자 영역 통신 구현
feat: Linux SPI 디바이스 드라이버 구현
test: 통신 오류 주입과 복구 검증 추가
docs: 면접 질문과 프로젝트 결과 정리
```

PR 본문에는 다음 항목을 기본으로 포함합니다.

```text
## 변경 내용
## 검증
## HW / 환경 확인
## 남은 제약
## 참고
```

### PR 작성 원칙

- `변경 내용`: 무엇을 왜 바꿨는지 적습니다.
- `검증`: 실제 실행한 명령과 결과를 적습니다. 실행하지 않은 검증은 체크하지 않습니다.
- `HW / 환경 확인`: 실제 보드, OS, Kernel, 핀, 버스 등 이번 변경과 관련된 확인 사실을 적습니다.
- `남은 제약`: 아직 구현하지 않았거나 검증하지 못한 내용을 적습니다.
- `참고`: 다음 Phase, 의존 PR, 면접 포인트 등 부가 정보를 적습니다.
- 실제 HW 검증 전에는 `동작 완료`, `검증 완료`라고 쓰지 않습니다.

## 표준 흐름

```text
현재 상태 확인
→ 최신 main 확인
→ 작업 브랜치 생성
→ 구현
→ 관련 문서와 CURRENT_STATUS 갱신
→ 빌드·테스트·실기기 검증
→ 변경 내용 검토
→ 규칙에 맞는 커밋
→ PR 생성
→ 사용자 확인
→ Squash merge
```

## Merge

- 기본 방식은 **Squash merge**입니다.
- 사용자가 PR 내용과 검증 결과를 확인한 뒤 직접 병합합니다.
- CI 또는 필수 검증이 실패한 상태에서는 병합하지 않습니다.
- 하나의 PR에는 하나의 목적을 유지합니다.

## 이 저장소에서 특히 지켜야 할 규칙

이 프로젝트는 HW/Firmware/Linux Kernel/Application이 함께 움직이므로 Git 이력에도 검증 경계를 남깁니다.

- SPI userspace 통신이 검증되기 전에 Kernel Driver 구현을 완료 처리하지 않습니다.
- Device Tree, Driver, Firmware 변경이 함께 필요한 경우 PR 본문에 각 계층의 변경 이유를 구분해 적습니다.
- `sleep()`이나 임시 우회로 문제가 가려진 상태에서는 Phase 완료로 처리하지 않습니다.
- 실제 Raspberry Pi 5 / STM32F103RB에서 확인하지 않은 값은 문서에 확정값으로 남기지 않습니다.
- `docs/CURRENT_STATUS.md`는 작업 종료 시 항상 현재 실제 상태와 맞아야 합니다.

## 참고한 기존 저장소 관례

- `Hamster_Algorithm`: `<type>/<english-kebab-case>` 브랜치, `<type>: <한글 설명>` 커밋/PR, Squash merge, 사용자 직접 병합
- `MyScheduler`: 동일한 브랜치·커밋 형식과 PR 기반 main 반영
- `Portfolio-site`: 한 브랜치 하나의 목적, 한글 커밋 설명, 사용자 승인 후 PR/병합, 작업 로그와 검증 결과 동시 관리

이 저장소는 위 관례를 그대로 유지하면서 HW 실기기 검증과 Roadmap Phase 관리 규칙만 추가합니다.
