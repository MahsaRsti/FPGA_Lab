module Multiplier (
  a, 
  b,  
  result
);

input signed [15:0] a,b;
output signed [31:0] result;

assign result=a*b;

endmodule