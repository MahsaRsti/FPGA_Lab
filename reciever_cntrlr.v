`define LSB_R 2'b00
`define MSB_R 2'b01
`define FIR_CALC 2'b10
`define OUT_READY 2'b11

module reciever_cntrlr(
    clk,
    rst,
    data_ready,
    input_valid,
    output_valid
);
 input clk,rst,data_ready,output_valid;
 output reg input_valid;
 reg ps,ns;

always @(posedge clk) begin
    if(rst)
    ps=`LSB_R;
    else
    ps=ns;
end

always @(*)
begin
case(ps)
`LSB_R:ns=data_ready ? `MSB_R : `LSB_R;
`MSB_R:ns=data_ready ? `FIR_CALC : `MSB_R;
`FIR_CALC:ns=`OUT_READY;
`OUT_READY:ns=output_valid ? `LSB_R : `OUT_READY;
endcase
end
 
always @(ps) begin
input_valid=0;
case(ps)
//`LSB_R
//`MSB_R
`FIR_CALC:input_valid=1;
//`OUT_READY
endcase
end

endmodule