module UART_RX_FSM (
    input wire       clk          ,
    input wire       rst          ,
    input wire       RX_IN        ,
    input wire [2:0] edge_cnt     ,
    input wire [3:0] bit_cnt      ,
    input wire       PAR_EN       ,
    input wire       strt_glitch  ,
    input wire       par_err      ,
    input wire       stp_err      ,
    output reg       par_chk_en   ,
    output reg       enable       ,
    output reg       data_samp_en ,
    output reg       strt_chk_en  ,
    output reg       stp_chk_en   ,
    output reg       deser_en     ,
    output reg       data_valid   
);
localparam [2:0]  IDLE     =3'b000 ,
                  START    =3'b001 ,
                  DATA     =3'b010 ,
                  PARITY   =3'b011 ,
                  STOP     =3'b100 ,
                  ERR_CHK  =3'b101 ,
                  DATA_VLD =3'b110 ;
reg [2:0] CS , NS ;
//state transition
always @(posedge clk or negedge rst ) begin
    if (!rst) begin
        CS<=IDLE;
    end
    else begin
        CS<=NS;
    end
end
//next state logic 
always @(*) begin
    case (CS)
    IDLE      : begin
        if (!RX_IN) begin
           NS=START; 
        end 
        else begin
           NS=IDLE; 
        end
        
    end
    START     : begin
        if (bit_cnt==4'd0 && edge_cnt==3'd7) begin
            if(!strt_glitch) begin
             NS=DATA;
            end
            else begin
             NS=IDLE;   
            end

        end
        else begin
            NS=START;
        end
        
    end
    DATA      : begin
        if (bit_cnt==4'd8 && edge_cnt==3'd7 ) begin
            if (PAR_EN) begin
              NS=PARITY;  
            end else begin
              NS=STOP  ;  
            end
            
        end 
        else begin
            NS=DATA  ;
        end

    end
    PARITY    : begin
        if (bit_cnt==4'd9 && edge_cnt==3'd7 ) begin
            NS=STOP;
        end 
        else begin
            NS=PARITY;
        end
        
    end
    STOP      : begin
        if ((bit_cnt==4'd9 || bit_cnt==4'd10) && edge_cnt==3'd5 ) begin
            NS=ERR_CHK;
        end 
        else begin
            NS=STOP;
        end
        
    end
    ERR_CHK   : begin
        if (par_err || stp_err ) begin
            NS=IDLE;
        end else begin
            NS=DATA_VLD;
        end
        
    end
    DATA_VLD  : begin
        if (!RX_IN) begin
            NS=START;
        end else begin
            NS=IDLE;
        end
    end

        default: begin
           NS=IDLE; 
        end 
    endcase
    
end                     

//output logic
always @(*) begin
    par_chk_en  =1'b0;
    enable      =1'b0;
    data_samp_en=1'b0;
    strt_chk_en =1'b0;
    stp_chk_en  =1'b0;
    deser_en    =1'b0;
    data_valid  =1'b0;
    case (CS)
    IDLE      : begin
        if (!RX_IN) begin
           par_chk_en  =1'b0;
           enable      =1'b1;
           data_samp_en=1'b1;
           strt_chk_en =1'b1;
           stp_chk_en  =1'b0;
           deser_en    =1'b0;
           data_valid  =1'b0;
            
        end else begin
           par_chk_en  =1'b0;
           enable      =1'b0;
           data_samp_en=1'b0;
           strt_chk_en =1'b0;
           stp_chk_en  =1'b0;
           deser_en    =1'b0;
           data_valid  =1'b0;
        end
        
    end
    START     : begin
           par_chk_en  =1'b0;
           enable      =1'b1;
           data_samp_en=1'b1;
           strt_chk_en =1'b1;
           stp_chk_en  =1'b0;
           deser_en    =1'b0;
           data_valid  =1'b0;
        
    end
    DATA      : begin
           par_chk_en  =1'b0;
           enable      =1'b1;
           data_samp_en=1'b1;
           strt_chk_en =1'b0;
           stp_chk_en  =1'b0;
           deser_en    =1'b1;
           data_valid  =1'b0;
        
    end
    PARITY    : begin
           par_chk_en  =1'b1;
           enable      =1'b1;
           data_samp_en=1'b1;
           strt_chk_en =1'b0;
           stp_chk_en  =1'b0;
           deser_en    =1'b0;
           data_valid  =1'b0;
        
    end
    STOP      : begin
           par_chk_en  =1'b0;
           enable      =1'b1;
           data_samp_en=1'b1;
           strt_chk_en =1'b0;
           stp_chk_en  =1'b1;
           deser_en    =1'b0;
           data_valid  =1'b0;
        
    end
    ERR_CHK   : begin
           par_chk_en  =1'b0;
           enable      =1'b0;
           data_samp_en=1'b1;
           strt_chk_en =1'b0;
           stp_chk_en  =1'b0;
           deser_en    =1'b0;
           data_valid  =1'b0;
        
    end
    DATA_VLD  : begin

           par_chk_en  =1'b0;
           enable      =1'b0;
           data_samp_en=1'b0;
           strt_chk_en =1'b0;
           stp_chk_en  =1'b0;
           deser_en    =1'b0;
           data_valid  =1'b1;
    end

        default: begin
             par_chk_en  =1'b0;
             enable      =1'b0;
             data_samp_en=1'b0;
             strt_chk_en =1'b0;
             stp_chk_en  =1'b0;
             deser_en    =1'b0;
             data_valid  =1'b0;
            
        end 
    endcase   
end                     

endmodule