# CLB in Verilog — Behavioral & Gate-Level Implementation

> Companion Verilog implementation for the published paper:
> **"Comparative Analysis of Configurable Logic Block Using Static CMOS, Transmission Gate and Gate Diffusion Input Techniques"**
> *ICCIT 2025, Cox's Bazar, Bangladesh*
> DOI: 10.1109/ICCIT68739.2025.11491834

---

## What is this?

This repository contains a Verilog implementation of the Configurable Logic Block (CLB) designed and analyzed in Cadence Virtuoso (see the [CLB-in-Cadence](https://github.com/Mahidul-HAQUE/CLB-in-Cadence) repository). The Verilog version covers both **behavioral (RTL)** and **gate-level structural** implementations, with full testbenches for each submodule and the complete CLB.

---

## CLB Architecture

```
D[7:0] ──LOAD──► [ 8-bit SRAM LUT ] ──► [ 8×1 MUX ] ──►┬──────────────► OUT
                        ▲                    ▲            │   (MODE=0)
                       CLK              A, B, C           └──► [ DFF ] ──► OUT
                                       (select)                  ▲   (MODE=1)
                                                                 CLK
```

**Boolean Function implemented:** `Y = AB + C`

| State | A | B | C | Y |
|-------|---|---|---|---|
| 0     | 0 | 0 | 0 | 0 |
| 1     | 0 | 0 | 1 | 1 |
| 2     | 0 | 1 | 0 | 0 |
| 3     | 0 | 1 | 1 | 1 |
| 4     | 1 | 0 | 0 | 0 |
| 5     | 1 | 0 | 1 | 1 |
| 6     | 1 | 1 | 0 | 1 |
| 7     | 1 | 1 | 1 | 1 |

---

## Repository Structure

```
CLB-Verilog/
├── README.md
├── .gitignore
│
├── behavioral/                  # RTL behavioral models
│   ├── sram_8bit.v              # 8-bit SRAM configuration memory (LUT)
│   ├── mux2x1.v                 # 2×1 multiplexer
│   ├── mux8x1.v                 # 8×1 multiplexer (3-layer 2×1 tree)
│   ├── dff.v                    # Positive edge triggered D flip-flop
│   └── clb_top.v                # CLB top-level integration
│
├── gate_level/                  # Gate-level structural models
│   ├── mux2x1_gl.v              # 2×1 MUX using AND/OR/NOT primitives
│   ├── mux8x1_gl.v              # 8×1 MUX (gate-level 2×1 tree)
│   ├── dff_gl.v                 # DFF using NAND master-slave topology
│   └── clb_top_gl.v             # Gate-level CLB top
│
├── tb/                          # Testbenches
│   ├── sram_8bit_tb.v           # SRAM unit testbench
│   ├── dff_tb.v                 # DFF testbench (behavioral + gate-level)
│   └── clb_top_tb.v             # Full CLB testbench (both modes, both implementations)
│
├── sim/                         # Simulation outputs (generated, gitignored)
│   └── run_all.sh               # Script to run all simulations
│
└── docs/
    ├── architecture.md          # Detailed architecture and signal descriptions
    └── toolchain.md             # Tool installation guide (Icarus, GTKWave, TerosHDL)
```

---

## Quick Start

### Prerequisites
Install the toolchain — see [`docs/toolchain.md`](docs/toolchain.md)

```bash
# Verify tools are installed
iverilog -V
vvp -V
gtkwave --version
```

### Run All Tests
```bash
bash sim/run_all.sh
```

### Run Individually

**SRAM:**
```bash
iverilog -o sim/sram_sim behavioral/sram_8bit.v tb/sram_8bit_tb.v
vvp sim/sram_sim
```

**DFF (behavioral + gate-level compared):**
```bash
iverilog -o sim/dff_sim behavioral/dff.v gate_level/dff_gl.v tb/dff_tb.v
vvp sim/dff_sim
```

**Full CLB:**
```bash
iverilog -o sim/clb_sim \
  behavioral/sram_8bit.v behavioral/mux2x1.v behavioral/mux8x1.v \
  behavioral/dff.v behavioral/clb_top.v \
  gate_level/mux2x1_gl.v gate_level/mux8x1_gl.v \
  gate_level/dff_gl.v gate_level/clb_top_gl.v \
  tb/clb_top_tb.v
vvp sim/clb_sim
```

### View Waveforms
```bash
gtkwave sim/clb_top.vcd
```

---

## Test Results

| Testbench        | Description                              | Passed | Total |
|-----------------|------------------------------------------|--------|-------|
| `sram_8bit_tb`  | Load, hold, arbitrary pattern tests      | 5      | 5     |
| `dff_tb`        | Edge capture, hold, toggle (beh + GL)    | 9      | 9     |
| `clb_top_tb`    | All 8 truth table states, both modes     | 11     | 11    |
| **Total**       |                                          | **25** | **25**|

---

## Relation to Cadence Implementation

| Cadence (paper)          | Verilog (this repo)                        |
|--------------------------|--------------------------------------------|
| 6T SRAM array            | `behavioral/sram_8bit.v` (RTL model)       |
| 8×1 MUX (transistor)     | `gate_level/mux8x1_gl.v` (AND/OR/NOT)     |
| 2×1 MUX (transistor)     | `gate_level/mux2x1_gl.v`                  |
| DFF (master-slave CMOS)  | `gate_level/dff_gl.v` (NAND-based)        |
| Combinational mode        | `MODE=0` in `clb_top.v`                   |
| Sequential mode           | `MODE=1` in `clb_top.v`                   |
| Static CMOS style         | Gate-level folder (`gate_level/`)         |
| Behavioral reference      | Behavioral folder (`behavioral/`)         |

---

## Related Repository

- **Cadence Virtuoso implementation:** [CLB-in-Cadence](https://github.com/Mahidul-HAQUE/CLB-in-Cadence)

---

## Authors

Md. Mahidul Haque, Md. Mahfuzur Rashid, Saquib Farhan, Md Tawfiq Amin
Department of Electrical, Electronic and Communication Engineering
Military Institute of Science and Technology (MIST), Dhaka, Bangladesh

---

## Reference

M. M. Haque, M. M. Rashid, S. Farhan, and M. T. Amin, "Comparative Analysis of Configurable Logic Block Using Static CMOS, Transmission Gate and Gate Diffusion Input Techniques," *2025 28th International Conference on Computer and Information Technology (ICCIT)*, Cox's Bazar, Bangladesh, 2025, pp. 4921–4926, doi: 10.1109/ICCIT68739.2025.11491834.

