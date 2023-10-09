module parity_Calc #(
    parameter data_width=8
) (
    input wire [data_width-1:0] P_DATA     ,
    input wire                  Data_Valid ,
    input wire                  PAR_TYP    ,
    input wire                  clk        ,
    input wire                  rst        ,
    output reg                  par_bit  
);
    reg [data_width-1:0] Parity_DATA;


always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        Parity_DATA<='b0;
    end
    else begin 
     if (Data_Valid) begin
        Parity_DATA<=P_DATA;
     end
    end
    
end
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        par_bit <='b0;
    end
else begin
    if (PAR_TYP) begin
        par_bit <=~^Parity_DATA; 
    end else begin
                par_bit <=^Parity_DATA; 
    end
end
end
endmodule