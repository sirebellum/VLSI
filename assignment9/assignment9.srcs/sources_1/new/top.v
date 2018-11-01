`timescale 1ns / 1ps

// Performs (A*B)+C
module MAF(
    input [31:0] A, B, C,
    output [31:0] out
    );
    
    //Inputs/Local-outs
    reg [31:0] fa1, fa2, fm1, fm2;
    wire [31:0] outa, outm;
    //Output
    reg [31:0] valout;
    assign out = valout;
    
    //Multiply and Add functions
    FPAdd fpa(fa1, fa2, outa);
    FPMultiply fpm(fm1, fm2, outm);
    
    always @(A, B, C) begin
        #1
        // Multiply A and B
        fm1 = A;
        fm2  = B;
        #1
        // Add (AxB) to C
        fa1 = outm;
        fa2  = C;
        #1
        // Output result
        valout = outa;

    end
    
endmodule

// Multiply two floating point numbers
module FPMultiply(
    input [31:0] F1, F2,
    output [31:0] out
    );
    
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
    reg [47:0] val; //placeholder for possibly huge value
    assign out[31] = signout;
    assign out[30:23] = expout;
    assign out[22:0] = valout;
    
    reg [4:0] bits1, bits2; //number of bits in each mantissa
    
    reg [5:0] index; //index for selecting val digit
    reg [5:0] counter;
    
    always @(F1, F2) begin
    
        // Adjust exponents
        exp1 = F1[30:23] - 127;
        exp2 = F2[30:23] - 127;
        expout = 0;
    
        signout = 0;
        expout = exp1 + exp2;
        
        val1 = {1'b1, F1[22:0]}; //append leading 1
        val2 = {1'b1, F2[22:0]};
        
        //Remove trailing zeroes
        bits1 = 24;
        bits2 = 24;
        while (val1[0] != 1 && bits1) begin
            val1 = val1 >> 1;
            bits1 = bits1 - 1; //count number of bits
        end
        while (val2[0] != 1 && bits2) begin
            val2 = val2 >> 1;
            bits2 = bits2 - 1;
        end
        
        //Multiplication
        val = val1 * val2;
        
        //Find first non zero value in multiplied value
        index = 47;
        while (val[index] == 0 && index != 0) begin
          index = index - 1;
        end
        
        //Adjust exp for decimal shift that may occur during mult. of mantissa
        //Uses number of bits in multiplicands and number of bits in result to determine adjustment
        expout = expout + (index + 1 - (bits1 + bits2 - 2) - 1);
        
        // adjust expout
        expout = expout + 127;
        
        //Populate valout register
        counter = 0;
        valout = 0;
        while (counter <= 22) begin
          counter = counter + 1;
          valout = valout << 1;
          val = val << 1; //comes before assignment to remove leading 1
          valout[0] = val[index];
        end

    end
    
endmodule

// Add two floating point numbers
module FPAdd(F1, F2, out);
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
    
    always @(F1, F2) begin
        
        // Adjust exponents
        exp1 = F1[30:23] - 127;
        exp2 = F2[30:23] - 127;
        expout = 0;
        
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
