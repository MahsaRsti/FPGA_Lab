module UART(
    CLOCK_50,
    KEY,
    SW,
    UART_RXD,
    UART_TXD,
    LEDR
);

    input CLOCK_50;
    input [0:0] KEY;		
    input [3:0] SW;
    input UART_RXD;

    output UART_TXD;
    output [16:0] LEDR;

    wire [7:0] RxD_data;
    wire TxD_busy, RxD_data_ready;

    async_receiver AR(
        .rst(KEY),
        .clk(CLOCK_50),
        .RxD(UART_RXD),
        .RxD_data_ready(RxD_data_ready),
        .RxD_data(RxD_data)
    );
    async_transmitter AT(
        .clk(CLOCK_50),
        .TxD_start(SW[0]),
        .[7:0] TxD_data(RxD_data),
        .TxD(UART_TXD),
        .TxD_busy(TxD_busy)
    );

    assign LEDR[17:10] = RxD_data;

endmodule