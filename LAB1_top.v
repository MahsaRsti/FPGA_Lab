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
transmitter_cntrlr TX_CU(.clk(CLOCK_50),.rst(KEY),output_valid,TX_busy,TX_start);

reciever_cntrlr RX_CU(.clk(CLOCK_50),.rst(KEY),data_ready,input_valid,output_valid);

 async_transmitter TX(.clk(CLOCK_50),TxD_start,TxD_data,TxD,TxD_busy);

async_receiver RX(.clk(CLOCK_50),RxD,RxD_data_ready = 0,RxD_data = 0);
////////////////////////////////

endmodule
