`timescale 1ns/1ps
// ============================================================
// Testbench: dff (behavioral) + dff_gl (gate level)
// Verifies positive edge triggering and hold behavior
// ============================================================
module dff_tb;
    reg  CLK, D;
    wire Q_beh;     // behavioral DFF output
    wire Q_gl;      // gate-level DFF output
    wire Qn_gl;

    integer pass_count = 0, fail_count = 0;

    dff    DFF_BEH (.CLK(CLK), .D(D), .Q(Q_beh));
    dff_gl DFF_GL  (.CLK(CLK), .D(D), .Q(Q_gl), .Qn(Qn_gl));

    always #5 CLK = ~CLK;

    task check;
        input exp_beh, exp_gl;
        input [31:0] tnum;
        begin
            #1;
            if (Q_beh === exp_beh && Q_gl === exp_gl) begin
                $display("PASS | Test %0d | Q_beh=%b Q_gl=%b", tnum, Q_beh, Q_gl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | Test %0d | Q_beh=%b(exp %b) Q_gl=%b(exp %b)",
                          tnum, Q_beh, exp_beh, Q_gl, exp_gl);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("dff.vcd");
        $dumpvars(0, dff_tb);
        CLK = 0; D = 0;

        $display("========================================");
        $display("      DFF Testbench (Beh + GL)         ");
        $display("========================================");

        // Test 1: D=0 on first clock edge -> Q=0
        $display("\n[Test 1] D=0 -> after posedge, Q=0");
        @(negedge CLK); D = 0;
        @(posedge CLK);
        check(0, 0, 1);

        // Test 2: D=1 -> Q captures 1
        $display("\n[Test 2] D=1 -> after posedge, Q=1");
        @(negedge CLK); D = 1;
        @(posedge CLK);
        check(1, 1, 2);

        // Test 3: D=0 again -> Q back to 0
        $display("\n[Test 3] D=0 -> after posedge, Q=0");
        @(negedge CLK); D = 0;
        @(posedge CLK);
        check(0, 0, 3);

        // Test 4: Hold — D changes mid cycle, Q must not change until next edge
        $display("\n[Test 4] D=1 captured, then D toggles — Q holds until next edge");
        @(negedge CLK); D = 1;
        @(posedge CLK); #1;  // Q=1 captured
        D = 0;               // change D after edge
        #3;                  // wait but no new edge yet
        check(1, 1, 4);      // Q must still be 1

        // Test 5: Next edge captures the new D=0
        $display("\n[Test 5] Next posedge captures D=0");
        @(posedge CLK);
        check(0, 0, 5);

        // Test 6: Toggle D every cycle for 4 cycles
        $display("\n[Test 6] Toggle D every cycle");
        begin : toggle_loop
            integer i;
            for (i = 0; i < 4; i = i + 1) begin
                @(negedge CLK); D = i[0];
                @(posedge CLK);
                check(i[0], i[0], 6+i);
            end
        end

        $display("\n========================================");
        $display("  PASSED: %0d / FAILED: %0d / TOTAL: %0d",
                  pass_count, fail_count, pass_count+fail_count);
        $display("========================================");
        $finish;
    end
endmodule
