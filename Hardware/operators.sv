module Ch(input logic [31:0] reg1, reg2, reg3,
            output logic [31:0] out);

    always_comb
	 begin
        out = (reg1 & reg2) ^ (~reg1 & reg3);
    end

endmodule


module Maj(input logic [31:0] reg1, reg2, reg3,
            output logic [31:0] out);

    always_comb
	 begin
        out = (reg1 & reg2) ^ (reg1 & reg3) ^ (reg2 & reg3);
    end

endmodule


module Csigma0(input logic [31:0] register,
            output logic [31:0] out);

    logic [31:0] rotr2, rotr13, rotr22;

    always_comb
	 begin
        rotr2 = {register[1:0], register[31:2]};
        rotr13 = {register[12:0], register[31:13]};
        rotr22 = {register[21:0], register[31:22]};

        out = rotr2 ^ rotr13 ^ rotr22;
    end

endmodule


module Csigma1(input logic [31:0] register,
            output logic [31:0] out);

    logic [31:0] rotr6, rotr11, rotr25;

    always_comb
	 begin
        rotr6 = {register[5:0], register[31:6]};
        rotr11 = {register[10:0], register[31:11]};
        rotr25 = {register[24:0], register[31:25]};

        out = rotr6 ^ rotr11 ^ rotr25;
    end

endmodule


module Lsigma0(input logic [31:0] register,
            output logic [31:0] out);

    logic [31:0] rotr7, rotr18, shr3;

    always_comb
	 begin
        rotr7 = {register[6:0], register[31:7]};
        rotr18 = {register[17:0], register[31:18]};
        shr3 = register >> 3;

        out = rotr7 ^ rotr18 ^ shr3;
    end

endmodule


module Lsigma1(input logic [31:0] register,
            output logic [31:0] out);

    logic [31:0] rotr17, rotr19, shr10;

    always_comb
	 begin
        rotr17 = {register[16:0], register[31:17]};
        rotr19 = {register[18:0], register[31:19]};
        shr10 = register >> 10;

        out = rotr17 ^ rotr19 ^ shr10;
    end

endmodule