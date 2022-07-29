module MessageSchedule (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
//	input  logic AVL_READ,					// Avalon-MM Read
//	input  logic AVL_WRITE,					// Avalon-MM Write
	//input  logic AVL_CS,					// Avalon-MM Chip Select, I don't think nessicary
//	input  logic [5:0] AVL_ADDR,			// Avalon-MM Address
//	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
//	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data

    input logic [5:0] CUR_MESSAGE_REG,
    input logic CTRL_LOAD_REG,
    input logic [31:0] DATA_ARRAY [26],
    output logic [31:0] W [64]
);

//logic [31:0] W [64];

//loading initial Registers

logic [31:0] s0, s1, load_val;
logic [5:0] minus7, minus2, minus16, minus15;


 always_ff @(posedge CLK)
    begin
 		if(CTRL_LOAD_REG)
            W[CUR_MESSAGE_REG] <= load_val;
				 
		else
			begin
				W[0] <= DATA_ARRAY[0];
                W[1] <= DATA_ARRAY[1];
                W[2] <= DATA_ARRAY[2];
                W[3] <= DATA_ARRAY[3];
                W[4] <= DATA_ARRAY[4];
                W[5] <= DATA_ARRAY[5];
                W[6] <= DATA_ARRAY[6];
                W[7] <= DATA_ARRAY[7];
                W[8] <= DATA_ARRAY[8];
                W[9] <= DATA_ARRAY[9];
                W[10] <= DATA_ARRAY[10];
                W[11] <= DATA_ARRAY[11];
                W[12] <= DATA_ARRAY[12];
                W[13] <= DATA_ARRAY[13];
                W[14] <= DATA_ARRAY[14];
                W[15] <= DATA_ARRAY[15];
			
			end
    end

//functions for loading other 48 registers

always_comb
    begin

        minus2 = CUR_MESSAGE_REG - 2;
        minus7 = CUR_MESSAGE_REG - 7;
        minus15 = CUR_MESSAGE_REG - 15;
        minus16 = CUR_MESSAGE_REG - 16;

        load_val = s1 + W[minus7] + s0 + W[minus16];
    end

Lsigma0 Loads0(.register(W[minus15]), .out(s0));
Lsigma1 Loads1(.register(W[minus2]), .out(s1));

//always_ff @(posedge CLK)
//    begin
//        if(CTRL_LOAD_REG && ~AVL_WRITE)
//            W[CUR_MESSAGE_REG] <= load_val;
//    end
	 
endmodule