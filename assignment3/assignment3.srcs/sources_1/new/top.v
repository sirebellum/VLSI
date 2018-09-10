`timescale 1ns / 1ps
// 3 digit BCD to binary counter
module BCD_Binary3(St, A, B, CLK);
    input [11:0] A;     // Input BCD digits
    input St, CLK;      // Start bit, Clock
    output reg [9:0] B; // Output binary value

    reg [1:0] state; // Stores states, 00: initial, 01: shift, 10: correct
    reg [3:0] counter; // Count number of shifts
    reg [11:0] Areg; // Register for storing and manipulating input A
    
    wire Sh; // 0 if counter reached 9
    assign Sh = !( counter[3] & (counter[1]|counter[2]) ); // False when >= 1010 (9)
    
    wire Co; // 1 if any bcd is >= 1000
    assign Co = Areg[3] | Areg[7] | Areg[11];
    
    // Internal clock gated by state so that only start can trigger initial execution
    wire clk_internal;
    assign clk_internal = (state[0]|state[1]) & CLK;
    
    // Execute at start, and also on state change
    always @ (posedge St, posedge clk_internal) begin
        case(state)
        
            // INITIAL STATE
            2'b00: begin
                counter = 0;
                Areg = A;
                #5
                if (St == 1) begin // If start bit, set and change state
                    state = 2'b01;
                    B = 0;
                end
            end
            
            // SHIFT STATE
            2'b01: begin
                // Shift and increment counter
                B = B >> 1;
                B[9] = Areg[0];
                Areg = Areg >> 1;
                counter = counter + 1;
                #5
                // If counter <= 9
                if (Sh == 1)
                    state = 2'b01;
                else
                    state = 2'b00;
                    
                // If correction needed, change state
                if (Co == 1)
                    state = 2'b10;
            end
            
            // CORRECTION STATE
            2'b10: begin
                // Subtract 0011 from first invalid bcd
                if (Areg[3] == 1)
                    Areg[3:0] = Areg[3:0] - 4'b0011;
                else if (Areg[7] == 1)
                    Areg[7:4] = Areg[7:4] - 4'b0011;
                else if (Areg[11] == 1)
                    Areg[11:8] = Areg[11:8] - 4'b0011;
                #5
                state = 2'b01;
            end
            
            // INITIALIZE
            default: begin
                Areg = 0;
                state = 0;
                counter = 0;
                B = 0;
            end
            
        endcase
    
    end
    
endmodule