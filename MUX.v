module MUX (
   input wire [1:0] mux_sel  ,
   input wire       ser_data ,
   input wire       par_bit  ,
   input wire       clk      ,
   input wire       rst      ,
   output reg       TX_OUT  
);
reg OUT ;

always @(*) begin
    case (mux_sel)
     2'b00 : begin
        OUT=1'b0;
     end
    2'b01 : begin
        OUT=ser_data;
    end
    2'b10 : begin
        OUT=par_bit;
    end 
    2'b11 : begin
        OUT=1'b1;
    end    
    endcase
end
always @(posedge clk or negedge rst  ) begin
    if (!rst) begin
        TX_OUT<=1'b0;
    end else begin
        TX_OUT<=OUT;
    end
end



    
endmodule