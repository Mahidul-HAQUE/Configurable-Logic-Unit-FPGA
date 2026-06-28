`timescale 1ns/1ps
// ============================================================
// Positive Edge Triggered D Flip-Flop — Gate Level
// Master-slave configuration using NAND gates
// Matches Static CMOS DFF topology from paper
// ============================================================
module dff_gl (
    input  wire CLK,
    input  wire D,
    output wire Q,
    output wire Qn
);
    wire clk_n;
    wire m1, m2, m3, m4;   // master latch internal nodes
    wire s1, s2, s3, s4;   // slave latch internal nodes

    not G_CLKN (clk_n, CLK);

    // Master latch (transparent when CLK=0)
    nand G_M1 (m1, D,   clk_n);
    nand G_M2 (m2, m1,  clk_n);
    nand G_M3 (m3, m1,  m4);
    nand G_M4 (m4, m2,  m3);

    // Slave latch (transparent when CLK=1)
    nand G_S1 (s1, m3,  CLK);
    nand G_S2 (s2, m4,  CLK);
    nand G_S3 (s3, s1,  s4);
    nand G_S4 (s4, s2,  s3);

    assign Q  = s3;
    assign Qn = s4;
endmodule
