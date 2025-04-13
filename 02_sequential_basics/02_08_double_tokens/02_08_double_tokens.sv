//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output       b,
    output logic overflow
);
    // Task:
    // Implement a serial module that doubles each incoming token '1' two times.
    // The module should handle doubling for at least 200 tokens '1' arriving in a row.
    //
    // In case module detects more than 200 sequential tokens '1', it should assert
    // an overflow error. The overflow error should be sticky. Once the error is on,
    // the only way to clear it is by using the "rst" reset signal.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 10010011000110100001100100
    // b -> 11011011110111111001111110

    logic [7:0] ones_counter1;
    always_ff @(posedge clk) begin
        if (rst)  begin
            {ones_counter1, overflow} <= {'1, '0};
        end
        else if (ones_counter1 >= 200) begin
            overflow <= '1;
        end
        else if (a) begin
            ones_counter1 <= ones_counter1 + 1;
        end
    end

    logic [7:0] ones_counter2;
    logic res;
    always_ff @(posedge clk) begin
        if (rst) begin
            {ones_counter2, res} <= {'0, '0};
        end
        else if (a) begin
            {ones_counter2, res} <= {ones_counter2 + '1, '1};
        end
        else if (ones_counter2) begin
            {ones_counter2, res} <= {ones_counter2 - '1, '1};
        end
        else begin
            res <= '0;
        end
    end

    assign b = res & (~overflow);

endmodule
