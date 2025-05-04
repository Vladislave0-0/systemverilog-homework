module formula_2_pipe
(
    input         clk,
    input         rst,

    input         arg_vld,
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,

    output        res_vld,
    output [31:0] res
);

    logic [31:0] b_squared, a_temp, c_temp;
    logic [31:0] four_ac;
    logic [31:0] discriminant;

    logic vld1, vld2, vld3;

    always_ff @(posedge clk) begin
        if (arg_vld) begin
            b_squared <= b * b;
            a_temp <= a;
            c_temp <= c;
        end
        vld1 <= arg_vld;
    end

    always_ff @(posedge clk) begin
        if (vld1) begin
            four_ac <= 4 * a_temp * c_temp;
        end
        vld2 <= vld1;
    end

    always_ff @(posedge clk) begin
        if (vld2) begin
            discriminant <= b_squared - four_ac;
        end
        vld3 <= vld2;
    end
    
    assign res = discriminant;
    assign res_vld = vld3;

endmodule


// СДАЧА ЗАДАНИЯ
// module formula_2_pipe
// (
//     input               clk,
//     input               rst,

//     input               arg_vld,
//     input  signed [31:0] a,
//     input  signed [31:0] b,
//     input  signed [31:0] c,

//     output              res_vld,
//     output signed [31:0] res
// );

//     logic signed [31:0] a_s0, b_s0, c_s0;
//     logic                vld_s0;
//     always_ff @(posedge clk or posedge rst) begin
//         if (rst) begin
//             vld_s0 <= 1'b0;
//         end else begin
//             vld_s0 <= arg_vld;
//         end
//         if (arg_vld) begin
//             a_s0 <= a;
//             b_s0 <= b;
//             c_s0 <= c;
//         end
//     end

//     logic signed [31:0] b2_s1, ac_s1, a_tmp;
//     logic                vld_s1;
//     always_ff @(posedge clk or posedge rst) begin
//         if (rst) begin
//             vld_s1 <= 1'b0;
//         end else begin
//             vld_s1 <= vld_s0;
//         end
//         if (vld_s0) begin
//             b2_s1 <= b_s0 * b_s0;
//             ac_s1 <= a_s0 * c_s0;
//             a_tmp <= a_s0;
//         end
//     end

//     logic signed [31:0] d_s2;
//     logic                vld_s2;
//     always_ff @(posedge clk or posedge rst) begin
//         if (rst) begin
//             vld_s2 <= 1'b0;
//         end else begin
//             vld_s2 <= vld_s1;
//         end
//         if (vld_s1) begin
//             d_s2 <= b2_s1 - (ac_s1 <<< 2) + a_tmp;
//         end
//     end

//     assign res     = d_s2;
//     assign res_vld = vld_s2;

// endmodule
