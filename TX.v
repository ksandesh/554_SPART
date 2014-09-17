`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		554 Badgers
// Engineer: 		Chandana, Albert
// 
// Create Date:   	Sept 14, 2014
// Design Name: 	TX
// Module Name:    	TX 
// Project Name: 	SPART
// Target Devices:  XUPV505-LX110T
// Tool versions: 
// Description:     The transmitter module receives data from the processor, and sends it serially at baud rate.
// 
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TX(
	input clk,
    input tx_enable,
    input rst,
	input write,
    output reg txd,
    input [7:0] tx_in, // Input from the Driver
    output reg tbr
    );
	
	reg [7:0] tx_buffer;
    reg [3:0] count;
 
	always@(posedge clk) // tx_clk counts at baud rate 
	begin
		if(rst)
			begin
			tbr <= 1;
			tx_buffer <= 8'b11111111;
			txd <= 1;
			count <=0;
			end
		else if(tx_enable)
			begin
			if( write && tbr)      // when the processor asserts write, sample data from the databus into the tx_buffer. De-assert tbr.
				begin
				tx_buffer <= tx_in;
				tbr <= 0;
				end
			else if(tbr==0)       // Send data serially , after the data has been received. TRANSMIT STATE
				begin
				if        (count == 4'd0)     begin count <= count+1; txd <= 1'b0        ; end  //start bit
				else if   (count == 4'd1)     begin count <= count+1; txd <= tx_buffer[0]; end
				else if   (count == 4'd2)     begin count <= count+1; txd <= tx_buffer[1]; end
				else if   (count == 4'd3)     begin count <= count+1; txd <= tx_buffer[2]; end
				else if   (count == 4'd4)     begin count <= count+1; txd <= tx_buffer[3]; end
				else if   (count == 4'd5)     begin count <= count+1; txd <= tx_buffer[4]; end
				else if   (count == 4'd6)     begin count <= count+1; txd <= tx_buffer[5]; end
				else if   (count == 4'd7)     begin count <= count+1; txd <= tx_buffer[6]; end
				else if   (count == 4'd8)     begin count <= count+1; txd <= tx_buffer[7]; end
				else /*if (count == 4'd9)*/   begin count <= 0      ; txd <= 1'b1        ; tbr <= 1; end // stop bit			
				end 
			else
				begin          // IDLE state
				count <= 0;
				txd <= 1;
				tbr <= 1;
				tx_buffer <= 8'b11111111;
				end
			end
				
	end
endmodule


			
    

    
    
