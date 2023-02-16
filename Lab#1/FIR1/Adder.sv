module Adder (
  a, 
  b, 
  co, 
  sum
);
  input  [37:0]    a,b;
  output [37:0]    sum;
  output           co;

  assign {co,sum} = a+b;
endmodule
