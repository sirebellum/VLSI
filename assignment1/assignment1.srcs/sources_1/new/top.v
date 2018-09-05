`timescale 1ns / 1ps

module ripple_carry(A, B, CI, S, CO);
    input [3:0] A;   // Inputs
    input [3:0] B;
    input CI; // Carry in
    output [3:0] S; // Sum bit
    output CO;   // Carry bit
    
    wire C0, C1, C2; // Sum1, Carry1, Carry2
    
    full_adder Adder1(A[0], B[0], CI, S[0], C0);
    full_adder Adder2(A[1], B[1], C0, S[1], C1);
    full_adder Adder3(A[2], B[2], C1, S[2], C2);
    full_adder Adder4(A[3], B[3], C2, S[3], CO);
    
endmodule

module full_adder(A, B, CI, S, CO);
    input A;   // Inputs
    input B;
    input CI; // Carry in
    output S; // Sum bit
    output CO;   // Carry bit
    
    wire S1, C1, C2; // Sum1, Carry1, Carry2
    
    half_adder Adder1(A, B, S1, C1);
    half_adder Adder2(CI, S1, S, C2);
    
    or O1(CO, C2, C1);
endmodule

module half_adder(A, B, S, C);
    input A, B;
    output S, C;
    
    xor X1(S, A, B);
    and A1(C, A, B);
endmodule

module Dflip(set, clk, Q, Qn);
    input set;   // Inputs
    input clk;
    output reg Q; // Outputs
    output reg Qn;

    always @(posedge clk) begin // Update on clock
        Q = set;
        Qn = ~Q;
    end
endmodule

module dec3_8(in, out);
    input [2:0] in;   // 3 bit input
    output [7:0] out; // 8 bit output
    
    and A0(out[0], ~in[0], ~in[1], ~in[2]);
    and A1(out[1], in[0], ~in[1], ~in[2]);
    and A2(out[2], ~in[0], in[1], ~in[2]);
    and A3(out[3], in[0], in[1], ~in[2]);
    and A4(out[4], ~in[0], ~in[1], in[2]);
    and A5(out[5], in[0], ~in[1], in[2]);
    and A6(out[6], ~in[0], in[1], in[2]);
    and A7(out[7], in[0], in[1], in[2]);
endmodule

module mux8_1(in, select, out);
    input [7:0] in;     // 8 bit input
    input [2:0] select; // 3 bit select line
    output out;         // 1 bit output
    
    wire D0, D1, D2, D3, D4, D5, D6, D7; // Intermediate logic for muxing
    
    assign D0 = in[0] & ~select[0] & ~select[1] & ~select[2];
    assign D1 = in[1] & select[0] & ~select[1] & ~select[2];
    assign D2 = in[2] & ~select[0] & select[1] & ~select[2];
    assign D3 = in[3] & select[0] & select[1] & ~select[2];
    assign D4 = in[4] & ~select[0] & ~select[1] & select[2];
    assign D5 = in[5] & select[0] & ~select[1] & select[2];
    assign D6 = in[6] & ~select[0] & select[1] & select[2];
    assign D7 = in[7] & select[0] & select[1] & select[2];
    
    assign out = D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7;
endmodule
