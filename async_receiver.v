module async_receiver(
    input clk,
    input RxD,
    output reg RxD_data_ready = 0,
    output reg [7:0] RxD_data = 0  // data received, valid only (for one clock cycle) when RxD_data_ready is asserted
);

parameter ClkFrequency = 50000000;
parameter Baud = 115200;
parameter Oversampling = 4;	// needs to be a power of 2

////////////////////////////////
//place your code here
wire RxDTick,RxD_busy;
reg [1:0] count;
reg [2:0] bit_num=0;
BaudTickGen #(ClkFrequency, Baud, Oversampling) tickgen(.clk(clk), .enable(RxD_busy), .tick(RxDTick));

//reg [3:0] RxD_state = 0;
//wire RxD_ready = (RxD_state==0);
assign RxD_busy = ~RxD_data_ready;

always @(posedge clk) begin
    if (RxDTick & count<2'b10) begin
        count<=count+1;
    end
    else if(RxDTick & count==2'b10) begin
        RxD_data[bit_num]<=RxD;
        count<=0;
        bit_num<=bit_num+1;
    end

end

////////////////////////////////

endmodule
