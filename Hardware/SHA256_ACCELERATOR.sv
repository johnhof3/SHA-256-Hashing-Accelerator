module SHA256_ACCELERATOR(

    input logic CLK,
	//input logic START,
	// Avalon Reset Input
	input logic RESET,
	
	//Avalon-MM Slave Signals
    input  logic AVL_READ,				    // Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	//input  logic AVL_CS,					// Avalon-MM Chip Select, I don't think nessicary
	input  logic [4:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
    output logic [31:0] AVL_READDATA		// Avalon-MM Read Data
	//output logic HASHLOOP_DONE
);

logic LD_HASH, COMPRESSION_EN, CTRL_LOAD_REG, load_ctr_reset, compression_ctr_reset, SET_HASH, SET_COMPRESSION, COMPRESSION_TIMER_EN, 
		START, HASHLOOP_DONE;
logic [5:0] CUR_MESSAGE_REG, i;
logic [31:0] W [64];
logic [31:0] H [8];
logic [31:0] K [64];
logic [31:0] a, b, c, d, e, f, g, h;
logic [31:0] DATA_ARRAY [26];
logic [31:0] HASH_DONE_ADDR;// = {31'h0000, HASHLOOP_DONE};

//assign HASH_DONE_ADDR = {31'h0000, HASHLOOP_DONE};

always_ff @(posedge CLK)
    begin
        if(AVL_READ)
            AVL_READDATA <= DATA_ARRAY[AVL_ADDR];

        if(AVL_WRITE)
            DATA_ARRAY[AVL_ADDR] <= AVL_WRITEDATA;
				
		if(~AVL_WRITE)
		begin
			DATA_ARRAY[17] <= H[0];
			DATA_ARRAY[18] <= H[1];
			DATA_ARRAY[19] <= H[2];
			DATA_ARRAY[20] <= H[3];
			DATA_ARRAY[21] <= H[4];
			DATA_ARRAY[22] <= H[5];
			DATA_ARRAY[23] <= H[6];
			DATA_ARRAY[24] <= H[7];

		end
		if(COMPRESSION_EN)
			DATA_ARRAY[25] <= 32'h0000;
		
		if(HASHLOOP_DONE)
				DATA_ARRAY[16] <= 32'h0001;
    end

	 always_comb
		begin
			START = DATA_ARRAY[25][0];
		end

control control(.CLK, .RESET, .START, .LD_HASH, .COMPRESSION_EN, .CTRL_LOAD_REG, .SET_COMPRESSION, .load_ctr_reset, 
				.compression_ctr_reset, .i, .CUR_MESSAGE_REG, .SET_HASH, .COMPRESSION_TIMER_EN, .HASHLOOP_DONE);

MessageSchedule MessageSchedule(.CLK, .RESET, .CUR_MESSAGE_REG, .CTRL_LOAD_REG, .W, .DATA_ARRAY);

compression compression(.CLK, .SET_COMPRESSION, .COMPRESSION_EN, .i, .W, .H, .K, .a, .b, .c, .d, .e, .f, .g, .h);

hashvals hashvals(.LD_HASH, .CLK, .a, .b, .c, .d, .e, .f, .g, .h, .H, .SET_HASH);

kvals kvals(.K);

//counters
load_ctr load_ctr(.CTRL_LOAD_REG, .load_ctr_reset, .CLK, .CUR_MESSAGE_REG);

compression_ctr compression_ctr(.COMPRESSION_TIMER_EN, .compression_ctr_reset, .CLK, .i);

endmodule