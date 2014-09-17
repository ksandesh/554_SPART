//////////////////////////////////////////////////////////////////////////////////
// Company: 		554 Badgers
// Engineer: 		Chandana
// 
// Create Date:   	Sept 14, 2014
// Design Name: 	tb_TX
// Module Name:    	tb_TX 
// Project Name: 	SPART
// Target Devices:  XUPV505-LX110T
// Tool versions: 
// Description:     Test Bench to check if TX is transmitting data at baudrate
// 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tb_TX;

	reg clk;
    reg tx_enable;
    reg rst;
	reg write;
    wire txd;
    reg [7:0] tx_in;
    wire tbr;
	
	TX TX0(clk,tx_enable,rst,write,txd,tx_in,tbr); // Instantiate DUT
	
	initial begin
	clk = 0;
	rst = 1;
	tx_enable = 0;
	write = 0;
	end
	
	always  #5  clk = ~ clk ;  // generate clk
	
	always  begin         // generate tx_enable every 40 clock cycles
	#300 tx_enable = 1;
	#10 tx_enable = 0; 
	end
	
	initial begin
	#100 write = 1; tx_in = 8'b00100010;   // send data to input
	#400 write = 0; 
	end
	
	initial begin
	# 22 rst = 1'b0;   //disabling reset  
	end

endmodule
