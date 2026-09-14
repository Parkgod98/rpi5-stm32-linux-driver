# Results

Store evidence that supports project claims.

Suggested layout as results are produced:

```text
results/
├── logs/
├── latency/
├── traces/
└── summaries/
```

For each result set, preserve:
- date
- git commit SHA
- Raspberry Pi OS/kernel
- firmware version
- SPI mode/clock
- exact command/test count
- result summary

Do not commit huge raw captures without a reason. Prefer reproducible summaries plus the minimal logs needed to verify a claim.

No benchmark numbers should be invented or copied from another environment.
