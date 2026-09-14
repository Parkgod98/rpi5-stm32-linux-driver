# 현재 진행 상태

마지막 갱신: 2026-09-14

## 현재 Phase

**Phase 0 — 환경과 장비 확인**

아직 실제 HW/Firmware/Driver 구현을 완료한 것으로 간주하는 항목은 없습니다.

## 마지막으로 확인된 결과

- GitHub Repository 생성: `Parkgod98/rpi5-stm32-linux-driver`
- 프로젝트 개발 하네스와 전체 Roadmap 작성
- 기존 개인 Repository의 Git 규칙을 반영해 Branch / Commit / PR 규칙 정립
- 프로젝트 문서는 한글을 기본으로 하고 기술 용어만 필요한 범위에서 영어를 사용하는 기준 정립
- 현재 작업 PR: `#2 chore: 프로젝트 개발 하네스와 작업 규칙 구축`

## 현재 Blocker / 사용자 확인이 필요한 내용

HW 의존 구현을 시작하기 전에 아래를 확인해야 합니다.

1. STM32 보드에 인쇄된 정확한 Board Model. 예상 후보는 `NUCLEO-F103RB`지만 실제 확인 전에는 확정하지 않습니다.
2. Raspberry Pi 5가 준비되어 있고 정상 Boot되는지 확인합니다.
3. 사용할 Jumper Wire와 STM32 Board의 전원/Programming 방식을 확인합니다.
4. 아래 명령으로 Raspberry Pi OS / Kernel 환경을 확인합니다.

## 다음 행동

### Raspberry Pi 5

아래를 실행하고 출력 전체를 저장합니다.

```bash
uname -a
cat /proc/device-tree/model; echo
cat /etc/os-release
lsblk
ls /dev/spidev* 2>/dev/null || true
lsmod | grep -E 'spi|gpio' || true
```

SPI가 아직 활성화되지 않았다면 기억에 의존해 설정하지 않고, 실제 Raspberry Pi OS Version을 기준으로 절차를 확인하고 문서에 남깁니다.

### STM32

- Board 앞면의 모델명 또는 사진으로 정확한 Board를 확인합니다.
- STM32CubeIDE 또는 선택한 Toolchain에서 Board를 Detect하고 Flash할 수 있는지 확인합니다.
- 정확한 Board Pin Mapping을 확인하기 전에는 최종 SPI Pin을 정하지 않습니다.

## 현재까지 수집한 Evidence

실물 HW에서 수집한 Evidence는 아직 없습니다.

향후 Log와 측정 결과는 아래에 저장합니다.

- `results/logs/`
- `results/latency/`
- `results/traces/`

## 아직 시작하지 않는 작업

Phase 0/1의 실제 Evidence가 생기기 전에는 아래를 시작하지 않습니다.

- 최종 Device Tree Overlay 작성
- GPIO 번호 추측 또는 확정
- Kernel Driver가 동작한다고 기록
- 포트폴리오에 예정 기능을 완료형으로 기록
- SPI Clock 최적화
- IRQ / `poll()` 구현

## 중단 후 다시 시작할 때

1. 이 문서를 먼저 읽습니다.
2. `02_ROADMAP.md`에서 현재 Phase의 완료 조건을 확인합니다.
3. 최신으로 Merge된 PR과 Evidence를 확인합니다.
4. 새로운 Evidence가 계획을 바꾸지 않는 한 이 문서의 다음 행동부터 진행합니다.
5. 작업을 마치기 전 이 문서를 갱신합니다.
