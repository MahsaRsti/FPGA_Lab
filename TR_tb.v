module TB_TR();
reg clk=0;
reg start,rst;
reg [7:0]data;
wire xD,TxD_busy,RxD_data_ready;
wire [7:0] RxD_data;
async_receiver AR(
    rst,
    clk,
    xD,
    RxD_data_ready,
    RxD_data  
);
async_transmitter AT(
    clk,
    start,
    data,
    xD,
    TxD_busy
);
initial begin
    #5 rst=1;
    #40 rst=0;
    #5 data=8'b01011000;
    #5 start=1'b1;
    #60 start=1'b0;
end
always #20 clk=~clk;
endmodule