# Scripts

반복해서 사용하는 명령은 채팅 기록에만 남기지 않고 이 디렉터리에 Script로 저장합니다.

예정 구조:
- `setup/` — 환경 확인과 Dependency/Setup 보조
- `build/` — Firmware / userspace / Driver / Device Tree Build
- `load/` — Module / Overlay Load-Unload
- `test/` — Integration Test
- `fault/` — Fault Injection 실행
- `benchmark/` — Latency / Performance 측정

모든 Script는 아래 원칙을 따릅니다.
- 예상하지 못한 Error가 발생하면 명확하게 실패합니다.
- 필요한 경우 어떤 환경과 Target에서 실행 중인지 출력합니다.
- 무조건적인 `|| true`로 실패를 숨기지 않습니다.
- 관련 문서 또는 Root `Makefile`에서 실행 방법을 연결합니다.
