module UART #(
    parameter  data_width =4'd8 ,
               prescale_width=3'd5
) (
    input wire TX_CLK                         ,
    input wire RX_CLK                         ,
    input wire RST                            ,
    input wire RX_IN                          ,
    input wire [data_width-1:0] TX_IN         ,
    input wire TX_IN_V                        ,
    input wire PAR_EN                         ,
    input wire PAR_TYP                        ,
    input wire [prescale_width-1:0] Prescale  ,
    output wire RX_OUT_V                      ,
    output wire [data_width-1:0] RX_OUT       ,
    output wire stp_err                       ,
    output wire par_err                       ,
    output wire TX_OUT                        ,
    output wire TX_OUT_V                      
);



UART_TX U0_UART_TX (
.P_DATA(TX_IN)             ,
.Data_Valid(TX_IN_V)       ,
.PAR_EN(PAR_EN)            ,
.PAR_TYP(PAR_TYP)          ,
.clk(TX_CLK)               ,
.rst(RST)                  ,
.TX_OUT(TX_OUT)            ,
.busy(TX_OUT_V)
);
UART_RX U0_UART_RX (
.clk(RX_CLK)            ,
.rst(RST)               ,
.RX_IN(RX_IN)           ,
.Prescale(Prescale)     ,
.PAR_EN(PAR_EN)         ,
.PAR_TYP(PAR_TYP)       ,
.data_valid(RX_OUT_V)   ,
.P_DATA(RX_OUT)         , 
.stp_err(stp_err)       ,
.par_err(parr_err)      
);

    
endmodule