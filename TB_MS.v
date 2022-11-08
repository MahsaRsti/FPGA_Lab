module TB();
reg clk=0;
reg start,rst,xD;
reg [7:0]data;
wire TxD_busy;
wire TXD;
// async_receiver AR(
//     rst,
//     clk,
//     xD,
//     RxD_data_ready,
//     TXD  // data received, valid only (for one clock cycle) when RxD_data_ready is asserted
// );
LAB1_top test(clk, rst,, xD, TXD,);
// async_transmitter AT(
//     clk,
//     start,
//     data,
//     xD,
//     TxD_busy
// );
initial begin
    #5 rst=1'b1;
    #5 xD=1'b1;
    #30 rst=1'b0;
    // #5 data=8'b01011000;
    // #5 start=1'b1;
    // #60 start=1'b0;
    #17280 xD=1'b0;
    #17280 xD=1'b1;
    #17280 xD=1'b0;
    #17280 xD=1'b1;
    #17280 xD=1'b1;
    #17280 xD=1'b0;
    #17280 xD=1'b0;
    #17280 xD=1'b1;
    #17280 xD=1'b1;
    #17280 xD=1'b0;
    #17280 xD=1'b1; // first 8 bit finished
    #17280 xD=1'b0;
    #17280 xD=1'b0;
    #17280 xD=1'b0;
    #17280 xD=1'b1;
    #17280 xD=1'b1;
    #17280 xD=1'b0;
    #17280 xD=1'b0;
    #17280 xD=1'b1;
    #17280 xD=1'b1;
    #17280 xD=1'b0;
    #17280 xD=1'b1;
    #17280 xD=1'b0;
    #17280 xD=1'b1;

end
always #20 clk=~clk;

endmodule