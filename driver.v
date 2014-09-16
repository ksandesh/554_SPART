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
	
	parameter CLEAR		= 3'b000;
	parameter LOAD_DBH	= 3'b001;
	parameter LOAD_DBL 	= 3'b010;
	parameter WAIT1 	= 3'b011;
	parameter READ 		= 3'b100;
	parameter WAIT2 	= 3'b101;
	parameter WRITE 	= 3'b110;
	//parameter CLEAR 	= 3'b110;
	
	reg	[ 7:0] 	data;
	reg			send;	// send data to SPART if send is 1 
	reg	[ 7:0]	DBH, DBL;
	reg [ 7:0]  data_buffer;
	reg [ 2:0]	state, next_state;
	// Question: Do we really need to check if iocs == 1?
	assign databus = ((iocs == 1) && (iorw == 0))? data : z ;  	// data = data_buffer when driver is sending data
												// data = DBH when driver is sending data to DBH
												// data = DBL when driver is sending data to DBL
												
	always@(posedge clk) begin
		if(rst)
			data_buffer <= 8'hxx;
		else
			data_buffer <= databus;
	end
		
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
			send <= 0;
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
			next_state = WAIT;	
		WAIT1:
			if(rda == 1)
				next_state = READ;
			else 
				next_state = WAIT:			
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
	end
	
	always@(state)
	begin
	ioaddr = 2'bxx;
	data = data_buffer;
	iocs = 1'b0;
	iorw = 0;			// Sandesh: Should this be 0??? or X
		case(state)
			CLEAR:
				;		// don't care about output but this shouldn't cause false triggering in SPART
			LOAD_DBH:
				ioaddr = 2'b11;
				iocs = 1'b1;
				iorw = 1'b0;
				data = DBH;
			LOAD_DBL:
				ioaddr = 2'b10;
				iocs = 1'b1;
				iorw = 1'b0;
				data = DBL;
			WAIT1:
				;		// don't care about output but this shouldn't cause false triggering in SPART
			READ:
				ioaddr = 2'b00;
				iocs = 1'b1;
				iorw = 1'b1;
			WAIT2:
				;		// don't care about output but this shouldn't cause false triggering in SPART
			WRITE:
				ioaddr = 2'b00;
				iocs = 1'b1;
				iorw = 1'b0;
				data = data_buffer;	
				//assert write
			default:
				;		// don't care about output but this shouldn't cause false triggering in SPART
	end
endmodule
