//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output logic [1:0] grants
);
    // Task:
    // Implement a "arbiter" module that accepts up to two requests
    // and grants one of them to operate in a round-robin manner.
    //
    // The module should maintain an internal register
    // to keep track of which requester is next in line for a grant.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // requests -> 01 00 10 11 11 00 11 00 11 11
    // grants   -> 01 00 10 01 10 00 01 00 10 01

    logic prev_opened;  // prev_opened = 0 для первого
                        // prev_opened = 1 для второго

    always_ff @(posedge clk) begin
        if (rst) 
            prev_opened <= '1;
        else if (requests[0] == '1 & requests[1] == '0) 
            prev_opened <= '0;
        else if (requests[0] == '0 & requests[1] == '1) 
            prev_opened <= '1;
        else if (requests[0] == '1 & requests[1] == '1) 
            prev_opened <= prev_opened + 1;
    end

    always @(requests) begin
        if (rst) begin
            grants[0] = 'x;
            grants[1] = 'x;
        end
        if (requests[0] == '0 & requests[1] == '0) begin
            grants[0] = '0;
            grants[1] = '0;
        end
        else if (requests[0] == '0 & requests[1] == '1) begin
            grants[0] = '0;
            grants[1] = '1;
        end
        else if (requests[0] == '1 & requests[1] == '0) begin
            grants[0] = '1;
            grants[1] = '0;
        end
        else if (requests[0] == '1 & requests[1] == '1) begin
            if (prev_opened == '0) begin
                grants[0] = '0;
                grants[1] = '1;
            end
            else begin
                grants[0] = '1;
                grants[1] = '0;
            end
        end
    end

endmodule
