`timescale 1ns/1ps
// ============================================================
// Positive Edge Triggered D Flip-Flop — Behavioral
// ============================================================
module dff (
    input  wire CLK,
    input  wire D,
    output reg  Q
);
    always @(posedge CLK)
        Q <= D;
endmodule
