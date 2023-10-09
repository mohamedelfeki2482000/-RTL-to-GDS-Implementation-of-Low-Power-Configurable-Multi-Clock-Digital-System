module SYS_CTRL #(
    parameter  data_Width =8 ,
               Addr_width =4 
) (
    input wire CLK                                    ,
    input wire RST                                    ,
    input wire [2*data_Width-1:0] ALU_OUT             ,
    input wire                    ALU_OUT_VLD         ,
    input wire [data_Width-1:0]   RF_RdData           , 
    input wire                    RF_RdData_Valid     ,
    input wire [data_Width-1:0]   UART_RX_DATA        ,
    input wire                    UART_RX_VLD         ,
    input wire                    UART_TX_Busy        ,
    output wire                    ALU_EN              ,
    output wire [3:0]              ALU_FUN             ,
    output wire                    CLKG_EN             ,
    output wire [Addr_width-1:0]   RF_Address          ,
    output wire                    RF_WrEn             ,
    output wire                    RF_RdEn             ,
    output wire [data_Width-1:0]   RF_WrData           ,
    output wire                    CLK_DIV_EN          , 
    output wire                    UART_TX_Valid       ,
    output wire [data_Width-1:0]   UART_TX_DATA         
);
wire                    UART_ALU_SEND       ;
wire                    UART_RF_SEND        ; 
wire [data_Width-1:0]   UART_SEND_RF_DATA   ;
wire [2*data_Width-1:0] UART_SEND_ALU_DATA  ;
CTRL_TX U0_CTRL_TX (
.CLK(CLK)                                 ,
.RST(RST)                                 ,
.UART_ALU_SEND(UART_ALU_SEND)             ,
.UART_RF_SEND(UART_RF_SEND)               ,
.UART_SEND_RF_DATA(UART_SEND_RF_DATA)     ,
.UART_SEND_ALU_DATA(UART_SEND_ALU_DATA)   ,
.UART_TX_Busy(UART_TX_Busy)               ,
.UART_TX_Valid(UART_TX_Valid)             ,
.UART_TX_DATA (UART_TX_DATA)            
);
CTRL_RX U0_CTRL_RX (
.CLK(CLK)                               ,
.RST(RST)                               ,
.ALU_OUT(ALU_OUT)                       ,
.ALU_OUT_VLD(ALU_OUT_VLD)               ,
.RF_RdData(RF_RdData)                   , 
.RF_RdData_Valid(RF_RdData_Valid)       ,
.UART_RX_DATA(UART_RX_DATA)             ,
.UART_RX_VLD(UART_RX_VLD)               ,
.ALU_EN(ALU_EN)                         ,
.ALU_FUN(ALU_FUN)                       ,
.CLKG_EN(CLKG_EN)                       ,
.RF_Address(RF_Address)                 ,
.RF_WrEn(RF_WrEn)                       ,
.RF_RdEn(RF_RdEn)                       ,
.RF_WrData(RF_WrData)                   ,
.CLK_DIV_EN(CLK_DIV_EN)                 , 
.UART_ALU_SEND(UART_ALU_SEND)           ,
.UART_RF_SEND(UART_RF_SEND)             ,
.UART_SEND_RF_DATA(UART_SEND_RF_DATA)   ,
.UART_SEND_ALU_DATA(UART_SEND_ALU_DATA)
);



    
endmodule