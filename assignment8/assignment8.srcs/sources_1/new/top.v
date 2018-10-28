`timescale 1ns / 1ps
/* FP Adder
module FPAdder(F1, F2, out);
    input [31:0] F1, F2;
    output [31:0] out;
    
    //Setup local variables for parts of FP numbers
    //Inputs
    wire sign1, sign2;
    reg [7:0] exp1, exp2;
    reg [23:0] val1, val2; //larger local variables for leading 1
    assign sign1 = F1[31];
    assign sign2 = F2[31];
    //Output
    reg signout;
    reg [7:0] expout;
    reg [22:0] valout;
    reg [24:0] val; //placeholder for possibly larger value
    assign out[31] = signout;
    assign out[30:23] = expout;
    assign out[22:0] = valout;
    
    reg [5:0] shift; //number of shifts based on exp
    
    always @(*) begin
        
        // Adjust exponents
        exp1 = F1[30:23] - 127;
        exp2 = F2[30:23] - 127;
        
        signout = 0;
        
        val1 = {1'b1, F1[22:0]}; //append leading 1
        val2 = {1'b1, F2[22:0]};
        
        //Shift for positive exponents
        if (exp1 > exp2 && exp1[7] != 1) begin
            shift = exp1 - exp2;
            val2 = val2 >> shift;
            expout = exp1;
        end
        else if (exp2 > exp1 && exp2[7] != 1) begin
            shift = exp2 - exp1;
            val1 = val1 >> shift;
            expout = exp2;
        end
        //Shift for negative exponents
        if (exp1 > exp2 && exp1[7] == 1) begin
            shift = exp2 - exp1;
            val1 = val1 >> shift;
            expout = exp2;
        end
        else if (exp2 > exp1 && exp2[7] == 1) begin
            shift = exp1 - exp2;
            val2 = val2 >> shift;
            expout = exp1;
        end
        
        //Addition
        val = val1 + val2;
        
        //Adjust exponent out if val is large enough
        if (val[24] == 1) begin
            expout = expout + 1;
            val = val >> 1;
        end
        
        // adjust expout
        expout = expout + 127;
            
        //Populate valout
        valout[22:0] = val[22:0];
    
    end
        
endmodule
*/
// 64x64 multiplier
module mult64x64(A, B, out);
    input [4095:0] A;    //Inputs, flattened for verilog compatibility
    input [4095:0] B;
    output [4095:0] out; //Output
    
    reg [4095:0] result; //temp register
    assign out = result;
    
    always @(*) begin
    
        result = A & B;
    
    end
    
endmodule
