# userspace

이 디렉터리는 프로젝트 진행 과정에서 두 역할을 담당합니다.

## Phase 2 Prototype

Custom Kernel Driver를 만들기 전에 작은 `spidev` Client를 구현해 배선, SPI 설정, 최소 Protocol이 실제 HW에서 정상 동작하는지 검증합니다.

## 최종 Application

최종 `f103ctl`은 `/dev/f103bridge`를 통해 Custom Driver와 통신하며 아래와 같은 Command를 제공합니다.

```text
f103ctl info
f103ctl status
f103ctl led on
f103ctl led off
f103ctl period <ms>
f103ctl echo <count>
f103ctl watch
f103ctl benchmark <count>
```

최종 userspace Application은 Kernel 내부 Structure에 직접 의존하지 않습니다.
