# Verilog Toolchain Setup Guide

This project uses the following toolchain for simulation and waveform viewing.

## Required Tools

| Software       | Purpose                        | Verify Command                    |
|---------------|-------------------------------|-----------------------------------|
| Python 3       | Required runtime               | `python --version`                |
| VS Code        | Editor                         | `code --version`                  |
| TerosHDL      | VS Code extension (schematic)  | Installed in Extensions panel     |
| Icarus Verilog | Compile / simulate             | `iverilog -V`                     |
| VVP            | Simulation runtime             | `vvp -V`                          |
| GTKWave        | Waveform viewer                | `gtkwave --version`               |
| yowasp-yosys  | Yosys for TerosHDL             | `python -m yowasp_yosys --help`   |

---

## Installation Order

### 1. Python 3
Download from [python.org](https://www.python.org/downloads/)

### 2. Visual Studio Code
Download from [code.visualstudio.com](https://code.visualstudio.com/)

### 3. TerosHDL (VS Code Extension)
Open VS Code → Extensions → Search `TerosHDL` → Install

### 4. Icarus Verilog
- **Windows**: Download installer from [bleyer.org/icarus](http://bleyer.org/icarus/)
- **Linux**: `sudo apt install iverilog`
- **Mac**: `brew install icarus-verilog`

### 5. GTKWave
- **Windows**: Bundled with Icarus Verilog installer
- **Linux**: `sudo apt install gtkwave`
- **Mac**: `brew install gtkwave`

### 6. yowasp-yosys
```bash
pip install yowasp-yosys
```
Verify:
```bash
python -m yowasp_yosys --help
```

---

## Compile & Simulate

```bash
# Compile
iverilog -o simulation_output design.v testbench.v

# Run simulation
vvp simulation_output

# View waveforms
gtkwave wave.vcd
```

---

## Run This Project

```bash
# All tests at once
bash sim/run_all.sh

# Or individually — see README.md
```
