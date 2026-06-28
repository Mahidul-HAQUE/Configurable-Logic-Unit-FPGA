# CLB Architecture

## Overview

The Configurable Logic Block (CLB) consists of four submodules connected in a fixed pipeline:

```
                     ┌─────────────┐
  D[7:0] ──LOAD──►  │  8-bit SRAM │ Q[7:0]
           CLK  ──► │     LUT     │ ──────────────────────────────────┐
                     └─────────────┘                                   │
                                                                        ▼
                                                              ┌──────────────────┐
  A ──────────────────────────────────────────────────────►  │                  │
  B ──────────────────────────────────────────────────────►  │   8×1 MUX Tree   │ ──► mux_out
  C ──────────────────────────────────────────────────────►  │  (3-level 2×1s)  │
                                                              └──────────────────┘
                                                                        │
                                          ┌─────────────────────────────┤
                                          │                             │
                                          ▼                             ▼
                                   ┌────────────┐              ┌──────────────┐
                          CLK ──►  │    DFF     │              │              │
                                   │  (pos-edge)│              │  2×1 MODE    │ ──► OUT
                                   └─────┬──────┘              │    MUX       │
                                         │       MODE=1 ──────►│              │
                                         └────────────────────►│  MODE=0 ──► direct
                                                               └──────────────┘
```

---

## Submodules

### 1. `sram_8bit` — Configuration Memory
- 8-bit register acting as the LUT storage
- `LOAD=1` on posedge CLK: writes `D[7:0]` into memory
- `LOAD=0`: holds stored configuration
- Behavioral model of a 6T SRAM array

### 2. `mux8x1` / `mux8x1_gl` — 8×1 Multiplexer
- 3-level binary tree of 2×1 muxes
- Address lines: `S = {A, B, C}`
  - `S[2] = A` (MSB)
  - `S[1] = B`
  - `S[0] = C` (LSB)
- Selects one of the 8 SRAM outputs

**Layer mapping:**

```
Layer 1 (C selects):   M0(D0,D1) M1(D2,D3) M2(D4,D5) M3(D6,D7)
Layer 2 (B selects):   M4(w01,w23)          M5(w45,w67)
Layer 3 (A selects):   M6(w0123, w4567) → Y
```

### 3. `dff` / `dff_gl` — D Flip-Flop
- Positive edge triggered
- Behavioral: `always @(posedge CLK) Q <= D`
- Gate-level: NAND-based master-slave topology

### 4. `mux2x1` / `mux2x1_gl` — Mode Selector
- `MODE=0`: combinational output (direct from 8×1 MUX)
- `MODE=1`: sequential output (registered through DFF)

---

## Boolean Function: Y = AB + C

Pre-programmed into SRAM as `8'b11101010`

| State | A | B | C | AB | Y = AB+C |
|-------|---|---|---|----|----------|
| 0     | 0 | 0 | 0 | 0  | **0**    |
| 1     | 0 | 0 | 1 | 0  | **1**    |
| 2     | 0 | 1 | 0 | 0  | **0**    |
| 3     | 0 | 1 | 1 | 0  | **1**    |
| 4     | 1 | 0 | 0 | 0  | **0**    |
| 5     | 1 | 0 | 1 | 0  | **1**    |
| 6     | 1 | 1 | 0 | 1  | **1**    |
| 7     | 1 | 1 | 1 | 1  | **1**    |

SRAM bit mapping: `D[state] = Y_value`
- `D[0]=0, D[1]=1, D[2]=0, D[3]=1, D[4]=0, D[5]=1, D[6]=1, D[7]=1`
- Binary: `8'b11101010`

---

## Operational Modes

### Combinational Mode (MODE=0)
- Output changes immediately when A, B, or C changes
- No clock dependency on output path
- Minimum propagation delay

### Sequential Mode (MODE=1)
- Output captured by DFF on positive clock edge
- Synchronized to system clock
- Introduces clock-to-Q delay
- Provides state retention between clock cycles
