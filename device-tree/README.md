# Device Tree

이 디렉터리에는 Raspberry Pi 5에서 STM32F103RB 기반 SPI Peripheral을 생성하기 위한 Custom Device Tree Overlay/Node를 저장합니다.

예정 역할:
- 사용할 SPI Controller와 Chip Select 활성화/선택
- Peripheral Node 생성
- 프로젝트 전용 `compatible` String 정의
- 필요 시 READY/EVENT GPIO/IRQ 기술
- 같은 Chip Select에서 `spidev`와 Custom Driver가 동시에 소유권을 갖지 않도록 충돌 방지

최종 GPIO, Bus, Chip Select 값은 실제 HW에서 확인해 `docs/03_HW_SETUP.md`에 기록하기 전까지 Hard Coding하지 않습니다.
