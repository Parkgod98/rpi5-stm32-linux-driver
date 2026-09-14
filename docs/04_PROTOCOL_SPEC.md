# Protocol Specification

Status: **Draft for Phase 3**. Field sizes and opcodes may change during userspace bring-up. Do not call v1 frozen until Phase 3 exit criteria are met.

## Goals

- deterministic request/response behavior
- explicit versioning
- corruption detection
- stale/out-of-order response detection
- simple parsing on STM32F103RB
- easy reuse in userspace and kernel code

## Proposed frame

Initial proposal: fixed maximum frame with explicit payload length.

```c
struct f103_frame_v1 {
    uint8_t  magic0;       // 0xA5
    uint8_t  magic1;       // 0x5A
    uint8_t  version;      // 1
    uint8_t  opcode;
    uint16_t sequence;
    uint16_t payload_len;
    uint8_t  payload[22];
    uint16_t crc16;
} __attribute__((packed));
```

Expected size: 32 bytes. Confirm with compile-time assertions on both sides before freezing.

## Proposed commands

| Opcode | Name | Direction | Purpose |
|---:|---|---|---|
| `0x01` | GET_INFO | Pi -> STM32 | firmware/protocol identity |
| `0x02` | GET_STATUS | Pi -> STM32 | state/counters |
| `0x10` | SET_LED | Pi -> STM32 | visible control test |
| `0x11` | SET_PERIOD | Pi -> STM32 | configure periodic behavior |
| `0x20` | GET_STATS | Pi -> STM32 | protocol/error counters |
| `0x30` | ECHO | Pi -> STM32 | deterministic validation/benchmark |

Final opcode values are not frozen yet.

## Validation order

A receiver should validate, in a defined order:

1. frame availability / transfer length
2. magic
3. protocol version
4. payload length bounds
5. CRC
6. opcode-specific payload shape
7. sequence semantics when applicable

Malformed input must never be interpreted as a valid command.

## Sequence number

The host increments the request sequence. A response must identify the corresponding sequence. The host rejects a stale or mismatched response.

Sequence wrap-around behavior must be documented before v1 freeze.

## CRC

CRC16 polynomial/initialization/reflection/final-xor details are **TBD**. The exact variant must be fixed in this file and tested with golden vectors before kernel integration.

## SPI transaction timing challenge

SPI is host-clocked. The STM32 cannot spontaneously transmit a response without host clocks.

Preferred architecture for robust request/response:

```text
1. Pi sends request frame
2. STM32 validates/processes request
3. STM32 asserts READY/EVENT GPIO
4. Pi receives GPIO event
5. Pi clocks a response frame from STM32
```

During early bring-up, a simpler two-transaction userspace prototype may be used, but arbitrary delays must not become the final synchronization method.

## Response status

Each successful response should include an explicit status/error value in a defined location. Candidate statuses:

- OK
- UNKNOWN_OPCODE
- BAD_PAYLOAD
- BUSY
- INTERNAL_ERROR

Exact representation is TBD.

## Fault injection support

Firmware test mode should eventually support intentional:

- bad CRC
- delayed response
- dropped response
- wrong sequence

These are test capabilities, not production commands exposed accidentally.

## Protocol freeze checklist

- [ ] exact frame size confirmed by static assertions
- [ ] endianness explicitly defined
- [ ] CRC variant fixed with golden vectors
- [ ] all payload layouts documented
- [ ] all status/error values documented
- [ ] READY/event timing documented
- [ ] sequence wrap behavior documented
- [ ] host and firmware parser tests pass
