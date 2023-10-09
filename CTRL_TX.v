module CTRL_TX #(
    parameter  data_Width =8 ,
               Addr_width =4 
) (
    input wire                    CLK                 ,
    input wire                    RST                 ,
    input wire                    UART_ALU_SEND       ,
    input wire                    UART_RF_SEND        ,
    input wire [data_Width-1:0]   UART_SEND_RF_DATA   ,
    input wire [2*data_Width-1:0] UART_SEND_ALU_DATA  ,
    input wire                    UART_TX_Busy        ,
    output reg                    UART_TX_Valid       ,
    output reg [data_Width-1:0]   UART_TX_DATA                
);
localparam [2:0] IDLE      =3'b000                ,
                 OPERAND_1 =3'b001                ,
                 OPERAND_2 =3'b010                ,
                 WAIT      =3'b011                ,
                 READ      =3'b100                ;
reg [2:0] CS_TX , NS_TX ;
//current state logic
always @(posedge CLK or negedge RST ) begin
if (!RST) begin
    CS_TX<=IDLE;
end else begin
    CS_TX<=NS_TX;
end 

end

// next state logic
always @(*) begin
    case (CS_TX)

    IDLE     : begin
        if (UART_ALU_SEND) begin
            NS_TX=OPERAND_1;
        end
        else if (UART_RF_SEND) begin
            NS_TX=READ;
        end
        else begin
            NS_TX=IDLE     ;
            
        end
        
    end
    OPERAND_1: begin
        if (UART_TX_Busy) begin
            NS_TX=WAIT;
        end else begin
            NS_TX=OPERAND_1;
        end
        
    end
    OPERAND_2: begin
        if (UART_TX_Busy) begin
            NS_TX=IDLE;
        end else begin
            NS_TX=OPERAND_2;
        end

        
    end
    WAIT     : begin
         if (!UART_TX_Busy) begin
            NS_TX=OPERAND_2;
        end else begin
            NS_TX=WAIT;
        end
        
    end
    READ     : begin
        if (UART_TX_Busy) begin
            NS_TX=IDLE;
        end else begin
            NS_TX=READ;
        end
    end 
        default: begin
            NS_TX=IDLE;
        end 
    endcase
    
end
// output logic
always @(*) begin
    case (CS_TX)
    IDLE      : begin
        UART_TX_Valid=1'b0;
        UART_TX_DATA='b0  ;
    end
    OPERAND_1 : begin
        UART_TX_Valid=1'b1;
        UART_TX_DATA=UART_SEND_ALU_DATA[data_Width-1:0];
    end
    OPERAND_2 : begin
       UART_TX_Valid=1'b1;
       UART_TX_DATA=UART_SEND_ALU_DATA[2*data_Width-1:data_Width]; 
    end
    WAIT      : begin
        UART_TX_Valid=1'b0;
        UART_TX_DATA ='b0 ;
        
    end
    READ      : begin
        UART_TX_Valid=1'b1;
        UART_TX_DATA=UART_SEND_RF_DATA;
        
    end 
        default: begin
            UART_TX_Valid=1'b0;
            UART_TX_DATA ='b0 ;
        end
    endcase
    
end

    
endmodule