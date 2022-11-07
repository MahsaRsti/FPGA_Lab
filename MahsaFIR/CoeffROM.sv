module CoeffROM (
  adr,   
  coeff
  );

  input  [5:0]    adr;
  output [15:0]   coeff;
  
  reg [15:0] mem[0:63];
  
  initial begin
    $readmemb("coeffs.txt",mem);
  end

  assign coeff = mem[adr] ;
  
endmodule   
