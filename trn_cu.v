module trn_cu(
    TxD_busy,
    clk, rst,
    FIR_valid,
    ff2_Sel,
    ff2_load,
    TxD_start
);
    input TxD_busy, clk,rst, FIR_valid;
    output reg ff2_Sel, ff2_load, TxD_start;

    reg [2:0] ns, ps;

    parameter [2:0] idle        = 3'b000,
                    load_res    = 3'b001,
                    get_lsb     = 3'b010,
                    get_msb1    = 3'b011,
                    get_msb2    = 3'b100;

    always@(posedge clk) begin
        if(rst)
            ps <= 0;
        else begin
            ps <= ns;
        end
    end
    always@(*) begin
        case(ps)
            idle:       ns = (FIR_valid == 1'b1) ? load_res : idle;
            load_res:   ns = get_lsb;
            get_lsb:    ns = (TxD_busy == 1'b0) ? get_msb1 : get_lsb;
            get_msb1:   ns = get_msb2;
            get_msb2:   ns = (TxD_busy == 1'b0) ? idle : get_msb2;
        endcase
    end
    always@(ps) begin
        {ff2_Sel, ff2_load, TxD_start} = 0;
        case(ps)
            idle:       {ff2_load, ff2_Sel}  = 2'b11;
            load_res:   {ff2_Sel, TxD_start} = 2'b11;
            get_lsb:    {TxD_start, ff2_Sel} = 2'b01;
            get_msb1:   {ff2_Sel, TxD_start} = 2'b01;
            get_msb2:   {ff2_Sel, TxD_start} = 2'b00;
        endcase
    end
endmodule