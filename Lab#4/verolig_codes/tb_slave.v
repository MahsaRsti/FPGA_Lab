module tb_slave();

reg DONE=1'b1,CSI_CLOCK_RESET_N=1'b0,CSI_CLOCK_CLK=1'b1,AVS_AVALONSLAVE_READ,AVS_AVALONSLAVE_WRITE;
reg [3:0] AVS_AVALONSLAVE_ADDRESS;
reg [31:0] AVS_AVALONSLAVE_WRITEDATA;
wire START,DONE_REG,AVS_AVALONSLAVE_WAITREQUEST;
wire [18:0] SIZE;
wire [10:0] NUM;
wire [31:0] SLV_REG1_OUTPUT,SLV_REG2_OUTPUT,SLV_REG3_OUTPUT,AVS_AVALONSLAVE_READDATA;
AVS_AVALONSLAVE #
(
  // you can add parameters here
  // you can change these parameters
  .AVS_AVALONSLAVE_DATA_WIDTH(32),
  .AVS_AVALONSLAVE_ADDRESS_WIDTH(4)
)
(
  // user ports begin
  START, //GO
  DONE,
  // me
  SIZE,
  NUM,
  DONE_REG,
 // output [AVS_AVALONSLAVE_DATA_WIDTH - 1:0] SLV_REG0_OUTPUT,
  SLV_REG1_OUTPUT,
  SLV_REG2_OUTPUT,
  SLV_REG3_OUTPUT,
  //
  // user ports end
  // dont change these ports
  CSI_CLOCK_CLK,
  CSI_CLOCK_RESET_N,
  AVS_AVALONSLAVE_ADDRESS,
  AVS_AVALONSLAVE_WAITREQUEST,
  AVS_AVALONSLAVE_READ,
  AVS_AVALONSLAVE_WRITE,
  AVS_AVALONSLAVE_READDATA,
  AVS_AVALONSLAVE_WRITEDATA
);




endmodule