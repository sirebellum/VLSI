`timescale 1ns / 1ps

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
/*
module full_adder(A, B, Cin, sum, C);
    input A;   // Inputs
    input B;
    input Cin; // Carry in
    output reg sum; // Sum bit
    output reg C;   // Carry bit
    
    wire [2:0] in; // Array to consolidate inputs for case statement
    assign in = {A, B, Cin};
    
    always @(A, B) begin // Change whenever input changes
        case(in) // Takes inputs and sets sum and carry based on values
          3'b000: begin
           sum = 0;
           C = 0; end
          3'b001: begin
           sum = 1;
           C = 0; end
          3'b010: begin
           sum = 1;
           C = 0; end
          3'b011: begin
           sum = 0;
           C = 1; end
          3'b100: begin
           sum = 1; 
           C = 0; end
          3'b101: begin
           sum = 0;
           C = 1; end
          3'b110: begin
           sum = 0;
           C = 1; end
          3'b111: begin
           sum = 1;
           C = 1; end
          default: begin
           sum = 0;
           C = 0; end
        endcase
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
*/