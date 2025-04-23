//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module float_discriminant (
    input                     clk,
    input                     rst,

    input                     arg_vld,
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,
    input        [FLEN - 1:0] c,

    output logic              res_vld,
    output logic [FLEN - 1:0] res,
    output logic              res_negative,
    output logic              err,

    output logic              busy
);

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs their discriminant.
    // The resulting value res should be calculated as a discriminant of the quadratic polynomial.
    // That is, res = b^2 - 4ac == b*b - 4*a*c
    //
    // Note:
    // If any argument is not a valid number, that is NaN or Inf, the "err" flag should be set.
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.


    real a_, b_, c_, result;

    function logic is_not_real(input real x);
        return (x == 1.0/0.0 || x == -1.0/0.0) || (x != x);
    endfunction

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            res_vld      <= 0;
            err          <= 0;
            res          <= 0;
            res_negative <= 0;
            busy         <= 0;
        end else begin
            if (arg_vld) begin
                busy <= 1;

                a_ = $bitstoreal(a);
                b_ = $bitstoreal(b);
                c_ = $bitstoreal(c);
                
                err <= is_not_real(a_) || is_not_real(b_) || is_not_real(c_);

                result = b_ * b_ - 4.0 * a_ * c_;
                res <= $realtobits(result);
                res_negative <= (result < 0.0);
                res_vld <= 1;

                busy <= 0;
            end else begin
                res_vld <= 0;
            end
        end
    end

endmodule
