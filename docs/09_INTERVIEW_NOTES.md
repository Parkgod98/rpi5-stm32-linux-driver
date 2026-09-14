# Interview Notes

Goal: by project completion, answer each question in your own words using actual implementation evidence.

## Architecture

1. Why did you choose SPI for Raspberry Pi 5 <-> STM32F103RB communication?
2. Why is Raspberry Pi the SPI host and STM32 the peripheral?
3. What is the difference between an SPI controller driver and an SPI peripheral/protocol driver?
4. Why did you verify communication with `spidev` before writing a custom kernel driver?
5. Draw the full path from C++ application to STM32 and back.
6. Which parts run in userspace and which in kernel space?

## Device Tree / driver model

7. Why is Device Tree used in this project?
8. What does the `compatible` string do?
9. How does the kernel decide which driver binds to the device?
10. What happens in `probe()` and `remove()`?
11. Why can `spidev` conflict with the custom driver on the same chip select?

## Kernel/userspace interface

12. Why did you choose a `miscdevice`/character-device style interface?
13. When would you use `read/write`, `ioctl`, or `poll`?
14. How do you safely move data across the kernel/userspace boundary?
15. Why should kernel-private structures not be exposed directly as a UAPI?
16. What happens if a process is blocked in `poll()` while the driver is removed?

## SPI/protocol

17. Why does the protocol need magic, version, payload length, sequence, and CRC?
18. Why can an SPI peripheral not simply send a response whenever it wants?
19. How did you solve the request-processing-response timing problem?
20. What happens when sequence numbers wrap?
21. What exact CRC variant did you use and why? Show a golden test vector.
22. How do you distinguish transport failure from protocol failure?

## Interrupts/concurrency

23. How does an STM32 event reach a userspace `poll()` call?
24. What work should not be done in a hard IRQ handler?
25. Why might a threaded IRQ or deferred work be useful here?
26. Which state requires locking and why?
27. Why can a mutex not be used in every context?
28. How do you prevent two userspace requests from corrupting a single SPI transaction state?

## Reliability

29. What happens if STM32 never responds?
30. What happens on a bad CRC?
31. How is a stale/wrong-sequence response handled?
32. What happens if STM32 resets mid-transaction?
33. How did you prove the driver does not deadlock or wait forever?
34. Which faults did you intentionally inject?
35. After a fault, which cases should recover automatically and which should require reinitialization?

## Performance

36. How did you measure round-trip latency?
37. Why report p95/p99 instead of only average latency?
38. What changed under CPU load?
39. What did `perf`/ftrace reveal, if used?
40. What was the actual bottleneck?
41. Why is simply increasing SPI frequency not a valid first optimization?

## Design trade-offs

42. Why not just keep using `spidev` in production for this project?
43. Why not use UART or I2C instead?
44. Why use an extra READY/EVENT GPIO?
45. Why use a fixed-size frame versus variable-length transfers?
46. What would you change for a real commercial product?
47. What would you change if throughput requirements were 100x higher?
48. What would you change if safety/reliability requirements were stronger?

## Personal ownership

49. What was the hardest bug and how did you isolate it?
50. What did you initially misunderstand about Linux device drivers?
51. Which design decision did you change after measuring or testing?
52. Which part did you implement yourself versus reuse from framework/kernel APIs?
53. What did this project teach you that an application-only project did not?
54. Explain the project in 30 seconds, 2 minutes, and 5 minutes.

## Answering rule

Do not memorize generated textbook answers. For each question, eventually record:

- concept
- what this project actually did
- evidence (code/test/log)
- trade-off or limitation

A question is considered interview-ready only when it can be answered without opening this file.
