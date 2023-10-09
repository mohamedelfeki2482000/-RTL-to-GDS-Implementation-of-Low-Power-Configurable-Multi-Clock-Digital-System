module edge_bit_counter (
    input wire       clk           ,
    input wire       rst           ,
    input wire       enable        ,
    output reg [3:0] bit_cnt       ,
    output reg [2:0] edge_cnt 
);
wire edge_cnt_done ;
//edge counter
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        edge_cnt<='b0;
    end
    else if (enable) begin
        if (edge_cnt_done) begin
            edge_cnt<='b0;
        end else begin
            edge_cnt<=edge_cnt+1'b1;
        end

    end
    else begin
        edge_cnt<='b0;
    end 
end
assign edge_cnt_done= (edge_cnt==3'b111) ? 1'b1 :1'b0;
//bit counter
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        bit_cnt<='b0;
    end 
    else if (enable) begin
        if (edge_cnt_done) begin
            bit_cnt<=bit_cnt+1'b1;
        end
    end
    else begin
        bit_cnt<='b0;
    end
end

    
endmodule