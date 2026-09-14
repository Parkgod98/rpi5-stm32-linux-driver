# 성능 측정 계획

Performance 최적화는 Correctness와 Fault Handling이 안정된 뒤 시작합니다.

## 주요 측정 지표

`ECHO`와 같은 Round-trip Command에서 아래를 측정합니다.

- 전체 Transaction 수
- 성공 횟수와 성공률
- p50 Latency
- p95 Latency
- p99 Latency
- 최대 Latency
- Timeout Count
- CRC / Sequence Error Count

`GET_STATUS`처럼 실제 기능 Command 최소 1개에서도 동일한 Latency Distribution을 수집합니다.

## 기록해야 할 테스트 조건

- Raspberry Pi OS와 Kernel Version
- SPI Clock / Mode
- Protocol Frame Size
- CPU Load 상태
- 전원 공급 방식
- Firmware Version
- Driver Commit SHA

## Baseline 측정

1. System Idle 상태
2. 고정 SPI Clock
3. `ECHO` 10,000회
4. Raw Sample 또는 Histogram을 만들 수 있는 원본 결과 저장
5. 동일한 Script로 Summary Metric 계산

## CPU Load 조건

사용 가능한 Stress Tool로 CPU Load를 준 상태에서 같은 Test를 반복합니다. 새 Tool을 설치했다면 설치 방법도 문서화합니다.

비교 항목:
- 성공률
- p95 / p99 Tail Latency
- Timeout / Error 동작

## Tracing

Tracing Tool은 장식이 아니라 질문에 답하기 위해 사용합니다.

사용 후보:
- `perf stat` — Process/System Counter 확인
- `ftrace` — 필요할 경우 Driver Path의 Function 또는 Tracepoint 확인
- Kernel Log — Error/Timeout과 동작 시점 비교

Tracing으로 확인할 질문 예시:
- Tail Latency의 주요 원인이 userspace Scheduling인가, SPI Transaction인가?
- IRQ/Event Wake-up이 예상보다 큰 Delay를 만드는가?
- CPU Contention이 Latency에 실제 영향을 주는가?

## 최적화 원칙

첫 번째 최적화로 SPI Clock부터 올리지 않습니다.

순서:
1. Correctness 확인
2. 실제 측정으로 병목 확인
3. 한 번에 하나의 변수 변경
4. 같은 Benchmark 재실행
5. 변경 전/후 결과 기록

반복 가능한 측정 없이 성능이 좋아졌다고 기록하지 않습니다.
