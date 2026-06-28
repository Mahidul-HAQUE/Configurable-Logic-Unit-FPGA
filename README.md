# Configurable Logic Block (CLB) — Verilog Implementation

[![Conference](https://img.shields.io/badge/IEEE-ICCIT_2025-blue.svg)](https://ieeexplore.ieee.org/document/11491834)
[![DOI](https://img.shields.io/badge/DOI-10.1109%2FICCIT68739.2025.11491834-darkgreen.svg)](https://doi.org/10.1109/ICCIT68739.2025.11491834)
[![Verilog](https://img.shields.io/badge/Verilog-HDL-orange.svg)](https://en.wikipedia.org/wiki/Verilog)
[![Simulator](https://img.shields.io/badge/Simulator-Icarus_Verilog-purple.svg)](http://iverilog.icarus.com/)
[![Waveform](https://img.shields.io/badge/Waveform-GTKWave-teal.svg)](http://gtkwave.sourceforge.net/)
[![Tests](https://img.shields.io/badge/Tests-25%2F25_Passing-brightgreen.svg)](#-test-results)
[![Process](https://img.shields.io/badge/Process-90nm_CMOS-red.svg)](https://www.cadence.com/)

Official Verilog companion repository for the paper:
**"Comparative Analysis of Configurable Logic Block Using Static CMOS, Transmission Gate and Gate Diffusion Input Techniques"**
presented at the **2025 28th International Conference on Computer and Information Technology (ICCIT)**, Cox's Bazar, Bangladesh.

---

## 📌 Citation & Publications

If you use this work in your research, please cite our paper:

```bibtex
@INPROCEEDINGS{11491834,
  author={Haque, Md. Mahidul and Rashid, Md. Mahfuzur and Farhan, Saquib and Amin, Md Tawfiq},
  booktitle={2025 28th International Conference on Computer and Information Technology (ICCIT)},
  title={Comparative Analysis of Configurable Logic Block Using Static CMOS,
         Transmission Gate and Gate Diffusion Input Techniques},
  year={2025},
  pages={4921--4926},
  keywords={CLB; Static CMOS; TGL; GDI; FPGA; Performance Analysis; 90nm},
  doi={10.1109/ICCIT68739.2025.11491834}
}
```

- **IEEE Xplore:** [ICCIT 2025 — Document 11491834](https://ieeexplore.ieee.org/document/11491834)
- **DOI:** https://doi.org/10.1109/ICCIT68739.2025.11491834
- **Cadence Implementation:** [Configurable-Logic-Unit-FPGA](https://github.com/Mahidul-HAQUE/Configurable-Logic-Unit-FPGA)

---

## 📖 Abstract

Configurable Logic Blocks (CLBs) serve as fundamental building elements in reconfigurable computing platforms where performance, energy efficiency, and silicon utilization are critical design considerations. This work systematically evaluates CLB implementations using **Static CMOS**, **Transmission Gate Logic (TGL)**, and **Gate Diffusion Input (GDI)** in a **90 nm** process using Cadence Virtuoso.

Key findings from the paper:

| Logic Style | Delay (ps) | Max Freq. (GHz) | Area (µm²)  | Avg. Energy (fJ) |
|-------------|-----------|----------------|-------------|-----------------|
| Static CMOS | **55.49** | **11.767**     | 2176.52     | 171.6           |
| TGL         | 337.18    | 7.53           | 2025.08     | **139.1**       |
| GDI         | 1297.78   | 1.396          | **804.824** | 167.1           |

This repository provides the **Verilog RTL and gate-level implementation** of that CLB for simulation, verification, and educational purposes.

---

## 🏗️ CLB Architecture

The CLB integrates four submodules in a fixed pipeline:

```
                  LOAD
                   │
D[7:0] ────────►  │   ┌──────────────┐    ┌──────────────────┐
                   └──►│  8-bit SRAM  │    │                  │
         CLK ────────►│     LUT      ├───►│    8×1 MUX Tree  ├──► mux_out ──┬──────────────► OUT
                       └──────────────┘    │   (3-level 2×1)  │              │    (MODE=0)
                                           └────────┬─────────┘              │
                                                    │                        └──► ┌─────┐
                                                A, B, C                          │ DFF │──► OUT
                                              (select lines)           CLK ────►│     │   (MODE=1)
                                                                                 └─────┘
```

**Boolean Function:** `Y = AB + C` (pre-programmed into SRAM as `8'b11101010`)

### Truth Table (Table I from Paper)

| State | A | B | C | AB | **Y = AB + C** |
|-------|---|---|---|----|----------------|
| 0     | 0 | 0 | 0 | 0  | **0**          |
| 1     | 0 | 0 | 1 | 0  | **1**          |
| 2     | 0 | 1 | 0 | 0  | **0**          |
| 3     | 0 | 1 | 1 | 0  | **1**          |
| 4     | 1 | 0 | 0 | 0  | **0**          |
| 5     | 1 | 0 | 1 | 0  | **1**          |
| 6     | 1 | 1 | 0 | 1  | **1**          |
| 7     | 1 | 1 | 1 | 1  | **1**          |

---

## 📂 Repository Structure

```
Configurable-Logic-Unit-FPGA/
│
├── behavioral/                  # RTL behavioral models
│   ├── sram_8bit.v              # 8-bit SRAM configuration memory (LUT)
│   ├── mux2x1.v                 # 2×1 multiplexer
│   ├── mux8x1.v                 # 8×1 multiplexer (3-layer 2×1 tree)
│   ├── dff.v                    # Positive edge triggered D flip-flop
│   └── clb_top.v                # CLB top-level integration
│
├── gate_level/                  # Gate-level structural models (Static CMOS style)
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
├── sim/
│   └── run_all.sh               # Script to run all simulations at once
│
├── Cadence Zip Library/         # Original Cadence Virtuoso design files
│
└── docs/
    ├── architecture.md          # Detailed architecture and signal descriptions
    └── toolchain.md             # Tool installation guide
```

---

## ⚙️ Submodule Overview

### 1. `sram_8bit` — Configuration Memory
Behavioral model of the 6T SRAM array from the paper. `LOAD=1` on posedge CLK writes the 8-bit configuration into memory. The stored bits represent the LUT truth table output for all input combinations.

### 2. `mux8x1` / `mux8x1_gl` — 8×1 Multiplexer Tree
Three-level binary tree of 2×1 muxes matching the paper's Fig. 3. Address lines `{A, B, C}` map to `S[2:1:0]` respectively.

```
Layer 1 (C selects):  M0(D0,D1)  M1(D2,D3)  M2(D4,D5)  M3(D6,D7)
Layer 2 (B selects):  M4(w01,w23)            M5(w45,w67)
Layer 3 (A selects):  M6(w0123, w4567) → Y
```

### 3. `dff` / `dff_gl` — D Flip-Flop
- Behavioral: `always @(posedge CLK) Q <= D`
- Gate-level: NAND-based master-slave topology (models Static CMOS DFF from paper Fig. 2)

### 4. Mode Selection MUX
- `MODE=0` → Combinational output (direct from 8×1 MUX, minimum delay)
- `MODE=1` → Sequential output (registered through DFF, clock-synchronized)

---

## 🛠️ Toolchain Setup

| Software       | Purpose                    | Verify Command                  |
|---------------|---------------------------|---------------------------------|
| Python 3       | Required runtime           | `python --version`              |
| VS Code        | Editor                     | `code --version`                |
| TerosHDL      | Schematic viewer extension | Installed in Extensions panel   |
| Icarus Verilog | Compile / simulate         | `iverilog -V`                   |
| VVP            | Simulation runtime         | `vvp -V`                        |
| GTKWave        | Waveform viewer            | `gtkwave --version`             |
| yowasp-yosys  | Yosys for TerosHDL         | `python -m yowasp_yosys --help` |

Install yowasp-yosys:
```bash
pip install yowasp-yosys
```

Full installation guide: [`docs/toolchain.md`](docs/toolchain.md)

---

## 🚀 Quick Start

### Run All Tests at Once
```bash
bash sim/run_all.sh
```

### Run Individually

**SRAM testbench:**
```bash
iverilog -o sim/sram_sim behavioral/sram_8bit.v tb/sram_8bit_tb.v
vvp sim/sram_sim
```

**DFF testbench (behavioral + gate-level compared side by side):**
```bash
iverilog -o sim/dff_sim behavioral/dff.v gate_level/dff_gl.v tb/dff_tb.v
vvp sim/dff_sim
```

**Full CLB testbench (both implementations, both modes):**
```bash
iverilog -o sim/clb_sim \
  behavioral/sram_8bit.v behavioral/mux2x1.v behavioral/mux8x1.v \
  behavioral/dff.v behavioral/clb_top.v \
  gate_level/mux2x1_gl.v gate_level/mux8x1_gl.v \
  gate_level/dff_gl.v gate_level/clb_top_gl.v \
  tb/clb_top_tb.v
vvp sim/clb_sim
```

**View waveforms in GTKWave:**
```bash
gtkwave sim/clb_top.vcd
```

---

## ✅ Test Results

| Testbench       | Description                                               | Passed | Total  |
|----------------|-----------------------------------------------------------|--------|--------|
| `sram_8bit_tb` | Load, hold, arbitrary pattern tests                       | 5      | 5      |
| `dff_tb`       | Edge capture, hold, toggle (behavioral + GL)              | 9      | 9      |
| `clb_top_tb`   | All 8 truth table states, combinational + sequential modes| 11     | 11     |
| **Total**      |                                                           | **25** | **25** |

---

## 🔗 Relation to Cadence Implementation

| Paper / Cadence (90nm)         | Verilog (this repo)                       |
|-------------------------------|-------------------------------------------|
| 6T SRAM array                 | `behavioral/sram_8bit.v` (RTL model)      |
| 8×1 MUX transistor-level      | `gate_level/mux8x1_gl.v` (AND/OR/NOT)    |
| 2×1 MUX transistor-level      | `gate_level/mux2x1_gl.v`                 |
| DFF master-slave (Static CMOS)| `gate_level/dff_gl.v` (NAND-based)       |
| Combinational mode             | `MODE=0` in `clb_top.v`                  |
| Sequential mode                | `MODE=1` in `clb_top.v`                  |
| Static CMOS logic style        | `gate_level/` folder                     |
| Behavioral reference           | `behavioral/` folder                     |
| Cadence Virtuoso files         | `Cadence Zip Library/` folder            |

---

## 🔮 Future Directions

1. **TGL and GDI Verilog models** — Extend gate-level implementation to transmission gate and GDI styles to complete the three-way comparison in simulation.
2. **Larger LUT configurations** — Scale to 4-input or 6-input LUTs (standard in modern FPGAs) using the same structural approach.
3. **Hybrid logic styles** — Investigate mixed TGL/CMOS designs at the Verilog level for power-delay optimization.
4. **FPGA synthesis** — Target the CLB design for synthesis on Xilinx/Intel FPGA platforms and compare post-synthesis resource utilization.
5. **System-level integration** — Connect multiple CLBs with routing fabric to form a small reconfigurable array.

---

## 👨‍💻 Authors

**Md. Mahidul Haque**, Md. Mahfuzur Rashid, Saquib Farhan, Md Tawfiq Amin

Department of Electrical, Electronic and Communication Engineering
**Military Institute of Science and Technology (MIST)**, Dhaka, Bangladesh
