module UART(CLOCK_50, KEY, SW, UART_RXD, UART_TXD, LEDR);

input CLOCK_50;
input [0:0] KEY;		
input [3:0] SW;
input UART_RXD;
output UART_TXD;
output [16:0] LEDR;
wire [7:0] RxD_data;
wire TxD_busy,RxD_data_ready;

async_receiver AR(
    KEY,
    CLOCK_50,
    UART_RXD,
    RxD_data_ready,
    RxD_data  
);
async_transmitter AT(
    CLOCK_50,
    SW[0],
    RxD_data,
    UART_TXD,
    TxD_busy
);

assign LEDR[17:10]=RxD_data;
