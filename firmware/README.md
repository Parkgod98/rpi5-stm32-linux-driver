# STM32 Firmware

목표는 STM32F103RB를 SPI Peripheral로 동작시키는 Firmware를 구현하는 것입니다.

정확한 Board와 Pin Mapping을 확인한 뒤 Phase 1에서 구현을 시작합니다.

예정 구성:
- SPI Peripheral Bring-up
- Protocol Parser
- Command Handler
- CRC / Sequence 처리
- READY/EVENT GPIO
- Test Build용 Fault Injection Hook

실제 Board와 Toolchain이 `docs/03_HW_SETUP.md`에서 확정되기 전에는 전체 STM32Cube Project를 추측으로 생성하지 않습니다.
