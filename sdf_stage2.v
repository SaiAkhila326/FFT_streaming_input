module sdf_stage2 (
    input clk,
    input rst,
    input enable,
    input signed [8:0] in_r, in_i,
    output reg signed [8:0] out_r, out_i,
    output reg out_valid
);

reg signed [15:0] dr;
reg signed [15:0] di;
reg signed [7:0] tw_r, tw_i;

always @(*) begin
    case (count[0])  
        2'd0: begin tw_r = 8'sd32;  tw_i = 8'sd0;    end  // W8^0
        2'd1: begin tw_r = 8'sd0;    tw_i = -8'sd32;  end  // W8^1
    endcase
end


reg signed [8:0] delay_r [0:1];
reg signed [8:0] delay_i [0:1];

integer i; 

reg [1:0] count; 
always @(posedge clk or posedge rst) begin
    if (rst)
    begin
        count <= 3;
        out_valid <=0;
    end
    else
    begin
        count <= count + 1;
        if(count == 2 && enable)
         out_valid <= 1;
    end
    
end

always @(posedge clk) begin

  // $display("%d %d %d %d %d %d %d %d", count, enable, in_r, out_r, out_i, delay_r[0],delay_r[1],out_valid);
    if(enable) begin
    if (count < 2) 
    begin
        delay_r[0] <= in_r;
        delay_i[0] <= in_i;
        for(i=1;i<2;i=i+1) 
        begin
            delay_r[i] <= delay_r[i-1];
            delay_i[i] <= delay_i[i-1];
        end
        out_r <= delay_r[1];
        out_i <= delay_i[1];
    end
    else
    begin
        out_r <= in_r + delay_r[1];
        out_i <= in_i + delay_i[1];
        
        dr = (((delay_r[1] - in_r) * tw_r) - ((delay_i[1] - in_i) * tw_i))>>>5 ;
        di = (((delay_r[1] - in_r) * tw_i) + ((delay_i[1] - in_i) * tw_r))>>>5 ;
        delay_r[0] <=dr;
        delay_i[0] <=di;

      //  delay_r[0] <= delay_r[1] - in_r;
      //  delay_i[0] <= delay_i[1] - in_i;

        for(i=1; i<2; i=i+1) 
        begin
            delay_r[i] <= delay_r[i-1];
            delay_i[i] <= delay_i[i-1];
        end
    end
    end

end

endmodule
