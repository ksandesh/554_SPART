`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 		554 Badgers
// Engineer: 		Chandana, ksandesh
// 
// Create Date:		Sept 14, 2014  
// Design Name: 	Baud Rate Generator
// Module Name:    	brg 
// Project Name: 	SPART
// Target Devices:  XUPV505-LX110T
// Tool versions: 
// Description: 	This module generates the required baud rate for the RX and TX modules.
//					The baud rate clock is named as rate_enable. Upon reset, an internal variable is
//					used to monitor if the baud rate values have been loaded or not. 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module brg(
    input clk,				
    input rst,				
    input load_low,				 // Load the DBL on next falling edge of clk
	input load_high,			 // Load the DBH on next falling edge of clk
	input [7:0]data_in,		
	output tx_enable, rx_enable  // enable signals for TX and RX modules
    );
    
	reg	[ 1:0] brg_ready;		 // Variable to indicate when the brg is ready to generate the rate_enable
	reg	[ 7:0] DBH, DBL;         // Data buffer high, data buffer low
	reg	[ 15:0] counter_tx, counter_rx; 		// down counter to generate rate_enable
	reg [15:0] tx_clk_period;    // The divisor value with which counter is loaded to generate tx_enable
	reg [15:0] rx_clk_period;    // The divisor value with which counter is loaded to generate rx_enable
	
		
	// Divisor input load logic
	always@(posedge clk)		
	begin
		if(rst) begin
			DBH <= 8'h02;
			DBL <= 8'h8B;
			brg_ready <=2'b00;
		end
		else begin
			if(load_high == 1) begin // Loading DBH value
				DBH	<= data_in;
				brg_ready <= brg_ready | 2'b01;
			end
			else if(load_low == 1) begin   // Loading DBL value
				DBL <= data_in;
				brg_ready <= brg_ready | 2'b10;
			end
		end
	end

	// Count values to be loaded to TX counter and RX counter
	always@(*)
	begin
		tx_clk_period = {DBH[3:0], DBL[7:0],{4{1'b0}}}; // 16 times the value in rx_clk_period. left shifed by 4 bits
		rx_clk_period = {DBH, DBL};                     // Divisor value
	end
	
	// TX counter
	always@(posedge clk, posedge rst) 
	begin
		if(rst) 
			begin
			counter_tx <= 16'd0;
			end 
		else
			begin
			if( brg_ready == 2'b11 )
				begin
					if (counter_tx == 0)
						counter_tx <= tx_clk_period;
					else
						counter_tx <= counter_tx -1;
				end		
			end
	end
	
	// RX counter
	always@(posedge clk, posedge rst) 
	begin
		if(rst) 
			begin
			counter_rx <= 16'd0;
			end 
		else
			begin
			if( brg_ready == 2'b11 )
				begin
					if (counter_rx == 0)
						counter_rx <= rx_clk_period;  // counter_rx = counter_tx/16  the {DBH,DBL value is shifted right by 4 places.}
					else
						counter_rx <= counter_rx -1;
				end		
			end
	end
	// generate enable signals 
	assign tx_enable = (counter_tx == tx_clk_period)? 1: 0;
	assign rx_enable = (counter_rx == rx_clk_period)? 1: 0;
	
endmodule



