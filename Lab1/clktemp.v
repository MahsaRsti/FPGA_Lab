module test;

reg clk,enable;
wire tick;

BaudTickGen test(clk,enable,tick);

initial begin
	clk = 1'b0;
    enable=1'b0;
    #20
    enable=1'b1;
end
always #10 clk = ~clk;

endmodule