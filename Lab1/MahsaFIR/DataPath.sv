module DataPath(
    clk,
    rst,
    regfile_write,
    output_valid,
    cnt_en,
    input_data,
    reg_clr,
    reg_ld,
    output_data,
    cnt_cout
);

input clk,rst,regfile_write,output_valid,cnt_en,reg_clr,reg_ld;
input [15:0]    input_data;

output [37:0] output_data;
output cnt_cout;

wire [5:0]  counter;
wire signed [15:0] regfile_out,coeff;
wire signed [31:0] res_mul;
wire [37:0] res_sum,out_reg;

Counter main_cnt(.clock(clk),.reset(rst),.cnt_en(cnt_en),.cout(cnt_cout),.out_cnt(counter));

RegisterFile inputs_regfile(.in_data(input_data),.rd_reg(counter),.reg_write(regfile_write),.reset(rst),.clock(clk),.rd_data(regfile_out));

CoeffROM  coefficients(.adr(counter),.coeff(coeff));

Multiplier multiplier(.a(regfile_out),.b(coeff),.result(res_mul));

Adder adder(.a({{6{res_mul[31]}},res_mul}),.b(out_reg),.sum(res_sum),.co());

Register out_register(.d_in(res_sum),.reset(rst),.clock(clk),.ld(reg_ld),.clr(reg_clr),.d_out(out_reg));

assign output_data=(output_valid) ? out_reg : output_data;

endmodule