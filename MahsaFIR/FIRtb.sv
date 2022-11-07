module myFIR_tb;

parameter   IN_WIDTH = 16;
parameter   OUT_WIDTH = 38;
parameter	DATA_LEN=221184;
reg   [IN_WIDTH-1:0] din;
wire  [OUT_WIDTH-1:0] dout;

reg [OUT_WIDTH-1:0]  expected_data [0:DATA_LEN];
reg [IN_WIDTH-1:0]  input_data [0:DATA_LEN];
reg [OUT_WIDTH-1:0]  temp_out;
reg clk,rst,input_valid;
integer i,fp;
wire output_valid;

FIR myFIR(.clk(clk),.rst(rst),.input_valid(input_valid),.input_data(din),.output_data(dout),.output_valid(output_valid));

initial begin  
    $readmemb("inputs.txt", input_data);   
end

initial begin
    $readmemb("outputs.txt", expected_data);
end           

initial begin
	clk = 1'b0;
end

always #10 clk = ~clk;

initial begin 
    input_valid=1'b0;
	rst=1'b1;   
    #50;
    rst=1'b0;
    #20;
end         

initial begin
	fp = $fopen("outManualFIRVerilog.txt");
	#50;
	$display("Testing %d Samples...",DATA_LEN);		
	for(i = 0; i < DATA_LEN; i = i + 1) begin
        #20;
        input_valid=1'b1;
		din =input_data[i];
        #20;				
        input_valid=1'b0;
        @(posedge output_valid); //waiting 65 cycles
        $fwrite(fp,"%b\n",dout);
		temp_out = expected_data[i];
		if(dout != temp_out[OUT_WIDTH-1:0]) begin
		    $display("test failed: %d   input: %b expected: %b output: %b" , i, din, temp_out[OUT_WIDTH-1:0], dout);
        end
		else begin
			$display("test is successful: %d   input: %b expected: %b output: %b" , i, din, temp_out[OUT_WIDTH-1:0], dout);
		end
	end
$fclose(fp);
$display ("Test Passed.");
$finish;
end

// Assertion Verification
property p1;
	@(posedge clk) myFIR.dp.cnt_en |-> myFIR.dp.reg_ld;
endproperty

property p2;
	@(posedge clk) $rose(myFIR.dp.cnt_cout) ##1 output_valid;
endproperty

property p3;
	@(posedge clk) !myFIR.dp.cnt_cout |-> myFIR.cntrlr.ps==2'd2;
endproperty

property p4;
	@(posedge clk) input_valid |-> !output_valid;
endproperty

property p5;
	@(posedge clk) $rose(input_valid) ##[65:67] output_valid;
endproperty

Calculating_signals_check: assert property(p1) $display("Calculating signals are correct.");
else  $display("Error in Calculating state signals.");

Counter_cout_check: assert property(p2) $display("Output becomes valid after finishing calculating");
else  $display("Error in Counter.");

Calculating_state_check: assert property(p3) $display("Calculating state works correctly.");
else  $display("Error in Calculating state.");

inputvalid_and_outputvalid: assert property(p4) $display("output_valid becomes 1 correctly");
else  $display("Error in output_valid signal.");

num_of_cycles_check: assert property(p5) $display("output generates in true cycle amounts");
else  $display("Error in cycle amounts of generating an input.");


endmodule
