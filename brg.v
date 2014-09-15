//////////////////////////////////////////////////////////////////////////////////
// Company: Team 3
//////////////////////////////////////////////////////////////////////////////////
// Company: Team 3
// Engineer: 	ksandesh
// 
// Create Date:		Sept 14, 2014  
// Design Name: 	Baud Rate Generator
// Module Name:    	brg 
// Project Name: 	SPART
// Target Devices: 
// Tool versions: 
// Description: This module generates the required baud rate for the RX and TX modules.
//		The baud rate clock is named as rate_enable. Upon reset, an internal variable is
//	used to monitor if the baud rate values have been loaded or not. 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module brg(
    input clk,				// Same as main clock
    input rst,				
    input load_low;			// Load the DBL on next falling edge of clk
	input load_high;		// Load the DBH on next falling edge of clk
	input [7:0]data_in,		// There can be output reg, but can there be input reg?
    output reg brg_ready,	// Indicates if the rate_enable sigle is valid or not
	output sampling_clk	// Sampling clock used by receiver (2^n times baud rate)
    );
    
	reg	[ 1:0] brg_ready;		// Variable to indicate when the brg is ready to generate the rate_enable
	reg	[ 7:0] DBH, DBL;
	reg	[ 15:0] counter; 		// down counter to generate rate_enable
	reg	rate_enable;
	
	assign sampling_clk = rate_enable;
	// Divisor input load logic
	always@(negedge clk)		// This clock is made to work on negedge because input data will be changing on the posedge
	begin
		if(rst) begin
			db_low <= 0x02;
			db_high <= 0x8B;
			brg_ready <=1'b0;
		end
		else begin
			if(load_high == 1) begin
				DBH	<= data_in;
				brg_ready = brg_ready | 2'b01;
			end
			else if(load_low == 1) begin
				DBL <= data_in;
				brg_ready = brg_ready | 2'b10;
			end
		end
	end
	
	// Divisor counter load logic
	always@(posedge clk) begin
		if(rst) begin
			counter <= 16'd0;
		end 
		else if (rate_enable == 1)
			counter[15:8] <= DBH;
			counter[ 7:0] <= DBL;
		else end	
		else
			counter <= counter - 1;
		end
	end	
	
	// Divisor rate_enable logic
	always@(negedge clk) begin
		if(rst) begin
			rate_enable <= 1'b0;
		end
		else if (counter == 0) begin 
				rate_enable = 1'b1;
		end
		else begin 
				rate_enable = 1'b0;
		end
	end
	
endmodule