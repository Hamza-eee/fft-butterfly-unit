//-----------------------------------------------------
// File Name   : mul.sv
// Function    : Multiplier module
// Version     : 1.0
// Author      : Hamza Alhalabi, alhalabihamzawrk@gmail.com
// Date        : 12 Feb 2026
//-----------------------------------------------------
module mul (
    input logic signed [7:0] a , b,
    output logic signed [7:0] product
);
    logic signed [15:0] temp_product;
    always_comb begin : Multiply
        temp_product = a * b;
    end

    assign product = temp_product[14:7]; //truncating to display upper bits only
endmodule
