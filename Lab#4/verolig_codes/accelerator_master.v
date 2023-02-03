// `define S0 3'b000
// `define SREAD 3'b001
// `define SWRITE 3'b010
// `define FIN 3'b011

module AVM_AVALONMASTER_MAGNITUDE #
(
  // you can add parameters here
  // you can change these parameters
  parameter integer AVM_AVALONMASTER_DATA_WIDTH = 32,
  parameter integer AVM_AVALONMASTER_ADDRESS_WIDTH = 32
)
(
  // user ports begin

  // these are just some example ports. you can change them all
  input wire START,
  output wire DONE,
  input [AVM_AVALONMASTER_ADDRESS_WIDTH - 1:0] ADDRESS, //from ACCS
  output [AVM_AVALONMASTER_DATA_WIDTH - 1:0] READ_DATA, //to accs
  input [AVM_AVALONMASTER_DATA_WIDTH - 1:0] WRITE_DATA, //from accs
  input READ_REQ, //from accs
  input WRITE_REQ, //from accs

  // user ports end
  // dont change these ports
  input wire CSI_CLOCK_CLK,
  input wire CSI_CLOCK_RESET_N,
  output wire [AVM_AVALONMASTER_ADDRESS_WIDTH - 1:0] AVM_AVALONMASTER_ADDRESS,
  input wire AVM_AVALONMASTER_WAITREQUEST, //from SDRAM
  output wire AVM_AVALONMASTER_READ, //to SDRAM
  output wire AVM_AVALONMASTER_WRITE, //to SDRAM
  input wire [AVM_AVALONMASTER_DATA_WIDTH - 1:0] AVM_AVALONMASTER_READDATA, //from SDRAM
  output wire [AVM_AVALONMASTER_DATA_WIDTH - 1:0] AVM_AVALONMASTER_WRITEDATA //to SDRAM
);
  localparam S0=3'b000 , SREAD=3'b001 , SWRITE=3'b010 , FIN=3'b011;
  // output wires and registers
  // you can change name and type of these ports
  reg done = 1'b0;
  reg [2:0] ps = 3'b000;
  reg [2:0] ns;
  reg read=1'b0;
  reg write=1'b0;
  reg [AVM_AVALONMASTER_DATA_WIDTH - 1:0] readdata;



  // I/O assignment
  // never directly send values to output
  assign DONE = done;
  assign AVM_AVALONMASTER_ADDRESS = ADDRESS;
  assign AVM_AVALONMASTER_READ = read; //SDRAM
  assign AVM_AVALONMASTER_WRITE = write; //SDRAM
  assign AVM_AVALONMASTER_WRITEDATA = WRITE_DATA;
  assign READ_DATA = readdata;

  /****************************************************************************
  * all main function must be here or in main module. you MUST NOT use control
  * interface for the main operation and only can import and export some wires
  * from/to it
  ****************************************************************************/

  // user logic begin
  always @(posedge CSI_CLOCK_CLK)
  begin
    if(CSI_CLOCK_RESET_N == 0)
    begin
      done <= 1'b0;
      ps <= S0;
      readdata <= {AVM_AVALONMASTER_DATA_WIDTH{1'b0}};
    end
    else
    begin
       {read,write}<=2'b0;
    case(ps)
      SREAD: begin read <= 1'b1;
             readdata <= AVM_AVALONMASTER_READDATA;
             end
      SWRITE: write <= 1'b1;
      FIN: done <= 1'b1;
    endcase
      ps <= ns;
    end
  end
  always @(*) begin
    case(ps)
      S0: if(START) begin
            if(READ_REQ) ns <= SREAD;
            else if(WRITE_REQ) ns <= SWRITE;
            else ns <= S0;
          end
          else ns <= S0;
      SREAD:  if(AVM_AVALONMASTER_WAITREQUEST) ns <= SREAD;
              else ns <= FIN;
      SWRITE: if(AVM_AVALONMASTER_WAITREQUEST) ns <= SWRITE;
              else ns <= FIN;
      FIN: ns <= S0;
    endcase
  end

endmodule
