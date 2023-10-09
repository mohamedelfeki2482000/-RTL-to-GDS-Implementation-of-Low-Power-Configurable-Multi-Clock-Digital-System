module strt_Check (
    input wire strt_chk_en,
    input wire sampled_bit,
    input wire clk        ,
    input wire rst        ,
    output reg strt_glitch
);

always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        strt_glitch<=1'b0;
    end
    else if (strt_chk_en) begin
        strt_glitch<=sampled_bit;
    end

end


    
endmodule