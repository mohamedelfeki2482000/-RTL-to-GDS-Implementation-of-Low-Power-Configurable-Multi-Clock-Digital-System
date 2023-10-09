module UART_TX_FSM (
    input wire Data_Valid          ,
    input wire ser_done            ,
    input wire PAR_EN              ,
    input wire clk                 ,
    input wire rst                 ,
    output reg [1:0]  mux_sel      ,
    output reg ser_en              ,
    output reg busy         
);
reg busy_comb                    ;
localparam [2:0] IDLE   = 3'b000 ,
                 START  = 3'b001 ,
                 DATA   = 3'b010 ,
                 PARITY = 3'b011 ,
                 STOP   = 3'b100 ;
reg [2:0] CS,NS                  ;

// current state logic
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        CS<=IDLE ;
    end else begin
        CS<=NS ;
    end
    
end
// next state logic
always @(*) begin
    case (CS)
    IDLE: begin
       if (Data_Valid) begin
        NS=START;
       end else begin
        NS=IDLE;
       end 
        
    end 
    START:begin
        NS=DATA;
    end
    DATA:begin
        if (ser_done && PAR_EN) begin
            NS=PARITY;
        end
        else if (ser_done && (!PAR_EN)) begin
            NS=STOP;
        end
        else begin
            NS=DATA;
        end
        
    end
    PARITY:begin
        NS=STOP;
    end
    STOP:begin
        if (Data_Valid) begin
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
// output logic logic
always @(*) begin
    busy_comb=1'b0   ;
    ser_en   =1'b0   ;
    mux_sel  =2'b11  ; 

    case (CS)
    IDLE: begin
         busy_comb=1'b0   ;
         ser_en   =1'b0   ;
         mux_sel  =2'b11  ; 
    end 
    START:begin
         busy_comb=1'b1   ;
         ser_en   =1'b0   ;
         mux_sel  =2'b00  ; 
    end
    DATA:begin
        busy_comb=1'b1   ;
        ser_en   =1'b1   ;
        mux_sel  =2'b01  ; 
    end
    PARITY:begin
        busy_comb=1'b1   ;
        ser_en   =1'b0   ;
        mux_sel  =2'b10  ; 
    end
    STOP:begin
        busy_comb=1'b1   ;
        ser_en   =1'b0   ;
        mux_sel  =2'b11  ; 
        
    end

        default: begin
           busy_comb=1'b0   ;
           ser_en   =1'b0   ;
           mux_sel  =2'b11  ;  
        end

    endcase
    
end
always @(posedge clk or negedge rst ) begin
    if (!rst) begin 
      busy<=1'b0;  
    end else begin
      busy<=busy_comb;  
    end
    
end
endmodule