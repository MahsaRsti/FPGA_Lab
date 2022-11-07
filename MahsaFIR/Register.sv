module Register (
  d_in, 
  reset, 
  clock, 
  ld,
  clr,
  d_out
);
  input  [37:0]        d_in;
  input                reset,clock,ld,clr;
  output reg [37:0]    d_out;
  
  always @(posedge clock, posedge reset) begin
    if (reset) d_out<=0;
    else begin
        if(clr)        d_out<=38'b0;
        else if(ld)    d_out<=d_in;
    end
  end
  
endmodule