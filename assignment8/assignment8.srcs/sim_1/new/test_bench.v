`timescale 1ns / 1ps
/* FPAdder
module test_bench();

reg [31:0] f1, f2;
    wire [31:0] out;
    
    FPAdder fp(f1, f2, out);
    
    initial begin

        //positive exponents
        f1 = 32'b01000000101000000000000000000000; // 5.0
        f2 = 32'b01000001011110000000000000000000; // 15.5
        #10
        //negative and positive exponent
        f1 = 32'b00111111010100000000000000000000; // 0.8125
        f2 = 32'b01000000111000000000000000000000; // 7.0
        
    end
    
endmodule
*/
// 64x64 multiplier
module test_bench();

    // Inputs and outputs
    reg [63:0] a[63:0];
    reg [63:0] b[63:0];
    reg [63:0] out[63:0];
    wire [4095:0] OUT;
    
    // Inputs, flattened
    reg [4095:0] A;
    reg [4095:0] B;
    
    mult64x64 mult(A, B, OUT);
    
    // Indexing integers
    integer i;
    integer j;
    
    initial begin // Assign and flatten input
        
        // Populate 64x64 arrays
        for (i=0; i<64; i=i+1) begin
            a[i] = 64'b0000000000000000000000000000000000000000000000000000000000000001;
            b[i] = 64'b1000000000000000000000000000000000000000000000000000000000000001;
        end
        
        // Flatten 64x64 arrays
        for (i=0; i<64; i=i+1) begin
            for (j=0; j<64; j=j+1) begin
                A[i*64+j] = a[i][j];
                B[i*64+j] = b[i][j];
            end
        end
        
        #10
        // Expand OUTput arra
        for (i=0; i<64; i=i+1) begin
            for (j=0; j<64; j=j+1) begin
                out[i][j] = OUT[i*64+j];
            end
        end
            
    end
    
endmodule
