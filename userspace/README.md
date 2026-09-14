# Userspace

Two roles are expected here over the project lifecycle.

## Phase 2 prototype

A small `spidev` client validates wiring, SPI configuration, and protocol before any custom kernel driver is introduced.

## Final application

`f103ctl` should talk to `/dev/f103bridge` and expose commands such as:

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

The final userspace app must not depend on kernel-private structures.
