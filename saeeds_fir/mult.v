module Multiplier #(parameter n=32)(
  a, 
  b, 
  res
);
  input signed  [n-1:0]     a, b;
  output signed [2*n-1:0]    res;
  
  assign res=a*b;
  
endmodule
