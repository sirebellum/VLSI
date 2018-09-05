`timescale 1ns / 1ps

module test_bench();

 // Clock signal setup
reg clk = 0;
always
    #10 clk = ~clk; // Change every 10


reg [3:0] A, B;
reg Cin;
wire [3:0] Sum;
wire Cout;

CLAA_4bit c1(Cin, A, B, Cout, Sum);

initial begin // Initialize input
    A = 4'b0000;
    B = 4'b1101;
    Cin = 1;
end

endmodule