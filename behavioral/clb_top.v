`timescale 1ns/1ps
// ============================================================
// Configurable Logic Block (CLB) — Behavioral Top Level
// Matches architecture from paper (ICCIT 2025)
//
// Implements Y = AB + C via SRAM LUT
//
// Truth Table (Table I from paper):
//   State | A B C | Y
//     0   | 0 0 0 | 0
//     1   | 0 0 1 | 1
//     2   | 0 1 0 | 0
//     3   | 0 1 1 | 1
//     4   | 1 0 0 | 0
//     5   | 1 0 1 | 1
//     6   | 1 1 0 | 1
//     7   | 1 1 1 | 1
//
// LOAD=1 : write config bits into SRAM (config mode)
// LOAD=0 : normal operation
// MODE=0 : combinational output
// MODE=1 : sequential output (through DFF)
// ============================================================
module clb_top (
    input  wire       CLK,
    input  wire       LOAD,
    input  wire [7:0] D,
    input  wire       A, B, C,
    input  wire       MODE,
    output wire       OUT
);
    wire [7:0] lut_q;
    wire       mux_out;
    wire       dff_out;

    // Stage 1: SRAM-based LUT (configuration memory)
    sram_8bit SRAM (
        .CLK  (CLK),
        .LOAD (LOAD),
        .D    (D),
        .Q    (lut_q)
    );

    // Stage 2: 8x1 MUX — address lines A=S[2], B=S[1], C=S[0]
    mux8x1 MUX8 (
        .D ({lut_q[7],lut_q[6],lut_q[5],lut_q[4],
             lut_q[3],lut_q[2],lut_q[1],lut_q[0]}),
        .S ({A, B, C}),
        .Y (mux_out)
    );

    // Stage 3: DFF for sequential mode
    dff DFF0 (
        .CLK (CLK),
        .D   (mux_out),
        .Q   (dff_out)
    );

    // Stage 4: 2x1 MUX — MODE=0: combinational, MODE=1: sequential
    mux2x1 MODE_MUX (
        .a   (mux_out),
        .b   (dff_out),
        .sel (MODE),
        .y   (OUT)
    );

endmodule
