module sdf_stage3 (
    input clk,
    input rst,
    input enable,
    input signed [8:0] in_r, in_i,
    output reg signed [8:0] out_r, out_i,
    output reg out_valid
);

reg signed [8:0] delay_r;
reg signed [8:0] delay_i;

integer i; 

reg count; 
always @(posedge clk or posedge rst) begin
    if (rst)
    begin
        count <= 0;
        out_valid <=0;
    end
    else
    begin
        count <= count + 1;
        if(count == 1)
         out_valid <= 1;
    end
    
end

always @(posedge clk) begin
    $display("%d %d %d %d %d %d %d", count, in_r, out_r, out_i, delay_r[0],delay_r[1], out_valid);
    if(enable) 
    begin
    if (count == 0) 
    begin
        delay_r <= in_r;
        delay_i <= in_i;
        out_r <= delay_r;
        out_i <= delay_i;
    end
    else
    begin
        out_r <= in_r + delay_r;
        out_i <= in_i + delay_i;
        delay_r <= delay_r - in_r;
        delay_i <= delay_i - in_i;
    end
    end

end

endmodule
