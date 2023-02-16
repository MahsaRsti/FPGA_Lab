module FIR(
    clk,
    rst,
    input_valid,
    input_data,
    output_data,
    output_valid
);

input                   clk,rst,input_valid;
input [15:0]            input_data;
output  [37:0] output_data;
output                  output_valid;

wire regfile_write,cnt_en,cnt_cout,reg_clr,reg_ld;

DataPath dp(.clk(clk),.rst(rst),.regfile_write(regfile_write),.output_valid(output_valid),.cnt_en(cnt_en),
            .reg_clr(reg_clr),.reg_ld(reg_ld),.input_data(input_data),.output_data(output_data),.cnt_cout(cnt_cout));

Controller cntrlr(.clk(clk),.rst(rst),.cnt_cout(cnt_cout),.input_valid(input_valid),.output_valid(output_valid),.cnt_en(cnt_en),
                  .regfile_write(regfile_write),.reg_clr(reg_clr),.reg_ld(reg_ld));

endmodule

