`timescale 1ns/1ps
// ============================================================
// CLB Top Level — Gate Level
// Uses gate-level mux2x1_gl, mux8x1_gl, dff_gl
// SRAM stays behavioral (no standard cell SRAM primitives)
// ============================================================
module clb_top_gl (
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
    wire       dff_qn;     // unused complement output

    // Stage 1: SRAM LUT (behavioral — no primitive SRAM cells in Verilog)
    sram_8bit SRAM (
        .CLK  (CLK),
        .LOAD (LOAD),
        .D    (D),
        .Q    (lut_q)
    );

    // Stage 2: 8x1 MUX — gate level
    mux8x1_gl MUX8 (
        .D (lut_q),
        .S ({A, B, C}),
        .Y (mux_out)
    );

    // Stage 3: DFF — gate level
    dff_gl DFF0 (
        .CLK (CLK),
        .D   (mux_out),
        .Q   (dff_out),
        .Qn  (dff_qn)
    );

    // Stage 4: 2x1 MODE MUX — gate level
    mux2x1_gl MODE_MUX (
        .a   (mux_out),
        .b   (dff_out),
        .sel (MODE),
        .y   (OUT)
    );

endmodule
