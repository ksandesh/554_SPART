`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Company: 554 Badgers
// Engineer: Chandana, Sandesh, Albert
// 
// Create Date: 	Sept 13, 2014
// Design Name: 	RX
// Module Name:    	RX 
// Project Name: 	SPART
// Target Devices:  XUPV505-LX110T
// Tool versions:   Xilinx-ISE
// Description:  	The receiver module detects the start bit when there is dip in the signal and goes to RECEIVE state. It samples the data coming 
//					in at baud rate, and stores it in a buffer. When all the 8 data bit and the stop bit arrive, the RDA signal is asserted. 
//					Upon receiving the READ ack signal from driver, the receiver drives the data onto a tri-state 8 bit bus interface and
//					de-asserts the RDA signal and goes to IDLE state.
//					
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RX(
	input clk,
    input rx_enable,
    input rst,
	input read,
    output reg rda,  
    output reg [7:0] rx_out,
    input rxd
    );
    
    
    reg [ 7:0] rx_buffer;
    reg [ 7:0] rx_shift_reg;
    reg        rx_start;
    reg        rx_sample1;
    reg        rx_sample2;
    reg [ 3:0] rx_index;                  		
    reg [ 3:0] rx_enable_counter;               
    reg        rx_error;     // For debugging purposes
    reg        rx_over_run;  // For debugging purposes
   
     
    
    always@(posedge clk, posedge rst) begin
		if(rst) begin
			rx_shift_reg <= 8'b11111111;
			rx_sample1   <= 1;
			rx_sample2   <= 1;
			rx_index     <= 0;                  
			rx_enable_counter <= 0;               
			rx_start     <= 0;
			rx_error     <= 0;
			rx_out <= 0;
			rda <= 0;
 		end
		else if(read) begin             // when the driver issues read signal, output the data in the buffer, and de-assert rda.
			rx_out <= rx_shift_reg;
			rda <= 0;
		end 
		else if(rx_enable) begin        // rx_enable is generated at baud rate with n=4
		
			rx_sample1 <= rxd;   		// Load input rxd to sample1
			rx_sample2 <= rx_sample1;  	// double flop to synchronise the input bit received.
          
			if( (rx_start == 0) && (rx_sample2 == 0) ) begin  // start bit detected, when rx_sample2 becomes low
				rx_start <= 1'b1;
				rx_enable_counter <= 1;
				rx_index <= 0;
			end
              
           
			if( rx_start == 1) begin
				rx_enable_counter <= rx_enable_counter + 1;
                 
				// Shift data to the right. Assumption LSB is received first
				if( rx_enable_counter == 7 ) begin			// Sample data in the middle 
					rx_index <= rx_index + 1;
					if( (rx_index > 0) && (rx_index < 9) ) begin  // If its a valid bit, put it into shift register.
						rx_shift_reg[7:0] <= { rx_sample2, rx_shift_reg[7:1]};
					end                
					else if( rx_index == 9) begin // Reset the registers after all bits are received.
						rx_index <= 0;
                        rx_start <= 0;
						if ( rx_sample2 != 1) begin // check if the end of transmit is received without error
							rda <= 0;
							rx_error <= 1;
						end
						else begin
							rda <= 1;   				// data is available for read
							rx_error <= 0;
							rx_over_run <= (rda)? 1: 0;
						end
					end
                end
			end
		end
	end
	
endmodule

