module SYS_TOP #(
    parameter data_width =8 ,
              Prescale_width=32,
              Addr_width=4 
) (
    input wire RST_N        ,
    input wire REF_CLK      ,
    input wire UART_CLK     ,
    input wire RX_IN        ,
    output wire TX_OUT      ,
    output wire par_err     ,
    output wire stp_err     
);
wire SYNC_UART_RST ;
wire SYNC_REF_RST  ;
wire UART_TX_CLK   ;
wire [data_width-1:0] UART_RX_OUT   ;
wire UART_RX_V_OUT;
wire [data_width-1:0] UART_RX_SYNC;
wire UART_RX_V_SYNC;
wire UART_TX_Busy;
wire UART_TX_Busy_SYNC;
wire CLK_DIV_EN;
wire [data_width-1:0] UART_Config;
wire [data_width-1:0] DIV_RATIO;
wire [data_width-1:0] UART_TX_IN;
wire UART_TX_VLD;
wire [data_width-1:0] UART_TX_SYNC;
wire UART_TX_V_SYNC;
wire [2*data_width-1:0] ALU_OUT;
wire ALU_OUT_VLD               ;
wire ALU_EN                    ;
wire [3:0] ALU_FUN             ;
wire [data_width-1:0] RF_RdData;
wire RF_RdData_Valid;
wire CLKG_EN;
wire [Addr_width-1:0] RF_Address;
wire RF_RdEn;
wire RF_WrEn;
wire [data_width-1:0] RF_WrData;
wire ALU_CLK;
wire [data_width-1:0] OPERAND_A;
wire [data_width-1:0] OPERAND_B;



//reset synchronizer
RST_SYNC U0_RST_SYNC (
.RST(RST_N),
.CLK(UART_CLK),
.SYNC_RST(SYNC_UART_RST)
);
RST_SYNC U1_RST_SYNC (
.RST(RST_N),
.CLK(REF_CLK),
.SYNC_RST(SYNC_REF_RST)
);
//DATA synchronizer
DATA_SYNC U0_DATA_SYNC (
.dest_clk(REF_CLK),
.dest_rst(SYNC_REF_RST),
.unsync_bus(UART_RX_OUT),
.bus_enable(UART_RX_V_OUT),
.sync_bus(UART_RX_SYNC),
.enable_pulse_d(UART_RX_V_SYNC)
);

DATA_SYNC U1_DATA_SYNC (
.dest_clk(UART_TX_CLK),
.dest_rst(SYNC_UART_RST),
.unsync_bus(UART_TX_IN),
.bus_enable(UART_TX_VLD),
.sync_bus(UART_TX_SYNC),
.enable_pulse_d(UART_TX_V_SYNC)
);
//bit synchronizer
BIT_SYNC U0_BIT_SYNC (
.dest_clk(REF_CLK),
.dest_rst(SYNC_REF_RST),
.unsync_bit(UART_TX_Busy),
.sync_bit(UART_TX_Busy_SYNC)
);
//Clock divider
 ClkDiv U0_ClkDiv (
.i_ref_clk(UART_CLK),             
.i_rst(SYNC_UART_RST),                 
.i_clk_en(CLK_DIV_EN),               
.i_div_ratio(DIV_RATIO[3:0]),            
.o_div_clk(UART_TX_CLK)               
 );
 //UART
 UART U0_UART (
.TX_CLK(UART_TX_CLK)            ,
.RX_CLK(UART_CLK)               ,
.RST(SYNC_UART_RST)             ,
.RX_IN(RX_IN)                   ,
.TX_IN(UART_TX_SYNC)            ,
.TX_IN_V(UART_TX_V_SYNC)        ,
.PAR_EN(UART_Config[0])         ,
.PAR_TYP(UART_Config[1])        ,
.Prescale(UART_Config[6:2])     ,
.RX_OUT_V(UART_RX_V_OUT)        ,
.RX_OUT(UART_RX_OUT)            ,
.stp_err(stp_err)               ,
.par_err(par_err)               ,
.TX_OUT(TX_OUT)                 ,
.TX_OUT_V(UART_TX_Busy)                      
 );
 //system controller 
 SYS_CTRL U0_SYS_CTRL (
.CLK(REF_CLK)                           ,
.RST(SYNC_REF_RST)                      ,
.ALU_OUT(ALU_OUT)                       ,
.ALU_OUT_VLD(ALU_OUT_VLD)               ,
.RF_RdData(RF_RdData)                   , 
.RF_RdData_Valid(RF_RdData_Valid)       ,
.UART_RX_DATA(UART_RX_SYNC)             ,
.UART_RX_VLD(UART_RX_V_SYNC)            ,
.UART_TX_Busy(UART_TX_Busy_SYNC)        ,
.ALU_EN(ALU_EN)                         ,
.ALU_FUN(ALU_FUN)                       ,
.CLKG_EN(CLKG_EN)                       ,
.RF_Address(RF_Address)                 ,
.RF_WrEn(RF_WrEn)                       ,
.RF_RdEn(RF_RdEn)                       ,
.RF_WrData(RF_WrData)                   ,
.CLK_DIV_EN(CLK_DIV_EN)                 ,  
.UART_TX_Valid(UART_TX_VLD)             ,
.UART_TX_DATA(UART_TX_IN)        
);
//Reg File
RegFile U0_RegFile (
.CLK(REF_CLK),
.RST(SYNC_REF_RST),
.WrEn(RF_WrEn),
.RdEn(RF_RdEn),
.Address(RF_Address),
.WrData(RF_WrData),
.RdData(RF_RdData),
.RdData_VLD(RF_RdData_Valid),
.REG0(OPERAND_A),
.REG1(OPERAND_B),
.REG2(UART_Config),
.REG3(DIV_RATIO)
);
//ALU
ALU U0_ALU (
.A(OPERAND_A), 
.B(OPERAND_B),
.EN(ALU_EN),
.ALU_FUN(ALU_FUN),
.CLK(ALU_CLK),
.RST(SYNC_REF_RST),  
.ALU_OUT(ALU_OUT),
.OUT_VALID(ALU_OUT_VLD)
);
CLK_GATE U0_CLK_GATE (
.CLK_EN(CLKG_EN),
.CLK(REF_CLK),
.GATED_CLK(ALU_CLK)

);







    
endmodule