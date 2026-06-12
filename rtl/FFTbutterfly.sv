//-----------------------------------------------------
// File Name   : FFTbutterfly.sv
// Function    : FFT Butterfly top level module
// Version     : 1.0
// Author      : Hamza Alhalabi, alhalabihamzawrk@gmail.com
// Date        : 12 Feb 2026
//-----------------------------------------------------
module FFTbutterfly (
    input  logic       clk,
    input  logic [9:0] SW,        // SW[9] = active-low reset
                                  // SW[8] = ReadyIn handshake
                                  // SW[7:0] = data input
    output logic [7:0] LED        // output display
);

    wire LW, LA, LB, TwdSel, AluOp, AluSel, ResultSel;
    //assign LED[8]=LW; //used for extra debugging light

    //uncommented for synthesis to use clock divider
    // logic clk;
    // counter c (
    //      .fastclk(fastclk),
    //      .clk(clk)
    //  );

    controller ctrl (
        .clk(clk),
        .nreset(SW[9]),
        .ReadyIn(SW[8]),
        .LW(LW),
        .LB(LB),
        .LA(LA),
        .TwdSel(TwdSel),
        .AluOp(AluOp),
        .AluSel(AluSel),
        .ResultSel(ResultSel)
    );

    datapath datapath0 (
    .clk(clk),
    .nreset(SW[9]),
    .SW70(SW[7:0]),
    .LW(LW),
    .LB(LB),
    .LA(LA),
    .TwdSel(TwdSel),
    .AluOp(AluOp),
    .AluSel(AluSel),
    .ResultSel(ResultSel),
    .LEDs(LED)
    );

endmodule
