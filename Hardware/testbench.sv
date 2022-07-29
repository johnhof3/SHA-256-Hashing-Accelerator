module testbench();

timeunit 10ns;
timeprecision 1ns;

logic CLK;
//logic START;
logic RESET;
	
logic AVL_READ;
logic AVL_WRITE;

logic [4:0] AVL_ADDR;
logic [31:0] AVL_WRITEDATA;
logic [31:0] AVL_READDATA;

SHA256_ACCELERATOR top_level(.*);

always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

//hello world = 68656C6C6F20776F726C64
// 68656C6C
// 6F20776F
// 726C6480
// 00000000
// 00000000
// 00000000
// 00000000
// 00000000
// 00000000
// 00000000
// 00000000
// 00000000
// 00000000
// 00000000
// 00000000
// 00000058

initial begin: TEST_VECTORS
//START = 0;
RESET = 0;
AVL_READ = 0;
AVL_WRITE = 0;
AVL_ADDR = 5'b0000;
AVL_WRITEDATA = 32'h00000000;

#2 RESET = 1;
#2 RESET = 0;

#10 AVL_WRITEDATA = 32'h68656C6C;
#0 AVL_ADDR = 5'b0000;
#2 AVL_WRITE = 1;

#10 AVL_WRITEDATA = 32'h6F20776F;
#0 AVL_ADDR = 5'd1;

#10 AVL_WRITEDATA = 32'h726C6480;
#0 AVL_ADDR = 5'd2;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd3;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd4;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd5;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd6;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd7;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd8;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd9;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd10;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd11;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd12;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd13;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd14;

#10 AVL_WRITEDATA = 32'h00000058;
#0 AVL_ADDR = 5'd15;

#10 AVL_WRITEDATA = 32'h00000000;
#0 AVL_ADDR = 5'd16;

#10 AVL_WRITEDATA = 32'h00000001;
#0 AVL_ADDR = 5'd25;

#10 AVL_WRITE = 0;

//#20 START = 1;
//#2 START = 0;

end
endmodule