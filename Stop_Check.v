module Stop_Check (
    input wire       clk            ,
    input wire       rst            ,
    input wire       sampled_bit    ,
    input wire       stp_chk_en     ,
    output reg       stp_err        
);
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        stp_err<='b0;
    end
    else if (stp_chk_en) begin
        stp_err<=sampled_bit^1'b1;
    end
end
    
endmodule