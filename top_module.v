module fft_stage12 (
    input clk, rst,
    input signed [7:0] in_r, in_i,
    output signed [8:0] out_r, out_i,
    output out_valid
);
    wire signed [8:0] s1_r, s1_i, s2_r, s2_i;
    wire v1, v2;

    sdf_stage1 u1 (.clk(clk), .rst(rst), .in_r(in_r), .in_i(in_i), 
                   .out_r(s1_r), .out_i(s1_i), .out_valid(v1));

    sdf_stage2 u2 (.clk(clk), .rst(rst), .enable(v1), .in_r(s1_r), .in_i(s1_i), 
                   .out_r(s2_r), .out_i(s2_i), .out_valid(v2));

    sdf_stage3 u3 (.clk(clk), .rst(rst), .enable(v2), .in_r(s2_r), .in_i(s2_i), 
                   .out_r(out_r), .out_i(out_i), .out_valid(out_valid));
endmodule
