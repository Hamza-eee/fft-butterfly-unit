//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU module
// Version     : 1.0
// Author      : Hamza Alhalabi, alhalabihamzawrk@gmail.com
// Date        : 12 Feb 2026
//-----------------------------------------------------
module alu (
    input logic AluOp,
    input logic signed [7:0] a , b,
    output logic signed [7:0] sum
);
    logic signed [7:0] temp_b;
    always_comb begin : AddSub
        if(AluOp) begin
            temp_b = ~b +1'b1;
        end
        else temp_b = b;

        sum = a + temp_b;
    end
endmodule
