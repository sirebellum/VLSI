`timescale 1ns / 1ps

module pfull_adder(A, B, C, G, P, S);
    input A, B, C;
    output G, P, S;
    
    and a1(G, A, B); // Generate
    xor x1(P, A, B); // Propogate
    xor x2(S, P, C); // Sum
endmodule

module CLA(Cin, P, G, Cout);
    input [3:0] P, G;
    input Cin;
    output [3:0] Cout;
    
    assign Cout[0] = G[0] | P[0] & Cin;
    assign Cout[1] = G[1] | P[1] & Cout[0]; // Simplification of equations
    assign Cout[2] = G[2] | P[2] & Cout[1];
    assign Cout[3] = G[3] | P[3] & Cout[2];
endmodule

module CLAA_4bit(Cin, A, B, Cout, S);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;
    
    wire [3:0] G, P, C, pS; // Generate, Propagate, Carry, and partial-Sum
    assign Cout = C[3]; // Carry out is last carry of CLA_logic
    
    // Partial full adders. Sums are unused
    pfull_adder p0(A[0], B[0], Cin, G[0], P[0], pS[0]);
    pfull_adder p1(A[1], B[1], C[0], G[1], P[1], pS[1]);
    pfull_adder p2(A[2], B[2], C[1], G[2], P[2], pS[2]);
    pfull_adder p3(A[3], B[3], C[2], G[3], P[3], pS[3]);
    
    // CLA logic
    CLA c1(Cin, P, G, C);
    
    // Sum logic
    assign S[0] = P[0] ^ Cin;
    assign S[1] = P[1] ^ C[0];
    assign S[2] = P[2] ^ C[1];
    assign S[3] = P[3] ^ C[2];
endmodule