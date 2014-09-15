//////////////////////////////////////////////////////////////////////////////////
// Company: Team 3
// Engineer:	Sandesh
// 
// Create Date: Sept 13, 2014
// Design Name: Processor
// Module Name:    driver 
// Project Name: SPART
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

`define DBH4800 0x05
`define DBL4800 0x16
`define DBH9600 0x02
`define DBH9600 0x8B
`define DBH19200 0x01
`define DBL19200 0x64
`define DBH38400 0x00
`define DBH38400 0xA3


module driver(
    input clk,
    input rst,
    input [1:0] br_cfg,
    output iocs,
    output iorw,
    input rda,
    input tbr,
    output [1:0] ioaddr,
    inout [7:0] databus
    );

	reg	[ 7:0] 	data;
	reg			send;	// send data to SPART if send is 1 
	reg	[ 7:0]	DBH, DBL;
	
	always@(bfg_cfg) begin
		case(bfg_cfg) 
			2'b00:	DBH = DBH4800;	DBL = DBL4800;
			2'b01:	DBH = DBH9600;	DBL = DBL9600;
			2'b10:	DBH = DBH19200;	DBL = DBL19200;
			2'b11:	DBH = DBH38400;	DBL = DBL38400;
			default:DBH = DBH9600;	DBL = DBL9600;
		endcase
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			state <= CLEAR;
		else
			state <= next_state;		
	end
	
	// next state logic
	always@(state, rda, tbr) begin
		case(state)
		CLEAR:
			next_state = LOAD_DBH;
		LOAD_DBH:
			if (count == 5)
			next_state = LOAD_DBL;
			else 
			next_state = LOAD_DBH;
		LOAD_DBL:
			next_state = WAIT;	
		WAIT:
			if(rda == 1)
				next_state = READ;
			else 
				next_state = WAIT:
			
		READ:
			if(rda == 1)
			next_state = READ;
			else
			next_state = WRITE;
		
		WRITE:
			if(tbr == 1)
				next_state = WAIT;
			else
				next_state = WRITE;
				
		default:
	end
	
	always@(state)
	begin
	ioaddr = 2'b00;
	data = 8'd0;
	iocs = 1'b0;
	
		case(state)
			CLEAR:
				data = 0x00;
				//count = count + 1;
				;
			LOAD_DBH:
				//send = 1'b0;
				count = count + 1;
				ioaddr = 2'b11;
				data = DBH;
			LOAD_DBL:
				ioaddr = 2'b10;
				data = DBL;
			WAIT:
				ioaddr = 2'bxx;
				data = 2'dx;
			READ:
				ioaddr = 2'b00;
				
				
			WRITE:
				//assert write
			default:
	end
	
	
	reg	[ 7:0] data;
	always@(posedge clk, posedge rst) begin
		if( rst == 1 ) 
		begin
			data <= 0;
			send <= 0;
		end
		
		
		
		if ( rda == 1 ) 			// Wait till first rda is received
		begin
			 <= 1;
		end
		else 
	end

endmodule
