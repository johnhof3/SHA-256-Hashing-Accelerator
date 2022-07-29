module compression(
    
    input logic CLK, COMPRESSION_EN, SET_COMPRESSION,
    input logic [5:0] i,
    input logic [31:0] W [64],
    input logic [31:0] H [8],
    input logic [31:0] K [64],
    output logic [31:0] a, b, c, d, e, f, g, h
    
);

logic[31:0] S0, S1, CH, MAJ, T1, T2;

Csigma0 LoadS0(.register(a), .out(S0));
Csigma1 LoadS1(.register(e), .out(S1));
Ch LoadCh(.reg1(e), .reg2(f), .reg3(g), .out(CH));
Maj LoadMAJ(.reg1(a), .reg2(b), .reg3(c), .out(MAJ));

always_ff @(negedge CLK)
    begin
        T1 = h + S1 + CH + K[i] + W[i];
        T2 = S0 + MAJ;
    end

always_ff @(posedge CLK)
    begin
        if(SET_COMPRESSION)
            begin
                a <= H[0];
                b <= H[1];
                c <= H[2];
                d <= H[3];
                e <= H[4];
                f <= H[5];
                g <= H[6];
                h <= H[7];
            end

        if(COMPRESSION_EN)
            begin
                h <= g;
                g <= f;
                f <= e;
                e <= d + T1;
                d <= c;
                c <= b;
                b <= a;
                a <= T1 + T2;
            end
    end


endmodule