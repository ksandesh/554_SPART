//////////////////////////////////////////////////////////////////////////////////
// Company: 		554 Badgers
// Engineer: 		Chandana
// 
// Create Date:   	Sept 14, 2014
// Design Name: 	tb_brg
// Module Name:    	tb_brg 
// Project Name: 	SPART
// Target Devices:  XUPV505-LX110T
// Tool versions: 
// Description:     Test bench to check if rx_enable and tx_enable is being generated.
// 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tb_brg();
reg clk;			
reg rst;			
reg load_low;		
reg load_high;		
reg [7:0]data_in;	
wire tx_enable, rx_enable;

brg brg0(clk,rst,load_low,load_high,data_in,tx_enable,rx_enable); // Instantiate DUT

always	#5 clk = ~ clk;  // generate clock

initial begin
rst = 1;
clk = 0;
load_low = 0;
load_high = 0;
end

initial begin
#7 rst = 0;
#40 load_high = 1 ; load_low=0; data_in = 8'h02;  // Set baudrate of 9600
#10 load_low= 1; load_high = 0; data_in = 8'h8b; 
#10 load_low = 0; load_high = 0; data_in = 8'b0;
#100000 $stop;
end
endmodule