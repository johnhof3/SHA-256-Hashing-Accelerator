module load_ctr(
input logic CTRL_LOAD_REG, load_ctr_reset, CLK,
output logic [5:0] CUR_MESSAGE_REG
);

always_ff @(negedge CLK)
    begin
        if(CTRL_LOAD_REG)
            CUR_MESSAGE_REG <= CUR_MESSAGE_REG + 1;
        if(load_ctr_reset)
            CUR_MESSAGE_REG <= 6'b001111; //starts at reg 16
    end

endmodule

module compression_ctr(
input logic COMPRESSION_TIMER_EN, compression_ctr_reset, CLK,
output logic [5:0] i
);

always_ff @(posedge CLK)
    begin
        if(COMPRESSION_TIMER_EN)
            i <= i + 1;
        if(compression_ctr_reset)
            i <= 6'b000000;
    end

endmodule