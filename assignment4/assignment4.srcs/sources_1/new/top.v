`timescale 1ns / 1ps

module sub1_Bit(A, B, Bin, Diff, Bout);
    input A, B, Bin;
    output Diff, Bout;
    
    assign Diff = (A^B) ^ Bin;       // Actual difference
    assign Bout = ~A*B | ~(A^B)*Bin; // Borrow out bit
endmodule

module sub4_Bit(A, B, Bin, Diff, Bout);
    input [3:0] A, B;
    input Bin;
    output [3:0] Diff;
    output Bout;
    
    wire [3:0] borrows;
    assign Bout = borrows[3]; // Bout is the last borrow
    
    sub1_Bit s0(A[0], B[0], Bin, Diff[0], borrows[0]);
    sub1_Bit s1(A[1], B[1], borrows[0], Diff[1], borrows[1]);
    sub1_Bit s2(A[2], B[2], borrows[1], Diff[2], borrows[2]);
    sub1_Bit s3(A[3], B[3], borrows[2], Diff[3], borrows[3]);
endmodule

// Behavioral level 4 bit adder
module add4_Bit(A, B, Cin, Sum, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] Sum;
    output Cout;
    
    reg [4:0] internal_sum; // 5 bit internal sum including carry out
    // Assign outputs to corresponding bits of internal_sum
    assign Cout = internal_sum[4];
    assign Sum = internal_sum[3:0];
    
    always @(A, B, Cin) begin
        internal_sum = A + B + Cin;
    end
endmodule

// Gate level OR
module or4_Bit(A, B, OR);
    input [3:0] A, B;
    output [3:0] OR;
    
    or o0(OR[0], A[0], B[0]);
    or o1(OR[1], A[1], B[1]);
    or o2(OR[2], A[2], B[2]);
    or o3(OR[3], A[3], B[3]);
endmodule

// Data flow level AND
module and4_Bit(A, B, AND);
    input [3:0] A, B;
    output [3:0] AND;
    
    assign AND = A & B;
endmodule

// Shift left
module shl4_Bit(A, OUT);
    input [3:0] A;
    output [3:0] OUT;
    
    assign OUT[3:1] = A[2:0];
    assign OUT[0] = 0;
endmodule

// Shift right
module shr4_Bit(A, OUT);
    input [3:0] A;
    output [3:0] OUT;
    
    assign OUT[2:0] = A[3:1];
    assign OUT[3] = 0;
endmodule

// Rotate left
module rol4_Bit(A, OUT);
    input [3:0] A;
    output [3:0] OUT;
    
    assign OUT[3:1] = A[2:0];
    assign OUT[0] = A[3];
endmodule

// Rotate right
module ror4_Bit(A, OUT);
    input [3:0] A;
    output [3:0] OUT;
    
    assign OUT[2:0] = A[3:1];
    assign OUT[3] = A[0];
endmodule

// 4 bit ALU
module alu4_Bit(A, B, Cin, ctrl, out, Cout);
    input [3:0] A, B;
    input [2:0] ctrl;
    input Cin;
    output [3:0] out;
    output Cout;
    
    reg [3:0] aluOut; // Variable output for alu unit
    assign out = aluOut;
    
    // Outputs for each module
    wire [3:0] ADD, SUB, OR, AND, SHL, SHR, ROL, ROR;
    // Various modules
    add4_Bit ADD0(A, B, Cin, ADD, Cout);
    sub4_Bit SUB0(A, B, Cin, SUB, Cout);
    or4_Bit  OR0(A, B, OR);
    and4_Bit AND0(A, B, AND);
    shl4_Bit SHL0(A, SHL);
    shr4_Bit SHR0(A, SHR);
    rol4_Bit ROL0(A, ROL);
    ror4_Bit ROR0(A, ROR);
    
    always @(A, B, Cin, ctrl) begin
        // Take ctrl line and set output to correct function
        case(ctrl)
            3'b000: aluOut = ADD;
            3'b001: aluOut = SUB;
            3'b010: aluOut = OR;
            3'b011: aluOut = AND;
            3'b100: aluOut = SHL;
            3'b101: aluOut = SHR;
            3'b110: aluOut = ROL;
            3'b111: aluOut = ROR;
            default: aluOut = 0;
        endcase
    end
    
endmodule