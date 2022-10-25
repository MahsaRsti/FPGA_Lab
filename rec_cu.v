module rec_cu(input RxD_ready,input TxD_busy,clk,rst,FIR_valid,ff1_Sel,ff2_Sel,FIR_strt);
input clk,rst,FIR_valid;
output reg ff1_Sel,ff2_Sel;

reg [1:0]ns,ps;

parameter [2:0] idle=3'b000,
get_msb=3'b001,
get_lsb=3'b010,
input_valid=3'b011;
always@(posedge clk)begin
    if(rst)
        {ff1_Sel,ff2_Sel,ns,ps,ff1,ff2}<=0;
    else begin
        ps<=ns;
    end
end
always@(posedge clk) begin
    case(ps)
    idle:ns=(RxD_ready==1'b1)?get_msb:idle;
    get_msb:ns=get_lsb;
    get_lsb:ns=(RxD_ready==1'b1)?input_valid:get_lsb;
    input_valid:ns=idle;
endcase
end
always@(posedge clk) begin
    case(ns)
    get_msb:{ff1_Sel,ff1_load}=2'b11;
    get_lsb:{ff1_Sel,ff1_load}=2'b01;
    input_valid:{FIR_strt}=1'b1;
endmodule