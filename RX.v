//////////////////////////////////////////////////////////////////////////////////
// Company: Team 3
// Engineer: Chandana, Sandesh, Albert
// 
// Create Date: 	Sept 13, 2014
// Design Name: 	RX
// Module Name:    	RX 
// Project Name: 	SPART
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module RX(
	input clk,
    input rx_clk,
    input rx_enable,
    input rst,
    input iocs,
    input iorw,
    output reg rx_rda,  
    output [7:0] rx_out,
    input rxd
    );
    
    
    reg [ 7:0] rx_buffer;
    reg [ 7:0] rx_shift_reg;
    reg        rx_start;
    reg        rx_sample1;
    reg        rx_sample2;
    reg [ 3:0] rx_index;                  // rx_cnt 
    reg [ 3:0] rx_enable_counter;               // rx_sample_cnt is rx_enable_counter;
    reg        rx_error;
    reg        rx_over_run;
   
    assign rx_out = rx_buffer;    
    
    always@(posedge rx_clk, posedge rst) begin
		if(rst) begin
		//	rx_buffer    <= 0;
			rx_shift_reg <= 0;
			rx_rda       <= 0;
			rx_sample1   <= 0;
			rx_sample2   <= 0;
			rx_index     <= 0;                  // rx_cnt 
			rx_enable_counter <= 0;               // rx_sample_cnt is rx_enable_counter;
			rx_start     <=0;
			rx_error     <= 0;
 		end
		else begin
       		// Start bit detection
			rx_sample1 <= rxd;   // Load input rxd to 
			rx_sample2 <= rx_sample1;
          
			if(rx_enable) begin
				if( (rx_start == 0) && (rx_sample2 == 0) ) begin
					rx_start <= 1'b1;
					rx_enable_counter <= 1;
					rx_index <= 0;
				end
              
              // Start bit is detected
				if( rx_start == 1) begin
					rx_enable_counter <= rx_enable_counter + 1;
                 
					// Shift data to the right. Assumption LSB is received first
					if( rx_enable_counter == 7 ) begin
						
						if( (rx_index > 0) && (rx_index < 9) ) begin
						   rx_shift_reg[7:0] <= { rx_sample2, rx_shift_reg[7:1]};
						end                
						else if( rx_index == 9) begin
                        rx_index <= 0;
                        rx_start <= 0;
							if ( rx_sample2 != 1) begin // check if the end of transmit is received without error
							   rx_rda <= 0;
							   rx_error <= 1;
							end
							else begin
								rx_rda <= 1;   // data is available for read
								rx_error <= 0;
								rx_over_run <= (rx_rda)? 1: 0;
							end
						end
                    end
                    else begin
                        rx_index <= rx_index + 1;
                    end
                     
                end
                
             // put data on the bus when requested by the processor, if rx_enable is not high always, then change the if else end logic.
/*			
			if(iorw && iocs) begin
					rx_buffer <= rx_shift_reg;
					rx_rda <= 0;
				end 
*/
				end // else  end   
          
		end // rx_enable
	end //always
    
	always@(negedge clk)  // Change this if you use a variable to complement the clock in the spart module
	begin
		if(rst) begin
			rx_buffer <= 0;
			rx_rda <= 0;
		end
		if(iorw && iocs) begin
					rx_buffer <= rx_shift_reg;
					rx_rda <= 0;
		end 
	end
endmodule


 

