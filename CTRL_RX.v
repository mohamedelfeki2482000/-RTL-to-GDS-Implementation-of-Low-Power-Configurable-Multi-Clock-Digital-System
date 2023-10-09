module CTRL_RX #(
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
    output reg                    ALU_EN              ,
    output reg [3:0]              ALU_FUN             ,
    output reg                    CLKG_EN             ,
    output reg [Addr_width-1:0]   RF_Address          ,
    output reg                    RF_WrEn             ,
    output reg                    RF_RdEn             ,
    output reg [data_Width-1:0]   RF_WrData           ,
    output reg                    CLK_DIV_EN          , 
    output reg                    UART_ALU_SEND       ,
    output reg                    UART_RF_SEND        ,
    output reg [data_Width-1:0]   UART_SEND_RF_DATA   ,
    output reg [2*data_Width-1:0] UART_SEND_ALU_DATA
);
localparam [3:0]   IDLE        =4'b0000               ,
                   READ_ADDR   =4'b0001               ,
                   READ_WAIT   =4'b0010               ,
                   WRITE_ADDR  =4'b0011               ,
                   OPERAND_1   =4'b0100               ,
                   OPERAND_2   =4'b0101               ,
                   ALU_OUT_WAIT=4'b0110               ,
                   ALU_FUNC    =4'b0111               ,
                   WRITE_DATA  =4'b1000               ; 

localparam [7:0]   RF_Wr_CMD         =8'hAA     ,
                   RF_Rd_CMD         =8'hBB     ,
                   ALU_OPER_W_OP_CMD =8'hCC     ,
                   ALU_OPER_W_NOP_CMD=8'hDD     ;

 reg [data_Width-1:0] RF_Address_REG  ;
 reg                  ALU_STORE_DATA  ;
 reg                  RF_READ_STORE   ;
 reg                  RF_ADDR_EN      ; 
 reg [3:0] CS,NS ;

//current state logic
always @(posedge CLK or negedge RST ) begin
    if (!RST) begin
        CS<=IDLE;
    end else begin
        CS<=NS;
    end
    
end
//next state combintial logic
always @(*) begin
    case (CS)
    IDLE            : begin
        if (UART_RX_VLD) begin
            case (UART_RX_DATA)
            RF_Wr_CMD            : begin
                NS=WRITE_ADDR;    
                end
            RF_Rd_CMD            :  begin
                NS=READ_ADDR;    
                end
            ALU_OPER_W_OP_CMD    : begin
                NS=OPERAND_1;  
                end
            ALU_OPER_W_NOP_CMD    : begin
                NS=ALU_FUNC;    
                end
                default: begin
                    NS=IDLE;
                end

            endcase


            
        end else begin
            NS=IDLE;
        end
        
    end
    READ_ADDR       : begin
        if (UART_RX_VLD) begin
            NS=READ_WAIT;
        end else begin
            NS=READ_ADDR;
        end
        
    end

    READ_WAIT       : begin
        if (RF_RdData_Valid) begin
            NS=IDLE;
        end else begin
            NS=READ_WAIT;
        end
        
    end
    WRITE_ADDR      : begin 
        if (UART_RX_VLD) begin
            NS=WRITE_DATA;
        end else begin
            NS=WRITE_ADDR;
        end
        
    end
    OPERAND_1       : begin
        if (UART_RX_VLD) begin
            NS=OPERAND_2  ;
        end else begin
            NS=OPERAND_1  ;
        end
        
    end
    OPERAND_2       : begin
       if (UART_RX_VLD) begin
            NS=ALU_FUNC;
       end else begin
            NS=OPERAND_2;        
       end
        
    end 
    ALU_OUT_WAIT    : begin
       if(ALU_OUT_VLD)
			       begin
			        NS = IDLE ; 				
                   end
			     else
			       begin
			        NS = ALU_OUT_WAIT ; 			
                   end			  
    end
    ALU_FUNC         : begin
        if (UART_RX_VLD) begin
            NS=ALU_OUT_WAIT;
        end else begin
            NS=ALU_FUNC     ;
        end
        
    end 
    WRITE_DATA      : begin
        if (UART_RX_VLD) begin
            NS=IDLE;
        end else begin
            NS=WRITE_DATA;
        end
        
    end 
        default: begin
            NS=IDLE;
        end 
    endcase
    
    
