`timescale 1ns / 1ps
module test_bench();
    reg [31:0] f1, f2, f3;
    wire [31:0] out;
    
    MAF MultAdd(f1, f2, f3, out);
    
    initial begin
        //positive exponents
        f1 = 32'b01000000101000000000000000000000; // 5.0
        f2 = 32'b01000001011110000000000000000000; // 15.5
        f3 = 32'b01000000101000000000000000000000; // 5.0
        #10
        //negative and positive exponent
        f1 = 32'b00111111010100000000000000000000; // 0.8125
        f2 = 32'b01000000111000000000000000000000; // 7.0
        f3 = 32'b01000001011110000000000000000000; // 15.5
        #10
        //1s
        f1 = 32'b00111111100000000000000000000000; // 1
        f2 = 32'b00111111100000000000000000000000; // 1
        f3 = 32'b00111111100000000000000000000000; // 1
        
    end
    
endmodule
