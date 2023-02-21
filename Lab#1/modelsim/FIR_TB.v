module testbench;

parameter   InWidth = 16;
parameter   outWidth = 38;
parameter	  coefnum = 64;
parameter   logcoefnum = 6;
parameter   DATA_LEN = 221184;
reg   [InWidth-1:0] inData;
wire  [outWidth-1:0] outData;

reg [outWidth-1:0]  expected_data [0:DATA_LEN-1];
reg [InWidth-1:0]  input_data [0:DATA_LEN-1];
//reg [OUT_WIDTH-1:0]  temp_out;
reg clk,rst,in_valid;
wire out_valid;
integer i,fp;
FIR #(InWidth,outWidth,coefnum,logcoefnum) FFIR(clk,rst,in_valid,inData,out_valid,outData);


initial
    begin  
    $readmemb("inputs.txt", input_data);   
end

initial
    begin
    $readmemb("outputs.txt", expected_data);
end           

initial
begin
	clk = 1'b0;
end

always #10 clk = ~clk;



initial
begin
    in_valid=1'b0;
	fp = $fopen("outManualFIRVerilog.txt");
	#1;
	rst=1;
	#12;
	rst=0;
	@(posedge clk);
	
	$display("Testing %d Samples...",DATA_LEN);		
	for(i = 0; i < DATA_LEN; i = i + 1)
	begin
	  @(posedge clk);
	  #1;
	  in_valid=1'b1;
	  inData =input_data[i]; 
	  @(posedge clk);
	  #5;
	  in_valid=1'b0;
	  @(posedge out_valid);
	  $fwrite(fp,"%b\n",outData);
	  if (outData != expected_data[i])begin
	    $display("out data: %d",outData);
		$display("expected data: %d",expected_data[i]);
	    $display("error in %d Samples...",i);
	  end
	  else 
	    $display("success in %d Samples...",i);
	  
	end
	 
$fclose(fp);
$display ("Test Passed.");
$stop();
end
// assertions:
assert property (@(posedge clk)(in_valid==1'b1) |->##[66:67] out_valid) $display("out valid passed");
else   $error("out valid error");
assert property (@(posedge clk)(FFIR.CU.ps==2'b10 && FFIR.CU.cnt_co)|->##1 FFIR.CU.ps==2'b11) $display("CU is workong correctly");
else $error("CU is not workong correctly");
assert property (@(posedge clk)(FFIR.DP.adr==16'b0000000000000001)|->##1 FFIR.DP.coef==16'b1111111111001010)
else $error("memory is not working correctly");
ADDER1_check: assert property(@(FFIR.DP.adder_out) (1'b1==1'b1)|-> FFIR.DP.adder_out!=(FFIR.DP.resault+FFIR.DP.adder_in1)) $error("adder is not working correctly");
else ;//$display("");
assert property (@(posedge clk)(FFIR.DP.cnt_co==1'b1)|->##0 FFIR.DP.adr==6'b111111)
else $display("counter is not working correctly");
endmodule
