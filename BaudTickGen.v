module BaudTickGen(
    input clk, enable,
    output reg tick  // generate a tick at the specified baud rate * oversampling
);
parameter ClkFrequency = 50000000;
parameter Baud = 115200;
parameter Oversampling = 1;

reg [31:0] tick_gen=0;
reg [31:0] count=0;
integer i;
////////////////////////////////
//Calculate clk tick number between each two baud tick
initial begin  
    tick_gen=ClkFrequency/(Baud*Oversampling);
end


always @(posedge clk) begin
    if(!enable) tick=1'b0;
    else begin
        if(count==tick_gen) begin
          count=0;
          tick<=1'b1;
        end
        else begin
            count=count+1;
            tick<=1'b0;
        end
   // tick=~tick;
    end
end
//Generate baud tick
//place your code here
////////////////////////////////

endmodule
