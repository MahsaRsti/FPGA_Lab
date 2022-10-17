`define WAITING 3'b000
`define LSB_T 3'b001
`define TX1 3'b010
`define MSB_T 3'b011
`define TX2  3'b100

module transmitter_cntrlr(
    clk,
    rst,
    output_valid,
    TX_busy,
    TX_start
);
input clk, rst,output_valid,TX_busy;
output TX_start;
reg ps,ns;

always @(posedge clk) begin
    if(rst)
    ps=`WAITING;
    else
    ps=ns;
end

always @(*)
begin
case(ps)
`WAITING:ns=output_valid ? `LSB_T : `WAITING;
`LSB_T:ns=`TX1;
`TX1:ns=TX_busy ? `TX1 : `MSB_T;
`MSB_T:ns=`TX2;
`TX2:TX_busy ? `TX2 : `WAITING;
endcase
end
 
always @(ps) begin
TX_start=0;
case(ps)
//`WAITING
`LSB_T: TX_start=1;
//`TX1:input_valid;
`MSB_T: TX_start=1;
//`TX2
endcase
end
endmodule
