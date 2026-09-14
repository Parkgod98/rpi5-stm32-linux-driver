# Linux Driver

목표는 STM32F103RB 기반 Device를 위한 Custom Linux SPI Peripheral/Protocol Driver를 구현하는 것입니다.

userspace `spidev` 통신과 Protocol v1을 실제 HW에서 검증한 뒤 구현을 시작합니다.

예정 구성:
- SPI `probe()` / `remove()`
- Request/Response Transaction Layer
- CRC / Sequence / Timeout 처리
- `miscdevice` 기반 `/dev/f103bridge`
- 안정적인 UAPI
- GPIO IRQ / Event 전달
- Wait Queue + `poll()`
- Error / Statistics Counter

Raspberry Pi SPI Controller Driver 자체 구현은 이 프로젝트의 범위가 아닙니다.
