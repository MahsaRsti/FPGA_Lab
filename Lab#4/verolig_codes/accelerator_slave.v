module AVS_AVALONSLAVE #
(
  // you can add parameters here
  // you can change these parameters
  parameter integer AVS_AVALONSLAVE_DATA_WIDTH = 32,
  parameter integer AVS_AVALONSLAVE_ADDRESS_WIDTH = 4
)
(
  // user ports begin
  output wire START, //GO
  input wire DONE, 
  // me
  output [18:0] SIZE,
  output [10:0] NUM,
  output DONE_REG,

  output [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] SLV_REG1_OUTPUT,
  output [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] SLV_REG2_OUTPUT,
  output [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] SLV_REG3_OUTPUT,

  // user ports end
  // dont change these ports
  input wire CSI_CLOCK_CLK,
  input wire CSI_CLOCK_RESET_N,
  input wire [AVS_AVALONSLAVE_ADDRESS_WIDTH - 1:0] AVS_AVALONSLAVE_ADDRESS, //from CPU
  output wire AVS_AVALONSLAVE_WAITREQUEST,
  input wire AVS_AVALONSLAVE_READ, //from CPU
  input wire AVS_AVALONSLAVE_WRITE, //from CPU
  output wire [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] AVS_AVALONSLAVE_READDATA, //to CPU by ACCS
  input wire [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] AVS_AVALONSLAVE_WRITEDATA  //from CPU to ACCS
);

  // output wires and registers
  // you can change name and type of these ports
  wire start, done_reg;
  wire [18:0] size;
  wire [10:0] num;

  reg wait_request=1'b0;
  reg [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] read_data;
  // these are slave registers. they MUST be here!
  reg [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] slv_reg0;
  reg [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] slv_reg1;
  reg [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] slv_reg2;
  reg [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] slv_reg3;

  // I/O assignment
  // never directly send values to output
  assign START = start;
  assign SIZE = size;
  assign NUM = num;
  assign DONE_REG = done_reg;

  assign AVS_AVALONSLAVE_WAITREQUEST = wait_request;
  assign AVS_AVALONSLAVE_READDATA = read_data;
  assign SLV_REG1_OUTPUT = slv_reg1;
  assign SLV_REG2_OUTPUT = slv_reg2;
  assign SLV_REG3_OUTPUT = slv_reg3;

  // it is an example and you can change it or delete it completely
  always @(posedge CSI_CLOCK_CLK)
  begin
    // usually resets are active low but you can change its trigger type
    if(CSI_CLOCK_RESET_N == 0)
    begin
      slv_reg0 <= 0;
      slv_reg1 <= 0;
      slv_reg2 <= 0;
      slv_reg3 <= 0;
    end
    else begin
      slv_reg0[31] <= DONE;
      if(AVS_AVALONSLAVE_WRITE) begin
      case(AVS_AVALONSLAVE_ADDRESS) 
      0: slv_reg0[30:0] <= AVS_AVALONSLAVE_WRITEDATA[30:0];
      1: slv_reg1 <= AVS_AVALONSLAVE_WRITEDATA;
      2: slv_reg2 <= AVS_AVALONSLAVE_WRITEDATA;
      3: slv_reg3 <= AVS_AVALONSLAVE_WRITEDATA;
      default:
      begin
        slv_reg0[30:0] <= slv_reg0[30:0];
        slv_reg1 <= slv_reg1;
        slv_reg2 <= slv_reg2;
        slv_reg3 <= slv_reg3;
      end
      endcase
      end
    end
  end
  always @(*) begin
    case(AVS_AVALONSLAVE_ADDRESS)
      0:  read_data = slv_reg0;
      1:  read_data = slv_reg1;
      2:  read_data = slv_reg2;
      3:  read_data = slv_reg3;
      default :  read_data = {AVS_AVALONSLAVE_DATA_WIDTH{1'b0}};
    endcase
  end

  // do the other jobs yourself like last codes
  assign start = slv_reg0[0];
  assign done_reg = slv_reg0[31];
  assign size = slv_reg0[30:12];
  assign num = slv_reg0[11:1];

endmodule
