module data_sampling (
    input wire       clk             ,
    input wire       rst             ,
    input wire       RX_IN           ,
    input wire [4:0] Prescale        ,
    input wire [2:0] edge_cnt        ,
    input wire       data_samp_en    ,
    output reg       sampled_bit 
);
reg  [2:0] sample ;
wire [3:0] before,
           after ,
           middle ; 
assign middle =(Prescale>>1)-1;
assign before =middle-1;
assign after =middle+1 ;

always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        sample<='b0;
    end 
    else if (data_samp_en) begin 
        if(edge_cnt==before) begin
            sample[0] <=RX_IN;       
        end
        else if (edge_cnt==middle) begin
            sample[1] <=RX_IN;
        end
        else if (edge_cnt==after) begin
            sample[2] <= RX_IN;
        end     
    end
    else begin
        sample<='b0;
    end
end
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        sampled_bit<='b0;
    end
    else if (data_samp_en) begin
        case (sample)
        3'b000    : begin
                    sampled_bit<='b0;
                    end 
        3'b001    : begin
                    sampled_bit<='b0;
                    end 
        3'b010    : begin
                    sampled_bit<='b0;
                    end 
        3'b011    : begin
                    sampled_bit<='b1;
                    end 
        3'b100    : begin
                    sampled_bit<='b0;
                    end 
        3'b101    : begin
                    sampled_bit<='b1;
                    end 
        3'b110    : begin
                    sampled_bit<='b1;
                    end 
        3'b111    : begin
                    sampled_bit<='b1;
                    end 
            default: begin
                     sampled_bit<='b0;
                     end
        endcase
    end
    else begin
        sampled_bit<='b0;
    end
    
end 
endmodule