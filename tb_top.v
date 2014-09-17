//////////////////////////////////////////////////////////////////////////////////
// Company: 		554 Badgers
// Engineer: 		Chandana, ksandesh
// 
// Create Date:   	Sept 14, 2014
// Design Name: 	TX
// Module Name:    	TX 
// Project Name: 	SPART
// Target Devices:  XUPV505-LX110T
// Tool versions: 
// Description:     Test bench to check the design at top level.
// 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spart_top_tb ();

	reg clk;       
    reg rst;        
    wire txd;       
    reg rxd;       
    reg [1:0] br_cfg;
	
	top_level top_level0 (clk,rst,txd,rxd,br_cfg); // Instantiate dut
	
	initial begin
	rst =1;
	clk = 0;
	
	br_cfg = 2'b01;  // set baud rate 9600
	
	#22  rst = 0;
	
	end
	
	always 
	#5 clk = ~clk;  // generate clk
	
	initial begin   // Send data in serially. Send each bit for 10417 clk cycles.
	rxd = 1;
	#640 rxd = 0; // start bit
	#104170 rxd = 1;
	#104170 rxd = 0;
	#104170 rxd = 1;
	#104170 rxd = 0;
	#104170 rxd = 0;
	#104170 rxd = 0;
	#104170 rxd = 1;
	#104170 rxd = 0;
	#104170 rxd = 1; // stop
	
	end
endmodule	
	
	