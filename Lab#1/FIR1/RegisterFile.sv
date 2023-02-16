module RegisterFile (
  in_data, 
  rd_reg,   
  reg_write,
  reset, 
  clock, 
  rd_data 
);
  input [15:0]       in_data;
  input [5:0]         rd_reg;
  input               reg_write, reset, clock;
  
  output [15:0]  rd_data;

  reg [15:0] register_file [0:63];
  integer i;
  
    assign rd_data = register_file[rd_reg];

    always @(posedge clock, posedge reset) begin
        if (reset == 1'b1) begin
        for (i=0; i<64 ; i=i+1 )
            register_file[i] <= 0;
        end
        else if(reg_write) begin
          register_file[0] <= in_data;
          for (i=1; i<64 ; i=i+1 ) begin
              register_file[i] <= register_file[i-1];
          end
        end
    end

endmodule