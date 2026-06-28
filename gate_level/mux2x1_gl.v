`timescale 1ns/1ps
// ============================================================
// 2x1 Multiplexer — Gate Level (AND/OR/NOT primitives)
// Matches Static CMOS implementation from paper
// y = a.sel' + b.sel
// ============================================================
module mux2x1_gl (
    input  wire a, b, sel,
    output wire y
);
    wire sel_n, w1, w2;
    not  G1 (sel_n, sel);
    and  G2 (w1, a, sel_n);
    and  G3 (w2, b, sel);
    or   G4 (y, w1, w2);
endmodule
