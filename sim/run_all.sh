#!/bin/bash
# ============================================================
# Run all CLB simulations
# Toolchain: Icarus Verilog + VVP (see docs/toolchain.md)
# ============================================================

set -e
cd "$(dirname "$0")/.."

echo "========================================"
echo "  CLB Verilog — Full Simulation Suite  "
echo "========================================"

# ---- SRAM Testbench ----
echo ""
echo "[1/3] Running SRAM testbench..."
iverilog -o sim/sram_sim \
  behavioral/sram_8bit.v \
  tb/sram_8bit_tb.v
vvp sim/sram_sim

# ---- DFF Testbench ----
echo ""
echo "[2/3] Running DFF testbench (behavioral + gate-level)..."
iverilog -o sim/dff_sim \
  behavioral/dff.v \
  gate_level/dff_gl.v \
  tb/dff_tb.v
vvp sim/dff_sim

# ---- CLB Top Testbench ----
echo ""
echo "[3/3] Running CLB top-level testbench..."
iverilog -o sim/clb_sim \
  behavioral/sram_8bit.v \
  behavioral/mux2x1.v \
  behavioral/mux8x1.v \
  behavioral/dff.v \
  behavioral/clb_top.v \
  gate_level/mux2x1_gl.v \
  gate_level/mux8x1_gl.v \
  gate_level/dff_gl.v \
  gate_level/clb_top_gl.v \
  tb/clb_top_tb.v
vvp sim/clb_sim

echo ""
echo "========================================"
echo "  All simulations complete."
echo "  VCD files in sim/ — open with GTKWave"
echo "========================================"
