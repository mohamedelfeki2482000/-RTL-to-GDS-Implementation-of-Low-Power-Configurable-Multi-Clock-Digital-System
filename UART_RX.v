module UART_RX #(
    parameter  data_width =4'd8 ,
               prescale_width=3'd5 
) (
    input wire                      clk          ,
    input wire                      rst          ,
    input wire                      RX_IN        ,
    input wire [prescale_width-1:0] Prescale     ,
    input wire                      PAR_EN       ,
    input wire                      PAR_TYP      ,
    output wire                     data_valid   ,
    output wire [data_width-1:0 ]   P_DATA       , 
    output wire                     stp_err      ,
    output wire                     par_err      
);
wire [2:0] edge_cnt   ;
wire [3:0] bit_cnt    ;
wire       sampled_bit;
wire       deser_en   ;
wire       enable     ;
wire       par_chk_en ;
wire       stp_chk_en ;

wire       strt_glitch;
wire       strt_chk_en ;
wire       data_samp_en;
    
data_sampling UART_RX_data_sampling (
.clk(clk),
.rst(rst),
.RX_IN(RX_IN),
.Prescale(Prescale),
.edge_cnt(edge_cnt),
.data_samp_en(data_samp_en),
.sampled_bit(sampled_bit)
);
deserializer UART_RX_deserializer (
.clk(clk),
.rst(rst),
.deser_en(deser_en),
.sampled_bit(sampled_bit),
.edge_cnt(edge_cnt),
.P_DATA(P_DATA)
);
edge_bit_counter UART_RX_edge_bit_counter (
.clk(clk),
.rst(rst),
.enable(enable),
.bit_cnt(bit_cnt),
.edge_cnt(edge_cnt)
);
parity_Check UART_RX_parity_Check (
.clk(clk),
.rst(rst),
.P_DATA(P_DATA),
.par_chk_en(par_chk_en),
.sampled_bit(sampled_bit),
.PAR_TYP(PAR_TYP),
.par_err(par_err)
);
Stop_Check UART_RX_Stop_Check (
.clk(clk),    
.rst(rst),
.stp_chk_en(stp_chk_en),
.sampled_bit(sampled_bit),
.stp_err(stp_err)
);
strt_Check UART_RX_strt_Check (
.clk(clk),
.rst(rst),
.strt_glitch(strt_glitch),
.sampled_bit(sampled_bit),
.strt_chk_en(strt_chk_en)
);
UART_RX_FSM UART_RX_FSM ( 
.clk(clk),
.rst(rst),
.RX_IN(RX_IN),
.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt),
.PAR_EN(PAR_EN),
.strt_glitch(strt_glitch),
.par_err(par_err),
.stp_err(stp_err),
.par_chk_en(par_chk_en),
.enable(enable),
.data_samp_en(data_samp_en),
.strt_chk_en(strt_chk_en),
.stp_chk_en(stp_chk_en),
.deser_en(deser_en),
.data_valid(data_valid)
);
endmodule