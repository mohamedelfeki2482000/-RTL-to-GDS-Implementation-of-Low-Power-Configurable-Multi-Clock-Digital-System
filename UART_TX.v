module UART_TX #(
    parameter data_width  =8  
) (
    input wire [data_width-1:0] P_DATA      ,
    input wire                  Data_Valid  ,
    input wire                  PAR_EN      ,
    input wire                  PAR_TYP     ,
    input wire                  clk         ,
    input wire                  rst         ,
    output wire                 TX_OUT      ,
    output wire                 busy

);
wire [1:0] mux_sel    ;
wire       ser_data   ;
wire       par_bit    ;
wire       ser_enable ;
wire       ser_done   ;       


MUX UART_MUX (
    .mux_sel  (mux_sel)  ,
    .ser_data (ser_data) ,
    .par_bit  (par_bit)  ,
    .clk      (clk)      ,
    .rst      (rst)      ,
    .TX_OUT   (TX_OUT)
    );
parity_Calc UART_parity_Calc (
    .P_DATA     (P_DATA)      ,
    .Data_Valid (Data_Valid)  ,
    .PAR_TYP    (PAR_TYP)     ,
    .clk        (clk)         ,
    .rst        (rst)         ,
    .par_bit    (par_bit)
    );
serializer UART_serializer (
    .P_DATA      (P_DATA)       ,
    .Data_Valid  (Data_Valid)   ,
    .ser_enable  (ser_enable)   ,
    .clk         (clk)          ,
    .rst         (rst)          ,
    .ser_data    (ser_data)     ,
    .ser_done    (ser_done)
);    
UART_TX_FSM UART_UART_TX_FSM (
    .Data_Valid (Data_Valid)   ,
    .ser_done   (ser_done)     ,
    .PAR_EN     (PAR_EN)       ,
    .clk        (clk)          ,
    .rst        (rst)          ,
    .mux_sel    (mux_sel)      ,
    .ser_en     (ser_enable)   ,
    .busy       (busy)
    );


    
endmodule