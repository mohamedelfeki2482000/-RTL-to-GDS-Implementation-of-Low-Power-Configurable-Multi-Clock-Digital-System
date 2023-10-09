module parity_Check #(
    parameter data_width =8
) (
    input wire                  clk                     ,
    input wire                  rst                     ,
    input wire [data_width-1:0] P_DATA                  ,
    input wire                  par_chk_en              ,
    input wire                  sampled_bit             ,
    input wire                  PAR_TYP                 ,
    output reg                  par_err                
);
 reg parity ;

always @(*) begin
    if (PAR_TYP=='b0) begin
        parity=^P_DATA ;
    end else begin
        parity=~^P_DATA;
    end
    
end
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        par_err<='b0;
    end else if (par_chk_en) begin
        par_err<=parity^sampled_bit;
    end
    

end
endmodule