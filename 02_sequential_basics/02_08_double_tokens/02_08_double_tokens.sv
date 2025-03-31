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

    logic [7:0] one_count;
    always_ff @(posedge clk) begin
        if (rst)  begin
            { one_count, overflow } <= {'1, '0};
        end
        else if (one_count >= 200) begin
            overflow <= '1;
        end
        else if (a) begin
            one_count <= one_count + 1;
        end
    end

    logic [7:0] tmp2;
    logic res;
    always_ff @(posedge clk) begin
        if (rst) begin
            { tmp2, res } <= {'0, '0};
        end
        else if (a) begin
            { tmp2, res } <= {tmp2 + '1, '1};
        end
        else if (tmp2) begin
            { tmp2, res } <= {tmp2 - '1, '1};
        end
        else begin
            res <= '0;
        end
    end

    assign b = res & (~overflow);

endmodule
