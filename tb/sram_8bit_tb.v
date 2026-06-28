`timescale 1ns/1ps
// ============================================================
// Testbench: sram_8bit
// Verifies LOAD writes data and holds it correctly
// ============================================================
module sram_8bit_tb;
    reg        CLK, LOAD;
    reg  [7:0] D;
    wire [7:0] Q;

    integer pass_count = 0, fail_count = 0;

    sram_8bit uut (.CLK(CLK), .LOAD(LOAD), .D(D), .Q(Q));

    always #5 CLK = ~CLK;   // 10ns clock period

    task check_q;
        input [7:0] expected;
        input [31:0] test_num;
        begin
            #1; // small settle time
            if (Q === expected) begin
                $display("PASS | Test %0d | Q=%b (expected %b)", test_num, Q, expected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | Test %0d | Q=%b (expected %b)", test_num, Q, expected);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("sram_8bit.vcd");
        $dumpvars(0, sram_8bit_tb);
        CLK = 0; LOAD = 0; D = 8'h00;

        $display("========================================");
        $display("        SRAM 8-bit Testbench           ");
        $display("========================================");

        // Test 1: Load Y=AB+C truth table (from paper Table I)
        // 8'b11101010 = states 7,6,5,4,3,2,1,0 = 1,1,1,0,1,0,1,0
        // Y values: state0=0,state1=1,state2=0,state3=1,
        //           state4=0,state5=1,state6=1,state7=1
        // D[0]=state0=0, D[1]=state1=1 ... D[7]=state7=1
        $display("\n[Test 1] Load Y=AB+C truth table: 8'b11101010");
        @(negedge CLK); LOAD = 1; D = 8'b11101010;
        @(posedge CLK); #1;
        check_q(8'b11101010, 1);

        // Test 2: Hold — LOAD=0, change D, Q should not change
        $display("\n[Test 2] LOAD=0: Q must hold previous value");
        @(negedge CLK); LOAD = 0; D = 8'hFF;
        @(posedge CLK);
        check_q(8'b11101010, 2);

        // Test 3: Load all zeros
        $display("\n[Test 3] Load 8'h00");
        @(negedge CLK); LOAD = 1; D = 8'h00;
        @(posedge CLK); #1;
        check_q(8'h00, 3);

        // Test 4: Load all ones
        $display("\n[Test 4] Load 8'hFF");
        @(negedge CLK); LOAD = 1; D = 8'hFF;
        @(posedge CLK); #1;
        check_q(8'hFF, 4);

        // Test 5: Load arbitrary pattern
        $display("\n[Test 5] Load 8'hA5");
        @(negedge CLK); LOAD = 1; D = 8'hA5;
        @(posedge CLK); #1;
        check_q(8'hA5, 5);

        $display("\n========================================");
        $display("  PASSED: %0d / FAILED: %0d / TOTAL: %0d",
                  pass_count, fail_count, pass_count+fail_count);
        $display("========================================");
        $finish;
    end
endmodule
