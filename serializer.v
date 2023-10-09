module serializer #(
    parameter data_width =8
) (
    input wire [data_width-1:0]  P_DATA     ,
    input wire                   Data_Valid ,
    input wire                   ser_enable ,
    input wire                   clk        ,
    input wire                   rst        , 
    output wire                  ser_data   ,
    output wire                  ser_done 
);
reg [data_width-1:0] serial_data ;
reg [2:0]            counter     ;

// serializer always block 
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        serial_data<='b0;
    end 
    else if (Data_Valid && !ser_enable) begin
        serial_data<=P_DATA ;
        
    end
    else if  (ser_enable) begin
        serial_data<=serial_data>>1;
    end
        
    
end
// counter always block
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        counter<=3'b0;
    end
    else if (ser_enable) begin
        counter<=counter+1'b1;
    end
    else begin
        counter<=3'b0;
    end
end
assign ser_data =serial_data[0]               ;
assign ser_done = (counter==3'b111)           ;




    
endmodule