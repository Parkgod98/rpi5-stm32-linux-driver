.PHONY: help setup firmware userspace driver dtbo load unload test fault-test benchmark status

help:
	@echo "rpi5-stm32-linux-driver"
	@echo ""
	@echo "Targets are introduced phase by phase. Unimplemented targets fail intentionally."
	@echo "  make status      - show current project status"
	@echo "  make setup       - phase 0 environment checks (future)"
	@echo "  make firmware    - STM32 firmware build (future)"
	@echo "  make userspace   - userspace app build (future)"
	@echo "  make driver      - kernel module build (future)"
	@echo "  make dtbo        - device tree overlay build (future)"
	@echo "  make load        - load driver (future)"
	@echo "  make unload      - unload driver (future)"
	@echo "  make test        - current phase tests (future)"
	@echo "  make fault-test  - fault injection suite (future)"
	@echo "  make benchmark   - latency benchmark (future)"

status:
	@cat docs/CURRENT_STATUS.md

setup firmware userspace driver dtbo load unload test fault-test benchmark:
	@echo "ERROR: target '$@' is not implemented in the current phase."
	@echo "Read docs/CURRENT_STATUS.md and docs/02_ROADMAP.md."
	@exit 2