end
 // output logic
 always @(*) begin
    ALU_EN =1'b0  ;
    ALU_FUN=4'b0  ;
    CLKG_EN=1'b0  ;
    RF_Address='b0;
    RF_WrEn=1'b0  ;
    RF_RdEn=1'b0  ;
    RF_WrData='b0 ;
    CLK_DIV_EN=1'b1;
    UART_ALU_SEND=1'b0;
    UART_RF_SEND=1'b0;
    ALU_STORE_DATA=1'b0;
    RF_READ_STORE=1'b0;
    RF_ADDR_EN=1'b0; 

    case (CS)
    IDLE         : begin
    ALU_EN =1'b0  ;
    ALU_FUN=4'b0  ;
    CLKG_EN=1'b0  ;
    RF_Address='b0;
    RF_WrEn=1'b0  ;
    RF_RdEn=1'b0  ;
    RF_WrData='b0 ;
    CLK_DIV_EN=1'b1;
    UART_ALU_SEND=1'b0;
    UART_RF_SEND=1'b0;
    ALU_STORE_DATA=1'b0;
    RF_READ_STORE=1'b0;
    RF_ADDR_EN=1'b0; 
        
    end
    READ_ADDR    : begin
        if (UART_RX_VLD) begin
          RF_ADDR_EN=1'b1;  
        end else begin
          RF_ADDR_EN=1'b0;  
        end
        
    end
    READ_WAIT    : begin
        RF_RdEn=1'b1;
        RF_Address=RF_Address_REG;
        if (RF_RdData_Valid) begin
            RF_READ_STORE=1'b1;
            UART_RF_SEND =1'b1;
        end else begin
            RF_READ_STORE=1'b0;
            UART_RF_SEND=1'b0;
        end
        
    end
    WRITE_ADDR   : begin
        if (UART_RX_VLD) begin
         RF_ADDR_EN=1'b1;
        end else begin
         RF_ADDR_EN=1'b0;   
        end
        
    end
    OPERAND_1    : begin
        if (UART_RX_VLD) begin
         RF_Address='b0000;
         RF_WrEn='b1;
         RF_WrData=UART_RX_DATA;   
        end else begin
         RF_Address='b0000;
         RF_WrEn='b1;
         RF_WrData=UART_RX_DATA; 
            
        end
        
    end
    OPERAND_2    : begin
        if (UART_RX_VLD) begin
         RF_Address='b0001;
         RF_WrEn='b1;
         RF_WrData=UART_RX_DATA;   
        end else begin
         RF_Address='b0001;
         RF_WrEn='b1;
         RF_WrData=UART_RX_DATA; 
            
        end

    end
    ALU_OUT_WAIT : begin
        CLKG_EN=1'b1;
        if (ALU_OUT_VLD) begin
            UART_ALU_SEND=1'b1;
            ALU_STORE_DATA=1'b1;
        end else begin
            UART_ALU_SEND=1'b0;
            ALU_STORE_DATA=1'b0;
        end
        
    end
    ALU_FUNC      : begin
        CLKG_EN=1'b1;
        if (UART_RX_VLD) begin
            ALU_FUN=UART_RX_DATA;
            ALU_EN=1'b1;
        end else begin
            ALU_FUN=UART_RX_DATA;
            ALU_EN=1'b0;
        end
        
    end
    WRITE_DATA   : begin
        if (UART_RX_VLD) begin
            RF_WrEn=1'b1;
            RF_WrData=UART_RX_DATA;
            RF_Address=RF_Address_REG;
            
        end else begin
            RF_WrEn=1'b0;
            RF_WrData=UART_RX_DATA;
            RF_Address=RF_Address_REG;
        end
        
    end
    

        default: begin
             ALU_EN =1'b0  ;
             ALU_FUN=4'b0  ;
             CLKG_EN=1'b0  ;
             RF_Address='b0;
             RF_WrEn=1'b0  ;
             RF_RdEn=1'b0  ;
             RF_WrData='b0 ;
             CLK_DIV_EN=1'b1;
             UART_ALU_SEND=1'b0;
             UART_RF_SEND=1'b0;
             ALU_STORE_DATA=1'b0;
             RF_READ_STORE=1'b0;
             RF_ADDR_EN=1'b0;    
        end 
    endcase
    
 end
// address filp flop
always @(posedge CLK or negedge RST ) begin
    if (!RST) begin
        RF_Address_REG<='b0;
    end 
    else begin
        if (RF_ADDR_EN) begin
            RF_Address_REG<=UART_RX_DATA;
        end
    end 
    
    
end
    
// ALU OUT flip flop

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        UART_SEND_ALU_DATA<='b0;
    end
    else begin
        if(ALU_STORE_DATA) begin
          UART_SEND_ALU_DATA<=ALU_OUT;  
        end
    end
    
end
//RF READ flip flop
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        UART_SEND_RF_DATA<='b0;
    end
    else begin
        if(RF_READ_STORE) begin
          UART_SEND_RF_DATA<=RF_RdData;  
        end
    end
end












    
endmodule