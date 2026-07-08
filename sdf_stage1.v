module sdf_stage1 (
    input clk,
    input rst,
    input signed [7:0] in_r, in_i,
    output reg signed [8:0] out_r, out_i,
    output reg out_valid
);


reg signed [7:0] tw_r, tw_i;  


always @(*) begin
    case (count[1:0])  
        2'd0: begin tw_r = 8'sd32;   tw_i = 8'sd0;    end  // 1.0
        2'd1: begin tw_r = 8'sd22;   tw_i = -8'sd22;  end  // ≈ 0.707
        2'd2: begin tw_r = 8'sd0;    tw_i = -8'sd32;  end  // -j1
        2'd3: begin tw_r = -8'sd22;  tw_i = -8'sd22;  end  // ≈ -0.707 - j0.707
    endcase
end

reg signed [8:0] delay_r [0:3];
reg signed [8:0] delay_i [0:3];
reg signed [16:0] dr;
reg signed [16:0] di;
integer i;
reg [2:0] count;

always @(posedge clk or posedge rst) begin
    if (rst)
    begin
        count <= 0;
        out_valid <=0;
    end
    else
    begin
        count <= count + 1;
        if(count == 4)
         out_valid <= 1;
    end
    
end

always @(posedge clk) begin
//$display("%d %d %d %d %d %d %d %d %d", count, in_r, out_r,out_i, delay_r[0],delay_r[1],  out_valid, dr, di);
    if (count < 4) 
    begin
        delay_r[0] <= in_r;
        delay_i[0] <= in_i;
        for(i=1;i<4;i=i+1) 
        begin
            delay_r[i] <= delay_r[i-1];
            delay_i[i] <= delay_i[i-1];
        end
        out_r <= delay_r[3];
        out_i <= delay_i[3];
    end
    else
    begin
        out_r <= in_r + delay_r[3];
        out_i <= in_i + delay_i[3];
        dr = (((delay_r[3] - in_r) * tw_r) - ((delay_i[3] - in_i) * tw_i))>>>5 ;
        di = (((delay_r[3] - in_r) * tw_i) + ((delay_i[3] - in_i) * tw_r))>>>5 ;
        delay_r[0] <=dr;
        delay_i[0] <=di;
        for(i=1; i<4; i=i+1) begin
            delay_r[i] <= delay_r[i-1];
            delay_i[i] <= delay_i[i-1];
        end
    end
end


endmodule
