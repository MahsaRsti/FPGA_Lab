module DataPath #(parameter inwidth=16,outwidth=38,coefnum=64,logcoefnum=6)(
    clock,
    reset,
    loadres,
    load,
    clr_res,
    cnt_en,
    in,
    cnt_co,
    out
);
input clock , reset,load,loadres,cnt_en,clr_res;
input [inwidth-1:0] in;
output cnt_co;
output [outwidth-1:0]out;
wire[outwidth-1:0] adder_out,resault;
wire signed [2*inwidth-1:0] mult_out;
wire signed [inwidth-1:0]X_k,coef;
wire signed [outwidth-1:0] adder_in1;
wire[inwidth-1:0]X[0:coefnum-1];
wire [logcoefnum-1:0]adr;

counter #(logcoefnum)CNT(clock,reset,cnt_en,adr,cnt_co);
Register #(outwidth) R1(adder_out,clr_res,loadres,clock,resault);
Adder #(outwidth) ADDER1(resault,adder_in1,,adder_out);
Multiplier #(inwidth) mult1(coef,X_k,mult_out);
Register #(inwidth) i0(in,reset,load,clock,X[0]);
// CoefMem #(inwidth,coefnum,logcoefnum) CM(adr,coef);
coeffrom CM(adr,clock,coef);
genvar i;
generate
    for(i=1;i<coefnum;i=i+1) begin : regs
    Register #(inwidth) II(X[i-1],reset,load,clock,X[i]);
    end
endgenerate
assign X_k=X[adr];
assign adder_in1={{logcoefnum{mult_out[2*inwidth-1]}},mult_out};
assign out=resault;
endmodule