//-----------------------------------------------------
// File Name   : controller.sv
// Function    : FSM controller for the FFT butterfly handshake
//               protocol. Sequences input latching and output
//               display using Mealy outputs.
// Version     : 1.0
// Author      : Hamza Alhalabi, alhalabihamzawrk@gmail.com
// Date        : 12 Feb 2026
//-----------------------------------------------------
module controller (
    input  logic clk,
    input  logic nreset,       // active-low master reset (SW9)
    input  logic ReadyIn,      // handshake input (SW8)
    output logic LW, LB, LA,   // register latch enables
    output logic TwdSel,       // multiplier input: 0 = Re(W), 1 = Im(W)
    output logic AluOp,        // ALU operation:    0 = add,    1 = subtract
    output logic AluSel,       // ALU input:        0 = Re(A),  1 = zero
    output logic ResultSel     // LED output:       0 = ALU,    1 = multiplier
);

    // State names follow the pseudocode step labels (a, b, cd, e, ...)
    typedef enum logic [3:0] {
        A, B, CD, E, FG, H, JK, LM, NO, PQ
    } state_t;

    state_t pState, nState;

    // Sequential: state register with async reset
    always_ff @(posedge clk, negedge nreset) begin
        if (~nreset) pState <= A;
        else         pState <= nState;
    end

    // ---------- Next-state logic ----------
    // Each state waits for ReadyIn to toggle, following the
    // handshake sequence: wait low, wait high, latch/display, repeat.
    always_comb begin
        nState = pState;
        unique case (pState)
            A:  nState = ReadyIn  ? A  : B;   // wait for ReadyIn = 0
            B:  nState = ReadyIn  ? CD : B;   // wait for ReadyIn = 1
            CD: nState = ReadyIn  ? CD : E;   // wait for ReadyIn = 0
            E:  nState = ReadyIn  ? FG : E;   // wait for ReadyIn = 1
            FG: nState = ReadyIn  ? FG : H;   // wait for ReadyIn = 0
            H:  nState = ReadyIn  ? JK : H;   // wait for ReadyIn = 1
            JK: nState = ReadyIn  ? JK : LM;  // wait for ReadyIn = 0
            LM: nState = ReadyIn  ? NO : LM;  // wait for ReadyIn = 1
            NO: nState = ReadyIn  ? NO : PQ;  // wait for ReadyIn = 0
            PQ: nState = ~ReadyIn ? PQ : A;   // wait for ReadyIn = 1, loop back
            default: ;
        endcase
    end

    // ---------- Mealy output logic ----------
    // Outputs are asserted based on current state AND ReadyIn so that
    // register enables fire on the same clock edge as the state transition.
    // This avoids extra states that a Moore machine would need.
    //
    // Datapath control steers the combinational result onto the LEDs:
    //   Re(Y) = Re(A) + Re(W)*Re(B)   (default path, no flags needed)
    //   Im(Y) = Im(W)*Re(B)            (TwdSel=1, ResultSel=1)
    //   Re(Z) = Re(A) - Re(W)*Re(B)    (AluOp=1)
    //   Im(Z) = 0 - Im(W)*Re(B)        (AluOp=1, TwdSel=1, AluSel=1)
    always_comb begin
        // Safe defaults, all flags low
        LW        = 1'b0;
        LB        = 1'b0;
        LA        = 1'b0;
        TwdSel    = 1'b0;
        AluOp     = 1'b0;
        AluSel    = 1'b0;
        ResultSel = 1'b0;

        unique case (pState)
            A: ;  // idle after reset, no action

            // Latch twiddle factor on the rising edge of ReadyIn
            B: if (ReadyIn) LW = 1'b1;

            // Keep latching while ReadyIn is held high
            CD: if (ReadyIn) LW = 1'b1;

            // Latch Re(B) on the rising edge of ReadyIn
            E: if (ReadyIn) LB = 1'b1;

            // Keep latching while ReadyIn is held high
            FG: if (ReadyIn) LB = 1'b1;

            // Latch Re(A) on the rising edge of ReadyIn
            H: if (ReadyIn) LA = 1'b1;

            // Display Re(Y) while ReadyIn = 1 (default path, no flags)
            // On falling edge, switch muxes to show Im(Y) for state LM
            JK: if (~ReadyIn) begin
                TwdSel    = 1'b1;  // select Im(W) into multiplier
                ResultSel = 1'b1;  // route multiplier output to LEDs
            end

            // Display Im(Y) while ReadyIn = 0 (mux settings from JK exit carry over)
            // On rising edge, switch to Re(Z) for state NO
            LM: if (ReadyIn) begin
                AluOp = 1'b1;      // ALU subtracts: Re(A) - Re(W)*Re(B)
            end else begin
                TwdSel    = 1'b1;  // keep Im(W) selected
                ResultSel = 1'b1;  // keep multiplier output on LEDs
            end

            // Display Re(Z) while ReadyIn = 1
            // On falling edge, switch to Im(Z) for state PQ
            NO: if (ReadyIn) begin
                AluOp = 1'b1;      // keep subtraction
            end else begin
                AluOp  = 1'b1;     // ALU subtracts
                TwdSel = 1'b1;     // select Im(W)
                AluSel = 1'b1;     // zero into ALU: 0 - Im(W)*Re(B)
            end

            // Display Im(Z) while ReadyIn = 0
            PQ: if (~ReadyIn) begin
                AluOp  = 1'b1;
                TwdSel = 1'b1;
                AluSel = 1'b1;
            end

            default: ;
        endcase
    end

endmodule
