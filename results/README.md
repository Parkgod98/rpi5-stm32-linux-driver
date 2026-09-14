# 결과 및 Evidence

이 디렉터리에는 프로젝트에서 주장하는 내용을 실제로 뒷받침하는 Log와 측정 결과를 저장합니다.

결과가 생성되면 아래 구조를 사용합니다.

```text
results/
├── logs/
├── latency/
├── traces/
└── summaries/
```

각 결과 Set에는 가능한 한 아래 정보를 함께 기록합니다.
- 측정 날짜
- Git Commit SHA
- Raspberry Pi OS / Kernel
- Firmware Version
- SPI Mode / Clock
- 정확한 Command와 Test 횟수
- 결과 요약

이유 없이 매우 큰 Raw Capture를 Commit하지 않습니다. Claim을 다시 검증하는 데 필요한 최소 Log와 재현 가능한 Summary를 우선합니다.

Benchmark 수치는 추측하거나 다른 환경의 결과를 복사하지 않고 실제 측정값만 기록합니다.
