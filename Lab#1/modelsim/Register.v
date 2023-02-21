module Register #(parameter n=32) (
  d_in, 
  reset, 
  ld, 
  clock, 
  d_out
);
  input  [n-1:0]        d_in;
  input                 reset, ld, clock;
  output reg [n-1:0]    d_out;
  
  always @(posedge clock, posedge reset) begin
    if (reset==1'b1)
      d_out <= 0;
    else if (ld)
      d_out <= d_in;
    else
      d_out <= d_out;
  end
  
endmodule