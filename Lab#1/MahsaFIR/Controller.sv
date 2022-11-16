`define WAITING 2'd0
`define TAKE_INPUT 2'd1
`define CALCULATING 2'd2
`define OUTPUT_READY 2'd3

module Controller(
    clk,
    rst,
    cnt_cout,
    input_valid,
    output_valid,
    cnt_en,
    regfile_write,
    reg_clr,
    reg_ld
);

input clk,rst,cnt_cout,input_valid;

output reg output_valid,cnt_en,regfile_write,reg_clr,reg_ld;

reg [1:0] ps,ns;

always @(posedge clk) begin
    if(rst)
    ps=`WAITING;
    else
    ps=ns;
end

always @(*)
begin
case(ps)
`WAITING:ns=input_valid ? `TAKE_INPUT : `WAITING;
`TAKE_INPUT:ns=`CALCULATING;
`CALCULATING:ns=cnt_cout?`OUTPUT_READY: `CALCULATING;
`OUTPUT_READY:ns=`WAITING;
endcase
end
 
always @(ps) begin
{output_valid,cnt_en,regfile_write,reg_clr,reg_ld}=5'b00000;
case (ps)
`WAITING: reg_clr=1'b1;
`TAKE_INPUT: regfile_write=1'b1;
`CALCULATING: {cnt_en,reg_ld}=2'b11;
`OUTPUT_READY: output_valid=1'b1;
endcase
end

endmodule