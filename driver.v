`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 		Team 3
// Engineer:		Sandesh
// 
// Create Date: 	Sept 13, 2014
// Design Name: 	Processor
// Module Name:  	driver 
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

`define DBH4800 8'h05
`define DBL4800 8'h16
`define DBH9600 8'h02
`define DBL9600 8'h8b
`define DBH19200 8'h01
`define DBL19200 8'h64
`define DBH38400 8'h00
`define DBL38400 8'hA3


module driver(
    input clk,
    input rst,
    input [1:0] br_cfg,
    output reg iocs,
    output reg iorw,
    input rda,
    input tbr,
    output reg[1:0] ioaddr,
    inout [7:0] databus
    );
	
	parameter CLEAR		= 3'b000;
	parameter LOAD_DBH	= 3'b001;
	parameter LOAD_DBL 	= 3'b010;
	parameter WAIT1 	= 3'b011;
	parameter READ 		= 3'b100;
	parameter WAIT2 	= 3'b101;
	parameter WRITE 	= 3'b110;
	//parameter CLEAR 	= 3'b110;
	
	reg			iocs_reg,iorw_reg;
	reg	[ 1:0]	ioaddr_reg;
	reg	[ 7:0] 	data;
	reg			send;	// send data to SPART if send is 1 
	reg	[ 7:0]	DBH, DBL;
	reg [ 7:0]  data_buffer;
	reg [ 2:0]	state, next_state;
	// Question: Do we really need to check if iocs == 1?
	assign databus = ((iocs == 1) && (iorw == 0))? data : 8'bzzzzzzzz ;  	// data = data_buffer when driver is sending data
												// data = DBH when driver is sending data to DBH
												// data = DBL when driver is sending data to DBL
	//assign iocs 	= iocs_reg;
	//assign iorw 	= iorw_reg;
	//assign ioaddr 	= ioaddr_reg;
	
	
	always@(posedge clk) begin
		if(rst)
			data_buffer <= 8'bxxxxxxxx;
		else if ((iocs == 1) && (iorw == 1) && (state == READ)) // Sandesh: Added additional condition to ....
			data_buffer <= databus;
	end
		
	always@(br_cfg) begin
		case(br_cfg) 
			2'b00:	begin   DBH = `DBH4800;		DBL = `DBL4800;	end
			2'b01:	begin	DBH = `DBH9600;		DBL = `DBL9600;	end	
			2'b10:	begin	DBH = `DBH19200;	DBL = `DBL19200;	end
			2'b11:	begin	DBH = `DBH38400;	DBL = `DBL38400;	end
			default:begin	DBH = `DBH9600;		DBL = `DBL9600;	end
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
			next_state = LOAD_DBL; // Go to the next state after some time
		LOAD_DBL:
			next_state = WAIT1;	
		WAIT1:
			if(rda == 1)
				next_state = READ;
			else 
				next_state = WAIT1;			
		READ:
			if(rda == 1)
				next_state = READ;
			else
				next_state = WAIT2;
		WAIT2:
			if(tbr == 1)
				next_state = WRITE;
			else
				next_state = WAIT2;
		WRITE:
			if(tbr == 1)
				next_state = WRITE;
			else
				next_state = WAIT1;	
		default:
				next_state = CLEAR;
		endcase
	end
	
	always@(*)
	begin
	ioaddr = 2'bxx;         // This wont work if ioaddr is an output, It must be a reg
	data = data_buffer;
	iocs = 1'b0;
	iorw = 0;			// Sandesh: Should this be 0??? or X
		case(state)
			CLEAR:
				;		// don't care about output but this shouldn't cause false triggering in SPART
			LOAD_DBH:
			   begin
				ioaddr = 2'b11;
				iocs = 1'b1;
				iorw = 1'b0;
				data = DBH;
				end
			LOAD_DBL:
			   begin
				ioaddr = 2'b10;
				iocs = 1'b1;
				iorw = 1'b0;
				data = DBL;
				end
			WAIT1:
				;		// don't care about output but this shouldn't cause false triggering in SPART
			READ:
			   begin
				ioaddr = 2'b00;
				iocs = 1'b1;
				iorw = 1'b1;
				end
			WAIT2:
				;		// don't care about output but this shouldn't cause false triggering in SPART
			WRITE:
			   begin
				ioaddr = 2'b00;
				iocs = 1'b1;
				iorw = 1'b0;
				data = data_buffer;	
				end
				//assert write
			default:
				;		// don't care about output but this shouldn't cause false triggering in SPART
		endcase
	end
endmodule
