`timescale 1ns/1ps
// ============================================================
// 2x1 Multiplexer — Behavioral
// sel=0 -> y=a,  sel=1 -> y=b
// ============================================================
module mux2x1 (
    input  wire a, b, sel,
    output wire y
);
    assign y = sel ? b : a;
endmodule
