module LAB1_top(CLOCK_50, KEY, SW, UART_RXD, UART_TXD, LEDR);

input CLOCK_50;
input [0:0] KEY;		//reset key
input [3:0] SW;
output [15:0] LEDR;

input UART_RXD;
output UART_TXD;

parameter ClkFrequency = 50000000;
parameter Baud = 115200;
parameter Oversampling = 4;


////////////////////////////////
//Place your controller here
// transmitter_cntrlr TX_CU(.clk(CLOCK_50),.rst(KEY),output_valid,TX_busy,TX_start);
reg [15:0] ff1, ff2;
reg [7:0] uart_out_reg;
wire [7:0] uart_in,uart_out;
wire input_valid,output_valid,TxD_busy,TxD_start,RxD_ready;
wire [15:0]FIR_input;
wire [37:0]FIR_output;
 wire ff1_Sel,ff2_Sel,ff2_load,ff1_load;

FIR #(16,38,64,6) FF(CLOCK_50,KEY,input_valid,FIR_input,output_valid,FIR_output);
trn_cu  CU1 (TxD_busy,CLOCK_50,KEY,output_valid,ff2_Sel,ff2_load,TxD_start);
rec_cu  CU2 (RxD_ready,CLOCK_50,KEY,ff1_Sel,ff1_load,input_valid);
async_receiver AR(
    KEY,
    CLOCK_50,
    UART_RXD,
    RxD_ready,
    uart_in  // data received, valid only (for one clock cycle) when RxD_data_ready is asserted
);

async_transmitter AT(
    CLOCK_50,
    TxD_start,
    uart_out,
    UART_TXD,
    TxD_busy
);

 //FIR 
 always @(posedge CLOCK_50) begin
    if(KEY) begin ff1 <= 0; ff2 <= 0; end
    else begin
        if(ff1_load)begin
            if(ff1_Sel)
                ff1[15:8]=uart_in;
            else
                ff1[7:0]=uart_in;
        end
        if(ff2_load)
            ff2=FIR_output[23:8];
        if(ff2_Sel)
            uart_out_reg=ff2[15:8];
        else
            uart_out_reg=ff2[7:0];
    end
    
 end

assign uart_out=uart_out_reg;
assign LEDR=ff1;
assign FIR_input=ff1;
// async_receiver RX(.clk(CLOCK_50),RxD,RxD_data_ready = 0,RxD_data = 0);
////////////////////////////////

endmodule
