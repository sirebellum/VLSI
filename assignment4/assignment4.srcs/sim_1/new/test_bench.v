`timescale 1ns / 1ps

module test_bench();

 // Clock signal setup
reg clk = 0;
always
    #10 clk = ~clk; // Change every 10

reg [3:0] A, B;
reg Cin;
reg [2:0] ctrl;
wire [3:0] out;
wire Cout;

alu4_Bit alu(A, B, Cin, ctrl, out, Cout);

initial begin // Initialize input
    A = 8;
    B = 4;
    Cin = 1;
    ctrl = 1;
end

// Increment 8 times through all ctrl values
always @(posedge clk) begin
    repeat (8)
        #10 ctrl = ctrl + 1; // Delay so output is visible in timing diagram
end

endmodule
