`timescale 1ns/1ps
// ============================================================
// 8x1 Multiplexer — Gate Level (3-layer mux2x1_gl tree)
// S[2]=A, S[1]=B, S[0]=C
// ============================================================
module mux8x1_gl (
    input  wire [7:0] D,
    input  wire [2:0] S,
    output wire       Y
);
    wire w01, w23, w45, w67;
    wire w0123, w4567;

    // Layer 1 — C selects
    mux2x1_gl M0 (.a(D[0]), .b(D[1]), .sel(S[0]), .y(w01));
    mux2x1_gl M1 (.a(D[2]), .b(D[3]), .sel(S[0]), .y(w23));
    mux2x1_gl M2 (.a(D[4]), .b(D[5]), .sel(S[0]), .y(w45));
    mux2x1_gl M3 (.a(D[6]), .b(D[7]), .sel(S[0]), .y(w67));

    // Layer 2 — B selects
    mux2x1_gl M4 (.a(w01),  .b(w23),  .sel(S[1]), .y(w0123));
    mux2x1_gl M5 (.a(w45),  .b(w67),  .sel(S[1]), .y(w4567));

    // Layer 3 — A selects
    mux2x1_gl M6 (.a(w0123),.b(w4567),.sel(S[2]), .y(Y));
endmodule
