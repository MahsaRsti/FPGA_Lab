module CoefMem #(parameter width=16,length=64,adrlength=6) (
  adr,
  d_out
  );

  input  [adrlength-1:0]   adr;
  output [width-1:0]   d_out;
  
  reg [width-1:0] mem[0:length-1];
  
  initial begin
    $readmemb("coeffs.txt",mem);
  end
  assign d_out = mem[adr];
  
endmodule   
