module counter #(parameter length=6)(clock,reset,cnt_en,d_out,co);
input clock,reset,cnt_en;
output reg[length-1:0] d_out;
output reg co;
always @(posedge clock,posedge reset) begin
    if(reset) begin
        d_out<=0;
    end
    else begin
        if(cnt_en) begin
            if(co) begin
                d_out=6'b0;
            end
            else begin
                d_out=d_out+1;
            end
        end
    end
end
assign co=&(d_out);
endmodule