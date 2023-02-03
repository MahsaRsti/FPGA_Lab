module accelerator #
(
  // you can add parameters here
  // you can change these parameters

  // control interface parameters
  parameter integer avs_avalonslave_data_width = 32,
  parameter integer avs_avalonslave_address_width = 4,

  // control interface parameters
  parameter integer avm_avalonmaster_data_width = 32,
  parameter integer avm_avalonmaster_address_width = 32
)
(
  // user ports begin

  // user ports end
  // dont change these ports

  // clock and reset
  input wire csi_clock_clk,
  input wire csi_clock_reset_n,

  // control interface ports
  input wire [avs_avalonslave_address_width - 1:0] avs_avalonslave_address,
  output wire avs_avalonslave_waitrequest, //to CPU
  input wire avs_avalonslave_read,
  input wire avs_avalonslave_write,
  output wire [avs_avalonslave_data_width - 1:0] avs_avalonslave_readdata,
  input wire [avs_avalonslave_data_width - 1:0] avs_avalonslave_writedata,

  // magnitude interface ports
  output wire [avm_avalonmaster_address_width - 1:0] avm_avalonmaster_address,
  input wire avm_avalonmaster_waitrequest, //from SDRAM
  output wire avm_avalonmaster_read,
  output wire avm_avalonmaster_write,
  input wire [avm_avalonmaster_data_width - 1:0] avm_avalonmaster_readdata,
  output wire [avm_avalonmaster_data_width - 1:0] avm_avalonmaster_writedata
);

// define your extra ports as wire here

localparam S0 = 4'd0, S1 = 4'd1, S2 = 4'd2, S3 = 4'd3, S4 = 4'd4, S5 = 4'd5, S6 = 4'd6, S7 = 4'd7, S8 = 4'd8, S9 = 4'd9, S10 = 4'd10, S11 = 4'd11;
//

// define your extra ports as wire here

reg[avm_avalonmaster_address_width-1 : 0] addr_read_right;
reg[avm_avalonmaster_address_width-1 : 0] addr_read_left;
reg[avm_avalonmaster_address_width-1 : 0] addr_write;
reg[18:0] size_iteration = 19'b0; 
wire size_cmp;
reg[10:0] num_iteration = 11'b0; 
wire num_cmp;

