`timescale 1ns / 1ps
module test_bench();

 // Clock signal setup
reg clk = 0;
always
    #10 clk = ~clk; // Change every 10

reg [11:0] A;
reg St;
wire [9:0] B;

BCD_Binary3 bcd(St, A, B, clk);

initial begin // Initialize input
    St = 0;
    A = 12'b100000010000;
    #1 St = 1; //initialize
    #1 St = 0;
    #8 St = 1; //start
    #10 St = 0;
end

endmodule