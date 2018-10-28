`timescale 1ns / 1ps
// FP Adder
module FPAdder(F1, F2, out);
    input [31:0] F1, F2;
    output [31:0] out;
    
    //Setup local variables for parts of FP numbers
    //Inputs
    wire sign1, sign2;
    wire signed [7:0] exp1, exp2;
    reg [23:0] val1, val2; //larger local variables for leading 1
    assign sign1 = F1[31];
    assign exp1 = F1[30:23] - 127; //adjust for exp bias
    assign sign2 = F2[31];
    assign exp2 = F2[30:23] - 127;
    //Output
    reg signout;
    reg [7:0] expout;
    reg [22:0] valout;
    reg [23:0] val; //placeholder for possibly larger value
    assign out[31] = signout;
    assign out[30:23] = expout + 127;
    assign out[22:0] = valout;
    
    reg [4:0] bits1, bits2; //number of bits in each mantissa
    
    reg [5:0] index; //index for selecting val digit
    reg [5:0] shift; //number of shifts based on exp
    reg [5:0] size; 
    
    always @(F1, F2) begin
        
        signout = 0;
        
        val1 = {1'b1, F1[22:0]}; //append leading 1
        val2 = {1'b1, F2[22:0]};
        
        //Remove trailing zeroes
        bits1 = 24;
        bits2 = 24;
        while (val1[0] != 1) begin
            val1 = val1 >> 1;
            bits1 = bits1 - 1; //count number of bits
        end
        while (val2[0] != 1) begin
            val2 = val2 >> 1;
            bits2 = bits2 - 1;
        end
        
        //Match up decimal place
        if (bits1 > bits2) begin
            shift = bits1 - bits2;
            val2 = val2 << shift;
            size = bits1;
        end
        else if (bits2 > bits1) begin
            shift = bits2 - bits1;
            val1 = val1 << shift;
            size = bits2;
        end
        
        //Shift for exponents
        if (exp1 > exp2) begin
            shift = exp1 - exp2;
            val1 = val1 << shift;
            size = size + shift;
            expout = exp1;
        end
        else if (exp2 > exp1) begin
            shift = exp2 - exp1;
            val2 = val2 << shift;
            size = size + shift;
            expout = exp2;
        end
        
        //Addition
        val = val1 + val2;
        
        //Find first non zero value in added value
        index = 22;
        while (val[index] == 0 && index != 0) begin
          index = index - 1;
        end
        
        //Adjust exponent out if val is large enough
        if (index >= size)
            expout = expout + 1;
            
        //Populate valout
        shift = 22;
        while (shift >= 1) begin
            val = val << 1; //Remove leading 1, as well as shift
            valout[0] = val[index];
            valout = valout << 1;
            shift = shift - 1;
        end
    
    end
        
endmodule

/* 64x64 multiplier
module mult64x64(A, B, out);
    input [4095:0] A;    //Inputs, flattened for verilog compatibility
    input [4095:0] B;
    output [4095:0] out; //Output
    
    integer i, j; //For iterating through arrays
    reg [4095:0] result; //For storing answer within for loop
    
    assign out = result;
    
    always@ (A, B) begin
        
        // Iterate through arrays and populate output
        // In batches of 1024 to enable Encounter processing
        for (i=0; i<1024; i=i+1) begin
            result[i] = A[i] * B[i];
        end
        
        for (i=1024; i<2048; i=i+1) begin
            result[i] = A[i] * B[i];
        end
        
        for (i=2048; i<3072; i=i+1) begin
            result[i] = A[i] * B[i];
        end
        
        for (i=3072; i<4096; i=i+1) begin
            result[i] = A[i] * B[i];
        end
    
    end
    
endmodule
*/