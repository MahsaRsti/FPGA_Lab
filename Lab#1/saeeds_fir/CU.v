module ControlUnit (clock,reset,input_valid,cnt_co,cnt_en,load,loadres,clr_res,output_valid);
input clock,reset,input_valid,cnt_co;
output reg cnt_en,output_valid,load,loadres,clr_res;
reg[1:0] ps,ns;
parameter [1:0] wait_input=2'b00,
getX=2'b01,
calc=2'b10,
finish=2'b11;

always @(posedge clock,posedge reset) begin
    if(reset)
        ps<=wait_input;
    else
        ps<=ns;
end
always @(*) begin
    case(ps)
    wait_input:ns=(input_valid)?getX:wait_input;
    getX:ns=calc;
    calc:ns=(cnt_co==1'b1)?finish:calc;
    finish:ns=wait_input;
    endcase
end
always@(ps) begin
    {cnt_en,output_valid,load,loadres,clr_res}=5'b00000;
    case(ps)
    wait_input:clr_res=1'b1;
    getX:load=1'b1;
    calc:{loadres,cnt_en}=2'b11;
    finish:output_valid=1'b1;
    endcase
end
endmodule