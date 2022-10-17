module TB();
reg clk=0;
reg start;
reg [7:0]data;
wire xD,TxD_busy,tick_r,tick_t;
wire [7:0] RxD_data;
async_receiver AR(
    clk,
    xD,
    RxD_data_ready,
    RxD_data  // data received, valid only (for one clock cycle) when RxD_data_ready is asserted
);
async_transmitter AT(
    clk,
    start,
    data,
    xD,
    TxD_busy
);
initial begin
    #5 data=8'b01011000;
    #5 start=1'b1;
    #60 start=1'b0;

end
always #20 clk=~clk;

endmodule