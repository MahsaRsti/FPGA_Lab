module Counter(
    clock,
    reset,
    cnt_en,
    cout,
    out_cnt
);

input clock,reset,cnt_en;
output cout;
output  [5:0] out_cnt;
reg [6:0] cnt_temp;

always @(posedge clock, posedge reset) begin
    if(reset) begin
        cnt_temp<=7'b0; 
      
    end
    else begin
        if(cnt_en)  begin
            if(cout) cnt_temp<=7'b0;
            else cnt_temp<=cnt_temp+1;
        end
    end
end
assign cout=(cnt_temp==7'd64) ? 1'b1 : 1'b0;
assign out_cnt=cnt_temp[5:0];


endmodule