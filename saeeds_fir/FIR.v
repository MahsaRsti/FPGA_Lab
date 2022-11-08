module FIR #(parameter inwidth=16,outwidth=38,coefnum=64,logcoefnum=6)(clock,reset,input_valid,FIR_input,output_valid,FIR_output);
input input_valid,clock,reset;
input [inwidth-1:0]FIR_input;
output output_valid;
output [outwidth-1:0]FIR_output;

wire load,loadres,clr_res,cnt_en,cnt_co;


DataPath #(inwidth,outwidth,coefnum,logcoefnum) DP (
    clock,
    reset,
    loadres,
    load,
    clr_res,
    cnt_en,
    FIR_input,
    cnt_co,
    FIR_output
);

ControlUnit CU(clock,reset,input_valid,cnt_co,cnt_en,load,loadres,clr_res,output_valid);


endmodule