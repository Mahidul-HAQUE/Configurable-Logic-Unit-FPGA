`timescale 1ns/1ps
// ============================================================
// Top-Level CLB Testbench
// Tests both clb_top (behavioral) and clb_top_gl (gate-level)
// Verifies Y = AB + C (Table I from paper)
// Tests combinational mode and sequential mode
// ============================================================
module clb_top_tb;

    reg        CLK, LOAD, A, B, C, MODE;
    reg  [7:0] D;
    wire       OUT_beh;     // behavioral CLB output
    wire       OUT_gl;      // gate-level CLB output

    integer pass_count = 0, fail_count = 0;

    // Y=AB+C truth table stored in SRAM
    // D[0]=0,D[1]=1,D[2]=0,D[3]=1,D[4]=0,D[5]=1,D[6]=1,D[7]=1
    // = 8'b11101010
    localparam LUT_PROG = 8'b11101010;

    clb_top    CLB_BEH (.CLK(CLK),.LOAD(LOAD),.D(D),.A(A),.B(B),.C(C),.MODE(MODE),.OUT(OUT_beh));
    clb_top_gl CLB_GL  (.CLK(CLK),.LOAD(LOAD),.D(D),.A(A),.B(B),.C(C),.MODE(MODE),.OUT(OUT_gl));

    always #5 CLK = ~CLK;

    task check;
        input exp;
        input [2:0] abc;
        input [8*12:1] mode_str;
        begin
            #2;
            if (OUT_beh === exp && OUT_gl === exp) begin
                $display("PASS | A=%b B=%b C=%b | Y=%b | %s",
                          abc[2], abc[1], abc[0], OUT_beh, mode_str);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | A=%b B=%b C=%b | beh=%b gl=%b (exp=%b) | %s",
                          abc[2], abc[1], abc[0], OUT_beh, OUT_gl, exp, mode_str);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("clb_top.vcd");
        $dumpvars(0, clb_top_tb);
        CLK = 0; LOAD = 0; MODE = 0;
        A = 0; B = 0; C = 0; D = 8'h00;

        $display("========================================================");
        $display("        CLB Top-Level Testbench (Beh + GL)             ");
        $display("   Function: Y = AB + C   (Paper Table I, ICCIT 2025)  ");
        $display("========================================================");

        // -------------------------------------------------------
        // PHASE 1: Program the SRAM with Y=AB+C truth table
        // -------------------------------------------------------
        $display("\n[Phase 1] Programming SRAM with Y=AB+C = 8'b11101010");
        @(negedge CLK); LOAD = 1; D = LUT_PROG;
        @(posedge CLK); #1;
        @(negedge CLK); LOAD = 0;
        $display("SRAM programmed.");

        // -------------------------------------------------------
        // PHASE 2: Combinational mode (MODE=0) — verify all 8 states
        // -------------------------------------------------------
        $display("\n[Phase 2] Combinational Mode (MODE=0)");
        $display("  State | A B C | Y=AB+C | Result");
        MODE = 0;

        // State 0: A=0 B=0 C=0 -> Y=0
        @(negedge CLK); A=0; B=0; C=0; check(0, 3'b000, "Comb State0");
        // State 1: A=0 B=0 C=1 -> Y=1
        @(negedge CLK); A=0; B=0; C=1; check(1, 3'b001, "Comb State1");
        // State 2: A=0 B=1 C=0 -> Y=0
        @(negedge CLK); A=0; B=1; C=0; check(0, 3'b010, "Comb State2");
        // State 3: A=0 B=1 C=1 -> Y=1
        @(negedge CLK); A=0; B=1; C=1; check(1, 3'b011, "Comb State3");
        // State 4: A=1 B=0 C=0 -> Y=0
        @(negedge CLK); A=1; B=0; C=0; check(0, 3'b100, "Comb State4");
        // State 5: A=1 B=0 C=1 -> Y=1
        @(negedge CLK); A=1; B=0; C=1; check(1, 3'b101, "Comb State5");
        // State 6: A=1 B=1 C=0 -> Y=1  (AB=1, C=0 -> AB+C=1)
        @(negedge CLK); A=1; B=1; C=0; check(1, 3'b110, "Comb State6");
        // State 7: A=1 B=1 C=1 -> Y=1
        @(negedge CLK); A=1; B=1; C=1; check(1, 3'b111, "Comb State7");

        // -------------------------------------------------------
        // PHASE 3: Sequential mode (MODE=1) — output clocked by DFF
        // -------------------------------------------------------
        $display("\n[Phase 3] Sequential Mode (MODE=1) — output registered on posedge CLK");
        MODE = 1;

        // Set inputs, wait for posedge, then check
        @(negedge CLK); A=1; B=1; C=0;  // AB+C=1
        @(posedge CLK); #2;
        if (OUT_beh === 1 && OUT_gl === 1) begin
            $display("PASS | A=1 B=1 C=0 | Y=1 registered | Seq Mode");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | A=1 B=1 C=0 | beh=%b gl=%b (exp=1) | Seq Mode", OUT_beh, OUT_gl);
            fail_count = fail_count + 1;
        end

        @(negedge CLK); A=0; B=0; C=0;  // AB+C=0
        @(posedge CLK); #2;
        if (OUT_beh === 0 && OUT_gl === 0) begin
            $display("PASS | A=0 B=0 C=0 | Y=0 registered | Seq Mode");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | A=0 B=0 C=0 | beh=%b gl=%b (exp=0) | Seq Mode", OUT_beh, OUT_gl);
            fail_count = fail_count + 1;
        end

        @(negedge CLK); A=1; B=0; C=1;  // AB+C=1
        @(posedge CLK); #2;
        if (OUT_beh === 1 && OUT_gl === 1) begin
            $display("PASS | A=1 B=0 C=1 | Y=1 registered | Seq Mode");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL | A=1 B=0 C=1 | beh=%b gl=%b (exp=1) | Seq Mode", OUT_beh, OUT_gl);
            fail_count = fail_count + 1;
        end

        $display("\n========================================================");
        $display("  PASSED: %0d / FAILED: %0d / TOTAL: %0d",
                  pass_count, fail_count, pass_count+fail_count);
        $display("========================================================");
        $finish;
    end
endmodule