reg[(2*avm_avalonmaster_data_width) - 1:0] acc = {(2*avm_avalonmaster_data_width){1'b0}};

//slave
wire slave_start;
reg slave_done=1'b0;
wire [18:0] size;
wire [10:0] num;
wire done_reg_slave;

wire [avs_avalonslave_data_width - 1:0] slv_reg1_slave;
wire [avs_avalonslave_data_width - 1:0] slv_reg2_slave;
wire [avs_avalonslave_data_width - 1:0] slv_reg3_slave;

//master
reg master_start=1'b0;
wire master_done;
reg [avm_avalonmaster_address_width - 1:0] master_adr={avm_avalonmaster_address_width{1'b0}};
wire [avm_avalonmaster_data_width - 1:0] read_data_master;
reg [avm_avalonmaster_data_width - 1:0] write_data_master={avm_avalonmaster_data_width{1'b0}};
reg read_master_req;
reg write_master_req;

reg [3:0] state=4'b0;
reg[avm_avalonmaster_data_width-1 : 0] captured_data = {avm_avalonmaster_data_width{1'b0}};
 // user ports begin

// control interface instanciation
AVS_AVALONSLAVE #
(
  // you can add parameters here
  // you can change these parameters
  .AVS_AVALONSLAVE_DATA_WIDTH(avs_avalonslave_data_width),
  .AVS_AVALONSLAVE_ADDRESS_WIDTH(avs_avalonslave_address_width)
) AVS_AVALONSLAVE_INST // instance  of module must be here
(
  // user ports begin
  .START(slave_start), //GO //from reg0
  .DONE(slave_done),
  .SIZE(size),
  .NUM(num),
  .DONE_REG(done_reg_slave),
  .SLV_REG1_OUTPUT(slv_reg1_slave),
  .SLV_REG2_OUTPUT(slv_reg2_slave),
  .SLV_REG3_OUTPUT(slv_reg3_slave),
  // user ports end
  // dont change these ports
  .CSI_CLOCK_CLK(csi_clock_clk),
  .CSI_CLOCK_RESET_N(csi_clock_reset_n),
  .AVS_AVALONSLAVE_ADDRESS(avs_avalonslave_address), //from CPU
  .AVS_AVALONSLAVE_WAITREQUEST(avs_avalonslave_waitrequest),  //to CPU always 0
  .AVS_AVALONSLAVE_READ(avs_avalonslave_read), //from CPU
  .AVS_AVALONSLAVE_WRITE(avs_avalonslave_write), //from CPU
  .AVS_AVALONSLAVE_READDATA(avs_avalonslave_readdata), //to CPU by ACCS to recognize done by CPU
  .AVS_AVALONSLAVE_WRITEDATA(avs_avalonslave_writedata) // to fill 4 regs of slave by CPU
);
// magnitude interface instanciation
AVM_AVALONMASTER_MAGNITUDE #
(
  // you can add parameters here
  // you can change these parameters
  .AVM_AVALONMASTER_DATA_WIDTH(avm_avalonmaster_data_width),
  .AVM_AVALONMASTER_ADDRESS_WIDTH(avm_avalonmaster_address_width)
) AVM_AVALONMASTER_MAGNITUDE_INST // instance  of module must be here
(
  // user ports begin
  .START(master_start),
  .DONE(master_done),
  .ADDRESS(master_adr), //from ACCS to master to SDRAM
  .READ_DATA(read_data_master), //from SDRAM
  .WRITE_DATA(write_data_master), //to SDRAM
  .READ_REQ(read_master_req), //from ACCS
  .WRITE_REQ(write_master_req), //from ACCS
  // user ports end
  // dont change these ports
  .CSI_CLOCK_CLK(csi_clock_clk),
  .CSI_CLOCK_RESET_N(csi_clock_reset_n),
  .AVM_AVALONMASTER_ADDRESS(avm_avalonmaster_address), //to SDRAM
  .AVM_AVALONMASTER_WAITREQUEST(avm_avalonmaster_waitrequest), //from SDRAM
  .AVM_AVALONMASTER_READ(avm_avalonmaster_read), //to SDRAM
  .AVM_AVALONMASTER_WRITE(avm_avalonmaster_write), //to SDRAM
  .AVM_AVALONMASTER_READDATA(avm_avalonmaster_readdata), //from SDRAM
  .AVM_AVALONMASTER_WRITEDATA(avm_avalonmaster_writedata) //to SDRAM
);

assign size_cmp=(size_iteration < size);
assign num_cmp=(num_iteration < num);
assign of_data=(captured_data[31]==1'b1) ? ((~captured_data) + 32'd1) : captured_data;

always @(posedge csi_clock_clk, negedge csi_clock_reset_n) begin
  if(csi_clock_reset_n == 1'b0) begin
    state <= S0;
    write_data_master <= {avm_avalonmaster_data_width{1'b0}}; //output
    master_adr <= {avm_avalonmaster_address_width{1'b0}}; 
    addr_write <= {avm_avalonmaster_address_width{1'b0}};
    addr_read_left <= {avm_avalonmaster_address_width{1'b0}};
    addr_read_right <= {avm_avalonmaster_address_width{1'b0}};
    captured_data <= {avm_avalonmaster_data_width{1'b0}};
    acc <= {(2*avm_avalonmaster_data_width){1'b0}};
    size_iteration <= 19'd0;
    num_iteration <= 11'd0;
  end
  else begin
    case(state)
      S0 : begin
        if(slave_start == 1'b1)begin
          state <= S1;
          addr_write <= slv_reg3_slave;
          addr_read_right <= slv_reg1_slave;
          addr_read_left <= slv_reg2_slave;
          acc <= {(2*avm_avalonmaster_data_width){1'b0}};
          size_iteration <= 19'd0;
          num_iteration <= 11'd0;
        end
      end
      S1 : begin
        if(slave_start == 1'b0)
          state <= S2;
      end
      S2 : begin
        master_adr <= addr_read_right;
        addr_read_right <= addr_read_right + 32'd4;
        state <= S3;
        size_iteration <= size_iteration + 19'd1;
      end
      S3 : state <= S4; //read from SDRAM
      S4 : begin
        if(master_done == 1'b1) begin
          state <= S5;
          captured_data <= read_data_master;
        end
      end
      S5 : begin
        acc <= acc + {{avm_avalonmaster_data_width{1'b0}}, of_data};
        if(size_cmp == 1'b1)
          state <= S2;
        else
          state <= S6;
      end
      S6 : begin
        num_iteration <= num_iteration + 11'd1;
        write_data_master <= acc[31:0];
        master_adr <= addr_write;
        addr_write <= addr_write + 32'd4;
        state <= S7;
      end
      S7 : state <= S8;
      S8 : begin
        if(master_done == 1'b1)
          state <= S9;
      end
      S9 : begin
        write_data_master <= acc[63:32];
        master_adr <= addr_write;
        addr_write <= addr_write + 32'd4;
        state <= S10;
      end
      S10 : state <= S11;
      S11 : begin
        if(master_done == 1'b1) begin
          size_iteration <= 19'd0;
          acc <= {(2*avm_avalonmaster_data_width){1'b0}};
          if(num_cmp == 1'b1)
            state <= S2;
          else
            state <= S0;
        end
      end
    endcase
  end
end


always @(*) begin
  slave_done = 1'b0;
  master_start = 1'b0;
  read_master_req = 1'b0;
  write_master_req = 1'b0;
  case(state)
    S0 :
      slave_done = 1'b1;
    S3 : begin
      read_master_req = 1'b1;
      master_start = 1'b1;
    end
    S7 : begin
      write_master_req = 1'b1;
      master_start = 1'b1;
    end
    S10 : begin
      write_master_req = 1'b1;
      master_start = 1'b1;
    end
  endcase
end

endmodule
