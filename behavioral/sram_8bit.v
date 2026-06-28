`timescale 1ns/1ps
// ============================================================
// 8-bit SRAM LUT — Behavioral model of 6T SRAM array
// LOAD=1 (posedge CLK) : writes D[7:0] into memory
// LOAD=0               : holds stored values on Q[7:0]
// ============================================================
module sram_8bit (
    input  wire       CLK,
    input  wire       LOAD,
    input  wire [7:0] D,
    output reg  [7:0] Q
);
    always @(posedge CLK) begin
        if (LOAD)
            Q <= D;
    end
endmodule
