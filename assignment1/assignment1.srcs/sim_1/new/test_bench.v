`timescale 1ns / 1ps
// ripple_adder test bench
module test_bench_name();
wire [3:0] sum;
wire carry;
reg [3:0] input1, input2;
reg Carryin;
ripple_carry instantiation_name(input1, input2, Carryin,
sum, carry);
initial
begin
#100 $finish; //total time to test
end
initial
begin
#10 //time to pass
Carryin = 0;
input1 = 4'b0000;
input2 = 4'b0111;
#10
input2 = 4'b1111;
#10
Carryin = 1;
input1 = 4'b1001;
input2 = 4'b0010;
#10
input2 = 4'b0001;
#10
input1 = 4'b1111;
input2 = 4'b1111;
end
endmodule
/*
// D flip flop test bench
module test_bench();

 // Clock signal setup
reg clk = 0;
always
    #10 clk = ~clk; // Change every 10

// Inputs and outputs
reg in;
wire Q, Qnot;

Dflip memory(in, clk, Q, Qnot);

initial begin // Initialize input and select line
    in = 0;
    #20 in = 1;
    #15 in = 0; // Simulate impulse that won't be stored in memory
    #10 in = 1;
end
endmodule
*/
/*
// full adder test bench
module test_bench();

 // Clock signal setup
reg clk = 0;
always
    #10 clk = ~clk; // Change every 10

// Inputs and outputs
reg [2:0] in; // Cin, B, A
wire sum, Cout;

full_adder adder(in[0], in[1], in[2], sum, Cout);

initial begin // Initialize input
    in = 0;
end

always @(posedge clk) begin
    repeat (8) // Increment 8 times through all select values
        #10 in = in + 1; // Delay so output is visible in timing diagram
end
endmodule
*/

/*
// 3 to 8 decoder
module test_bench();

 // Clock signal setup
reg clk = 0;
always
    #10 clk = ~clk; // Change every 10


reg [2:0] test_input;
wire [7:0] out;

dec3_8 decoder(test_input, out);

initial begin // Initialize input
    test_input = 8'b000;
end

always @(posedge clk) begin
    repeat (8) // Increment 8 times through all select values
        #10 test_input = test_input + 1; // Delay so output is visible in timing diagram
end
endmodule
*/

/*
// 8 to 1 muxer test bench
module test_bench();

 // Clock signal setup
reg clk = 0;
always
    #10 clk = ~clk; // Change every 10


reg [7:0] test_input;
reg [2:0] select_line;
wire out;

mux8_1 muxer(test_input, select_line, out);

initial begin // Initialize input and select line
    test_input = 8'b10101011;
    select_line = 0;
end

always @(posedge clk) begin
    repeat (8) // Increment 8 times through all select values
        #10 select_line = select_line + 1; // Delay so output is visible in timing diagram
end
endmodule
*/