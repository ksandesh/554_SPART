//////////////////////////////////////////////////////////////////////////////////
// Company: 		554 Badgers
// Engineer: 		Chandana
// 
// Create Date:   	Sept 14, 2014
// Design Name: 	tb_RX
// Module Name:    	tb_RX 
// Project Name: 	SPART
// Target Devices:  XUPV505-LX110T
// Tool versions: 
// Description:     Test bench to check if the RX module is working fine.
// 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module RX_tb ();
	reg clk;
    reg rx_enable;
    reg rst;
	reg read;
    wire rda;  
    wire [7:0] rx_out;
    reg rxd;
	
	RX RX0 (clk, rx_enable, rst, read, rda, rx_out, rxd); // Instantiate DUT
	
	initial begin
	clk = 0;
	rx_enable = 0;
	rst = 1;
	rxd = 1;
	read = 0;
	end
	
	always 
	#5 clk = ~clk;  // generate clk
	
	always begin  	// generate rx_enable every 40 clk cycles
	#390 rx_enable = 1;
	#10  rx_enable = 0;
	end
	
	initial begin  // send data in serially. Keep each bit for 40*16 clk cycles
	#22  rst = 0;
	#6400 rxd = 0; // start bit
	#6400 rxd = 0;
	#6400 rxd = 0;
	#6400 rxd = 1;
	#6400 rxd = 0;
	#6400 rxd = 0;
	#6400 rxd = 0;
	#6400 rxd = 1;
	#6400 rxd = 0;
	#6400 rxd = 1; // stop
	#6500 read = 1;
	
	end
	
	
	
	
	
endmodule
