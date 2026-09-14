# Performance Plan

Performance work starts only after correctness and fault handling are stable.

## Primary metrics

For round-trip commands such as `ECHO`:

- total transactions
- success count / success rate
- p50 latency
- p95 latency
- p99 latency
- maximum latency
- timeout count
- CRC/sequence error count

For at least one real operation such as `GET_STATUS`, collect the same latency distribution.

## Test conditions

Record:
- Raspberry Pi OS and kernel version
- SPI clock/mode
- protocol frame size
- CPU load state
- power source
- firmware version
- driver commit SHA

## Baseline scenario

1. idle system
2. fixed SPI clock
3. 10,000 ECHO transactions
4. save raw sample or histogram-friendly output
5. compute summary metrics reproducibly

## Loaded scenario

Repeat while CPU load is applied, for example with an available stress tool. Do not introduce a dependency without documenting how it was installed.

Compare:
- success rate
- p95/p99 tail latency
- timeout/error behavior

## Tracing

Use tracing to answer a question, not for decoration.

Potential tools:
- `perf stat` for process/system counters
- ftrace tracepoints/function tracing around driver path where useful
- kernel logs for error/timeout correlation

Questions tracing may answer:
- Is tail latency dominated by userspace scheduling or SPI transaction time?
- Does IRQ/event wakeup add unexpected delay?
- Does CPU contention materially change latency?

## Optimization policy

Do not optimize by increasing SPI clock first.

Preferred order:
1. confirm correctness
2. identify measured bottleneck
3. change one variable
4. rerun same benchmark
5. record before/after result

No performance claim is allowed without a repeatable measurement.
