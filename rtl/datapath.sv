//-----------------------------------------------------
// File Name   : datapath.sv
// Function    : Combinational datapath for the FFT butterfly.
//               Contains input registers, twiddle factor LUT,
//               multiplier, ALU, and output muxes.
// Version     : 1.0
// Author      : Hamza Alhalabi, alhalabihamzawrk@gmail.com
// Date        : 12 Feb 2026
//-----------------------------------------------------
module datapath (
    input  logic clk,
    input  logic nreset,
    input  logic [7:0] SW70,           // data switches SW[7:0]
    input  logic LW, LB, LA,           // register latch enables from controller
    input  logic TwdSel,               // multiplier input: 0 = Re(W), 1 = Im(W)
    input  logic AluOp,                // ALU operation:    0 = add,    1 = subtract
    input  logic AluSel,               // ALU input:        0 = Re(A),  1 = zero
    input  logic ResultSel,            // LED output:       0 = ALU,    1 = multiplier
    output logic [7:0] LEDs
);

    // --- Input registers ---
    logic [7:0] Re_W, Im_W;   // twiddle factor components (Q1.7 fixed-point)
    logic [7:0] Re_B;         // real part of input B (8-bit signed integer)
    logic [7:0] Re_A;         // real part of input A (8-bit signed integer)

    // --- Internal signals ---
    logic [7:0] a_MUL;        // selected twiddle component into multiplier
    logic [7:0] product;      // integer part of Re(B) * selected twiddle
    logic [7:0] a_ALU;        // selected first operand into ALU
    logic [7:0] sum_ALU;      // ALU result

    // --- Twiddle factor LUT ---
    // 3-bit index selects W8^k for k = 0..7.
    // Each entry is {Im(W), Re(W)} in Q1.7 signed fixed-point,
    // where +1 is approximated as 0x7F and -1 as 0x80.
    //
    //   k=0: W= 1 + j0          -> {00, 7F}
    //   k=1: W= 0.707 - j0.707  -> {A5, 5B}
    //   k=2: W= 0 - j1          -> {80, 00}
    //   k=3: W=-0.707 - j0.707  -> {A5, A5}
    //   k=4: W=-1 + j0          -> {00, 80}
    //   k=5: W=-0.707 + j0.707  -> {5B, A5}
    //   k=6: W= 0 + j1          -> {7F, 00}
    //   k=7: W= 0.707 + j0.707  -> {5B, 5B}
    logic [15:0] lut;
    logic [7:0]  rew, imw;

    always_comb begin
        case (SW70[2:0])
            3'd0:    lut = 16'h007F;
            3'd1:    lut = 16'hA55B;
            3'd2:    lut = 16'h8000;
            3'd3:    lut = 16'hA5A5;
            3'd4:    lut = 16'h0080;
            3'd5:    lut = 16'h5BA5;
            3'd6:    lut = 16'h7F00;
            3'd7:    lut = 16'h5B5B;
            default: lut = 16'h0000;
        endcase
    end

    assign rew = lut[7:0];    // lower byte is Re(W)
    assign imw = lut[15:8];   // upper byte is Im(W)

    // --- Twiddle factor register ---
    // Latches both components when the controller asserts LW.
    always_ff @(posedge clk) begin
        if (~nreset) begin
            Re_W <= '0;
            Im_W <= '0;
        end else if (LW) begin
            Re_W <= rew;
            Im_W <= imw;
        end
    end

    // --- Re(B) register ---
    always_ff @(posedge clk) begin
        if (~nreset) Re_B <= '0;
        else if (LB) Re_B <= SW70;
    end

    // --- Re(A) register ---
    always_ff @(posedge clk) begin
        if (~nreset) Re_A <= '0;
        else if (LA) Re_A <= SW70;
    end

    // --- Twiddle mux ---
    // Selects which twiddle component feeds the multiplier.
    assign a_MUL = TwdSel ? Im_W : Re_W;

    // --- Multiplier ---
    // Signed 8x8 producing a 16-bit result. The module extracts
    // bits [14:7] internally, returning the 8-bit integer part.
    mul mul0 (
        .a(a_MUL),
        .b(Re_B),
        .product(product)
    );

    // --- ALU input mux ---
    // Selects Re(A) or zero as the first ALU operand.
    // Zero is used for Im(Z) = 0 - Im(W)*Re(B).
    assign a_ALU = AluSel ? 8'b0 : Re_A;

    // --- ALU ---
    // Performs a + b (AluOp=0) or a - b (AluOp=1).
    alu alu0 (
        .AluOp(AluOp),
        .a(a_ALU),
        .b(product),
        .sum(sum_ALU)
    );

    // --- Result mux ---
    // Routes either the ALU output or the raw multiplier output to the LEDs.
    // Multiplier output is used directly for Im(Y) and Im(Z) display states.
    assign LEDs = ResultSel ? product : sum_ALU;

endmodule
