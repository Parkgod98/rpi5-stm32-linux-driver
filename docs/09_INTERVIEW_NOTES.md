# 면접 대비 질문

목표는 프로젝트가 끝났을 때 아래 질문을 **실제 구현 Evidence를 바탕으로 본인의 말로 설명할 수 있는 상태**가 되는 것입니다.

## Architecture

1. Raspberry Pi 5와 STM32F103RB 통신에 왜 SPI를 선택했는가?
2. 왜 Raspberry Pi를 SPI Host로, STM32를 Peripheral로 구성했는가?
3. SPI Controller Driver와 SPI Peripheral/Protocol Driver의 차이는 무엇인가?
4. Custom Kernel Driver를 만들기 전에 왜 `spidev`로 통신을 먼저 검증했는가?
5. C++ Application에서 STM32까지 내려갔다가 다시 올라오는 전체 경로를 그려 설명해보라.
6. 어떤 부분이 userspace에서 실행되고 어떤 부분이 Kernel Space에서 실행되는가?

## Device Tree / Driver Model

7. 이 프로젝트에서 Device Tree가 왜 필요한가?
8. `compatible` String은 어떤 역할을 하는가?
9. Kernel은 어떤 기준으로 Device와 Driver를 Binding하는가?
10. `probe()`와 `remove()`에서는 각각 어떤 일을 하는가?
11. 같은 Chip Select에서 `spidev`와 Custom Driver가 왜 충돌할 수 있는가?

## Kernel / userspace Interface

12. 왜 `miscdevice` / Character Device 형태의 Interface를 선택했는가?
13. `read/write`, `ioctl`, `poll`은 각각 어떤 상황에 사용하는가?
14. Kernel과 userspace 사이에서 Data를 어떻게 안전하게 전달하는가?
15. Kernel 내부 Structure를 UAPI로 그대로 노출하면 왜 안 되는가?
16. Process가 `poll()`에서 Block된 상태로 Driver가 Remove되면 어떻게 처리해야 하는가?

## SPI / Protocol

17. Protocol에 Magic, Version, Payload Length, Sequence, CRC가 각각 왜 필요한가?
18. SPI Peripheral은 왜 원하는 시점에 혼자 Response를 보낼 수 없는가?
19. Request 처리와 Response 준비 사이의 Timing 문제를 어떻게 해결했는가?
20. Sequence Number가 Wrap-around되면 어떻게 처리하는가?
21. 어떤 CRC Variant를 사용했고 왜 선택했는가? Golden Test Vector로 설명할 수 있는가?
22. Transport Failure와 Protocol Failure를 어떻게 구분하는가?

## Interrupt / Concurrency

23. STM32에서 발생한 Event가 userspace의 `poll()`까지 어떤 경로로 전달되는가?
24. Hard IRQ Handler에서 하면 안 되는 작업은 무엇인가?
25. 이 프로젝트에서 Threaded IRQ 또는 Deferred Work가 필요한 이유는 무엇인가?
26. 어떤 Shared State에 Lock이 필요하고 왜 필요한가?
27. 모든 Context에서 Mutex를 사용할 수 없는 이유는 무엇인가?
28. 두 userspace Request가 하나의 SPI Transaction State를 동시에 건드리지 않도록 어떻게 보호했는가?

## Reliability

29. STM32가 끝까지 응답하지 않으면 어떻게 되는가?
30. CRC가 틀리면 어떻게 처리하는가?
31. 오래되거나 Sequence가 다른 Response는 어떻게 처리하는가?
32. Transaction 도중 STM32가 Reset되면 어떻게 처리하는가?
33. Driver가 Deadlock이나 무한 대기에 빠지지 않는다는 것을 어떻게 검증했는가?
34. 어떤 Fault를 의도적으로 주입했는가?
35. Fault 발생 후 자동 Recovery가 가능한 경우와 Reinitialization이 필요한 경우를 어떻게 나눴는가?

## Performance

36. Round-trip Latency를 어떤 기준과 방법으로 측정했는가?
37. 평균값만 보지 않고 p95/p99를 보는 이유는 무엇인가?
38. CPU Load를 주었을 때 어떤 변화가 있었는가?
39. 사용했다면 `perf` 또는 `ftrace`에서 무엇을 확인했는가?
40. 실제 측정에서 병목은 어디였는가?
41. SPI Frequency를 단순히 높이는 것이 첫 번째 최적화가 될 수 없는 이유는 무엇인가?

## 설계 Trade-off

42. 이 프로젝트에서 최종적으로 `spidev`만 계속 사용하지 않고 Custom Driver를 만든 이유는 무엇인가?
43. SPI 대신 UART나 I2C를 사용하지 않은 이유는 무엇인가?
44. 별도의 READY/EVENT GPIO를 둔 이유는 무엇인가?
45. Variable Length Transfer 대신 Fixed-size Frame을 선택한다면 장단점은 무엇인가?
46. 실제 상용 제품이라면 어떤 부분을 추가하거나 바꿔야 하는가?
47. Throughput 요구가 100배 높다면 무엇을 바꾸겠는가?
48. Safety / Reliability 요구 수준이 더 높다면 무엇을 바꾸겠는가?

## 본인의 구현 이해도

49. 가장 어려웠던 Bug는 무엇이었고 어떻게 원인을 격리했는가?
50. 프로젝트를 시작할 때 Linux Device Driver에 대해 잘못 이해하고 있던 부분은 무엇인가?
51. 실제 측정이나 Test 이후 바꾼 설계 결정이 있는가?
52. 직접 구현한 부분과 Kernel/Framework API를 재사용한 부분을 구분해서 설명할 수 있는가?
53. Application만 만드는 프로젝트에서는 배우기 어려웠지만 이번 프로젝트에서 이해하게 된 것은 무엇인가?
54. 이 프로젝트를 30초, 2분, 5분 버전으로 각각 설명해보라.

## 답변 작성 규칙

생성된 교과서식 답변을 외우지 않습니다. 각 질문마다 최종적으로 아래 네 가지를 기록합니다.

- 핵심 개념
- 이 프로젝트에서 실제로 구현한 내용
- Evidence: Code / Test / Log
- Trade-off 또는 한계

이 파일을 열지 않고도 답할 수 있을 때 해당 질문을 면접 준비 완료로 봅니다.
