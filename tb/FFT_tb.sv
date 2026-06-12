//-----------------------------------------------------
// File Name   : FFT_tb.sv
// Function    : Top level module testbench
// Version     : 1.0
// Author      :  Hamza Alhalabi, ha2n22@soton.ac.uk
// Date        : 14 Feb 2026
//-----------------------------------------------------

module FFT_tb ;
    logic clk;
    logic [9:0] SW;
    logic [7:0] LED;

    FFTbutterfly dut (
        .clk(clk),
        .SW(SW),
        .LED(LED)
    );

    // clock
    initial begin
        clk = 0;
        forever #5ns clk = ~clk;
    end

    task automatic sw8_up();
        @(posedge clk)
        SW[8]=1;
    endtask

    task automatic sw8_down();
        @(posedge clk)
        SW[8]=0;
    endtask

    //Test Vectors
    logic signed [7:0] test_a [0:99] = '{8'hC7, 8'h48, 8'h01, 8'hC2, 8'h4E, 8'h96, 8'hC3, 8'h9B, 8'h05, 8'hB8, 8'h5B, 8'h9B, 8'h07, 8'hAE, 8'hD7, 8'h47, 8'hF7, 8'h20, 8'h09, 8'h06, 8'h77, 8'hD5, 8'h08, 8'hA3, 8'hB2, 8'h3C, 8'hB0, 8'hCF, 8'hD4, 8'hE6, 8'h1D, 8'h9B, 8'h8C, 8'h09, 8'h34, 8'h02, 8'h91, 8'h00, 8'h1A, 8'h5D, 8'h19, 8'hC6, 8'hBB, 8'hED, 8'h63, 8'h7E, 8'h44, 8'h55, 8'h2F, 8'hEE, 8'hA9, 8'h1C, 8'h41, 8'hFE, 8'h21, 8'h2F, 8'hE2, 8'h3E, 8'hA5, 8'h5E, 8'h5F, 8'h5E, 8'h74, 8'hDB, 8'h88, 8'hB4, 8'h91, 8'hBE, 8'h31, 8'hB9, 8'h44, 8'h83, 8'hB5, 8'h8C, 8'h95, 8'h8A, 8'h6E, 8'h6E, 8'hD4, 8'h96, 8'h3E, 8'h44, 8'h14, 8'h4F, 8'h09, 8'h18, 8'hAB, 8'hC0, 8'h38, 8'h98, 8'hB4, 8'hD9, 8'h38, 8'h96, 8'h8D, 8'hEE, 8'hFA, 8'h86, 8'h59, 8'h37};
    logic signed [7:0] test_b [0:99] = '{8'h83, 8'hFE, 8'hF8, 8'h44, 8'hEB, 8'hFD, 8'hF0, 8'hF6, 8'hE9, 8'hC6, 8'hCC, 8'hB4, 8'hA7, 8'hD5, 8'hE1, 8'h75, 8'hC2, 8'hB8, 8'h35, 8'h81, 8'hCD, 8'h93, 8'h07, 8'hF7, 8'hCF, 8'h9D, 8'h45, 8'h46, 8'hC0, 8'hA0, 8'h13, 8'hB3, 8'h10, 8'h7D, 8'h4B, 8'hD9, 8'h21, 8'hA6, 8'hF8, 8'h24, 8'hC7, 8'hA1, 8'hDA, 8'h56, 8'hCF, 8'h8C, 8'hE5, 8'h03, 8'h76, 8'h93, 8'hC1, 8'h14, 8'hED, 8'h7C, 8'h4B, 8'h47, 8'hDC, 8'h1C, 8'h13, 8'hAD, 8'hDB, 8'hDF, 8'hDC, 8'h2B, 8'hFA, 8'h43, 8'h1F, 8'hF9, 8'h3B, 8'h5D, 8'h89, 8'h26, 8'h13, 8'h54, 8'h78, 8'h13, 8'hED, 8'hE1, 8'h82, 8'hF3, 8'hA7, 8'hD5, 8'hEE, 8'h52, 8'h12, 8'h93, 8'h39, 8'h8B, 8'h76, 8'h92, 8'h92, 8'h4F, 8'h0C, 8'hDC, 8'h5E, 8'h25, 8'h82, 8'h91, 8'hB5, 8'hE5};
    logic signed [7:0] test_w [0:99] = '{8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h00, 8'h01, 8'h02, 8'h03};

    logic signed [7:0] exp_rey [0:99] = '{8'h4A, 8'h46, 8'h01, 8'h91, 8'h63, 8'h98, 8'hC3, 8'h93, 8'hEE, 8'h8E, 8'h5B, 8'hD1, 8'h60, 8'hCC, 8'hD7, 8'h9A, 8'hB9, 8'hEC, 8'h09, 8'h60, 8'hAA, 8'h22, 8'h08, 8'h9C, 8'h81, 8'hF5, 8'hB0, 8'h9D, 8'h14, 8'h2A, 8'h1D, 8'h64, 8'h9B, 8'h61, 8'h34, 8'h1D, 8'h70, 8'h3F, 8'h1A, 8'h76, 8'hE0, 8'h82, 8'hBB, 8'hAF, 8'h94, 8'hD0, 8'h44, 8'h57, 8'hA4, 8'hA0, 8'hA9, 8'h0D, 8'h54, 8'hA5, 8'h21, 8'h61, 8'hBE, 8'h51, 8'hA5, 8'h99, 8'h84, 8'h75, 8'h74, 8'hF9, 8'h82, 8'hE3, 8'h91, 8'hC2, 8'hF6, 8'h76, 8'h44, 8'h9E, 8'hC7, 8'hC7, 8'h95, 8'h7C, 8'h81, 8'h84, 8'hD4, 8'h8C, 8'hE5, 8'h25, 8'h14, 8'h14, 8'hF7, 8'h65, 8'hAB, 8'h6C, 8'hAD, 8'h49, 8'hB4, 8'hA0, 8'h2C, 8'hAF, 8'h8D, 8'h08, 8'h7C, 8'h37, 8'h59, 8'h4A};
    logic signed [7:0] exp_imy [0:99] = '{8'h00, 8'h01, 8'h08, 8'hCF, 8'h00, 8'hFD, 8'hF0, 8'hF8, 8'h00, 8'h29, 8'h34, 8'h36, 8'h00, 8'hE1, 8'hE1, 8'h53, 8'h00, 8'h33, 8'hCB, 8'h5A, 8'h00, 8'hB2, 8'h06, 8'hF9, 8'h00, 8'h46, 8'hBB, 8'hCE, 8'h00, 8'hBB, 8'h12, 8'hC9, 8'h00, 8'hA7, 8'hB5, 8'h1B, 8'h00, 8'hC0, 8'hF8, 8'h19, 8'h00, 8'h43, 8'h26, 8'hC2, 8'h00, 8'hAD, 8'hE5, 8'h02, 8'h00, 8'h4D, 8'h3F, 8'hF1, 8'h00, 8'h58, 8'h4A, 8'h32, 8'h00, 8'hEC, 8'hED, 8'h3B, 8'h00, 8'hE8, 8'hDC, 8'h1E, 8'h00, 8'hD0, 8'hE1, 8'h04, 8'h00, 8'h42, 8'h89, 8'h1B, 8'h00, 8'hC4, 8'h88, 8'hF2, 8'h00, 8'hE9, 8'h82, 8'hF6, 8'h00, 8'h1E, 8'h12, 8'hC5, 8'h00, 8'hB2, 8'h38, 8'hAC, 8'h00, 8'h4E, 8'h6E, 8'hC7, 8'h00, 8'hE6, 8'h5D, 8'h1A, 8'h00, 8'h4E, 8'h4B, 8'h13};
    logic signed [7:0] exp_rez [0:99] = '{8'h44, 8'h4A, 8'h01, 8'hF3, 8'h39, 8'h94, 8'hC3, 8'hA3, 8'h1C, 8'hE2, 8'h5B, 8'h65, 8'hAE, 8'h90, 8'hD7, 8'hF4, 8'h35, 8'h54, 8'h09, 8'hAC, 8'h44, 8'h88, 8'h08, 8'hAA, 8'hE3, 8'h83, 8'hB0, 8'h01, 8'h94, 8'hA2, 8'h1D, 8'hD2, 8'h7D, 8'hB1, 8'h34, 8'hE7, 8'hB2, 8'hC1, 8'h1A, 8'h44, 8'h52, 8'h0A, 8'hBB, 8'h2B, 8'h32, 8'h2C, 8'h44, 8'h53, 8'hBA, 8'h3C, 8'hA9, 8'h2B, 8'h2E, 8'h57, 8'h21, 8'hFD, 8'h06, 8'h2B, 8'hA5, 8'h23, 8'h3A, 8'h47, 8'h74, 8'hBD, 8'h8E, 8'h85, 8'h91, 8'hBA, 8'h6C, 8'hFC, 8'h44, 8'h68, 8'hA3, 8'h51, 8'h95, 8'h98, 8'h5B, 8'h58, 8'hD4, 8'hA0, 8'h97, 8'h63, 8'h14, 8'h8A, 8'h1B, 8'hCB, 8'hAB, 8'h14, 8'hC3, 8'hE7, 8'hB4, 8'h12, 8'h44, 8'h7D, 8'h8D, 8'hD4, 8'h78, 8'hD5, 8'h59, 8'h24};
    logic signed [7:0] exp_imz [0:99] = '{8'h00, 8'hFF, 8'hF8, 8'h31, 8'h00, 8'h03, 8'h10, 8'h08, 8'h00, 8'hD7, 8'hCC, 8'hCA, 8'h00, 8'h1F, 8'h1F, 8'hAD, 8'h00, 8'hCD, 8'h35, 8'hA6, 8'h00, 8'h4E, 8'hFA, 8'h07, 8'h00, 8'hBA, 8'h45, 8'h32, 8'h00, 8'h45, 8'hEE, 8'h37, 8'h00, 8'h59, 8'h4B, 8'hE5, 8'h00, 8'h40, 8'h08, 8'hE7, 8'h00, 8'hBD, 8'hDA, 8'h3E, 8'h00, 8'h53, 8'h1B, 8'hFE, 8'h00, 8'hB3, 8'hC1, 8'h0F, 8'h00, 8'hA8, 8'hB6, 8'hCE, 8'h00, 8'h14, 8'h13, 8'hC5, 8'h00, 8'h18, 8'h24, 8'hE2, 8'h00, 8'h30, 8'h1F, 8'hFC, 8'h00, 8'hBE, 8'h77, 8'hE5, 8'h00, 8'h3C, 8'h78, 8'h0E, 8'h00, 8'h17, 8'h7E, 8'h0A, 8'h00, 8'hE2, 8'hEE, 8'h3B, 8'h00, 8'h4E, 8'hC8, 8'h54, 8'h00, 8'hB2, 8'h92, 8'h39, 8'h00, 8'h1A, 8'hA3, 8'hE6, 8'h00, 8'hB2, 8'hB5, 8'hED};

    int pass =0;
    int fail =0;
    int NUM_TESTS = 100; //number of test vectors

    task automatic run_single_cycle( input logic [7:0] twiddle,
                              input logic [7:0] Re_B,
                              input logic [7:0] Re_A);
        sw8_down();
        SW[7:0]= twiddle;//FSM in B
        sw8_up(); //FSM in CD
        sw8_down();//FSM in E
        SW[7:0]= Re_B;//FSM in E still
        sw8_up();//FSM in FG
        sw8_down();//FSM in H
        SW[7:0]= Re_A;//FSM in H still
        sw8_up();//FSM in JK
        @(posedge clk);//FSM in JK
        sw8_down();
        $display("ReY = %d, %b",$signed(LED), $signed(LED));
        sw8_up();
        $display("ImY = %d, %b",$signed(LED), $signed(LED));
        sw8_down();
        $display("ReZ = %d, %b",$signed(LED), $signed(LED));
        sw8_up();
        $display("ImZ = %d, %b",$signed(LED), $signed(LED));
        $display("Single cycle completed");
    endtask

    task automatic run_cycle(input logic [7:0] twiddle, input logic [7:0] Re_B,
                             input logic [7:0] Re_A, input logic signed [7:0] e_rey,
                             input logic signed [7:0] e_imy, input logic signed [7:0] e_rez,
                             input logic signed [7:0] e_imz);
        sw8_down();
        SW[7:0] = twiddle;
        sw8_up();
        sw8_down();
        SW[7:0] = Re_B;
        sw8_up();
        sw8_down();
        SW[7:0] = Re_A;
        sw8_up();
        @(posedge clk);
        // Re_y
        sw8_down();
        if (LED !== e_rey) begin
            $display("FAIL ReY: got %0d (0x%02X), expected %0d (0x%02X)", $signed(LED), LED, e_rey, e_rey);
            fail++;
        end else pass++;
        // Im_y
        sw8_up();
        if (LED !== e_imy) begin
            $display("FAIL ImY: got %0d (0x%02X), expected %0d (0x%02X)", $signed(LED), LED, e_imy, e_imy);
            fail++;
        end else pass++;
        // Re_z
        sw8_down();
        if (LED !== e_rez) begin
            $display("FAIL ReZ: got %0d (0x%02X), expected %0d (0x%02X)", $signed(LED), LED, e_rez, e_rez);
            fail++;
        end else pass++;
        // Im_Z
        sw8_up();
        if (LED !== e_imz) begin
            $display("FAIL ImZ: got %0d (0x%02X), expected %0d (0x%02X)", $signed(LED), LED, e_imz, e_imz);
            fail++;
        end else pass++;
    endtask

    initial begin
        SW = 10'd0; sw8_down();
        SW[9]=1; sw8_down();
        run_single_cycle(8'h1 ,8'h33 ,8'h77);//w, ReB, ReA
        @(posedge clk);
        SW = 10'd0; // reset
        sw8_down();
        SW[9]=1; sw8_down();
        for(int i =0 ; i< NUM_TESTS; i++) begin
            run_cycle(test_w[i], test_b[i], test_a[i],
                      exp_rey[i], exp_imy[i], exp_rez[i], exp_imz[i]);
        end
        $display("Test Vectors Running Results");
        $display("Passed Tests: %0d / %0d", pass, pass + fail);
        $display("Failed Tests: %0d / %0d", fail, pass + fail);
        $finish;
    end

endmodule
