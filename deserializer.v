module deserializer #(
    parameter data_width =8
) (
    input wire                  clk                    ,
    input wire                  rst                    ,
    input wire                  deser_en               ,
    input wire                  sampled_bit            ,
    input wire [2:0]            edge_cnt               ,
    output reg [data_width-1:0] P_DATA 
);
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        P_DATA<='b0;    
    end
    else if (edge_cnt==3'd7 && deser_en) begin
        P_DATA<={sampled_bit,P_DATA[7:1]};
    end
end
endmodule