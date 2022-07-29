module hashvals(
    input logic LD_HASH, CLK, SET_HASH,
    //input logic [5:0] AVL_ADDR,
    input logic [31:0] a,b,c,d,e,f,g,h,
    //output logic [31:0] AVL_READDATA,
    output logic [31:0] H [8]
);

// always_ff @(posedge CLK)
//     begin
//         if(AVL_READ)
//             AVL_READDATA <= H[AVL_ADDR];
//     end
//first 32 fractional bits of square roots of the first 8 primes
//logic [31:0]H[8] = {32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a, 32'h510e527f,  32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19};
// logic [31:0]H[1] = 32'hbb67ae85;
// logic [31:0]H[2] = 32'h3c6ef372;
// logic [31:0]H[3] = 32'ha54ff53a;
// logic [31:0]H[4] = 32'h510e527f;
// logic [31:0]H[5] = 32'h9b05688c;
// logic [31:0]H[6] = 32'h1f83d9ab;
// logic [31:0]H[7] = 32'h5be0cd19;

always_ff @(posedge CLK)
    begin
		if(SET_HASH)
            begin
                H[0] = 32'h6a09e667;
                H[1] = 32'hbb67ae85;
                H[2] = 32'h3c6ef372;
                H[3] = 32'ha54ff53a;
                H[4] = 32'h510e527f;
                H[5] = 32'h9b05688c;
                H[6] = 32'h1f83d9ab;
                H[7] = 32'h5be0cd19;
            end
	 
	 
	 
        if(LD_HASH)
            begin
                H[0] = H[0] + a;
                H[1] = H[1] + b;
                H[2] = H[2] + c;
                H[3] = H[3] + d;
                H[4] = H[4] + e;
                H[5] = H[5] + f;
                H[6] = H[6] + g;
                H[7] = H[7] + h;
            end

    end
	 
	 
endmodule