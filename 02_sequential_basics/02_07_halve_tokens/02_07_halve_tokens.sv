//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module halve_tokens
(
    input  clk,
    input  rst,
    input  a,
    output logic b
);
    // Task:
    // Implement a serial module that reduces amount of incoming '1' tokens by half.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 110_011_101_000_1111
    // b -> 010_001_001_000_0101

    int ones_counter;
    logic a_r;
    
    always_ff @(posedge clk) begin
        if (rst) 
            a_r <= 0;

        else 
            a_r <= a;
    end

    always_comb begin
        if (a == '1) 
            ones_counter = ones_counter + 1;

        if (rst) begin
            b = '0;
            ones_counter = 0;
        end

        else if (a & a_r & ~(ones_counter % 2))
            b = '1;

        else 
            b = '0; 
    end
endmodule
