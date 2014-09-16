//////////////////////////////////////////////////////////////////////////////////
// Company: 		Team 3
// Engineer:		Sandesh
// 
// Create Date: 	Sept 16, 2014
// Design Name: 	Processor test bench
// Module Name:  	tb_driver 
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
module tb_driver();
	reg clk;
    reg rst;
    reg [1:0] br_cfg;
    reg rda;
    reg tbr;
	 wire iocs;
    wire iorw;
    wire [1:0] ioaddr;
    wire [7:0] databus;
	
	reg read, write, load_low, load_high;

	
	driver driver1(
		.clk(clk),
		.rst(rst),
		.br_cfg(br_cfg),
		.iocs(iocs),
		.iorw(iorw),
		.rda(rda),
		.tbr(tbr),
		.ioaddr(ioaddr),
		.databus(databus)
    );
	initial begin
		clk = 	0;
		rst	=	1;
		rda =	0;
		tbr =	1;
		br_cfg = 2'b00;  // Corresponding to 4800 baud rate
	end

	initial forever begin
		#5 clk <= ~clk;
	end

	
	   
	assign databus = ((iocs == 1) && (iorw == 1))? 10101010 : 8'bzzzzzzzz ;
	
	initial begin
		#22 rst	=	0;
		#92	rda	=	1;
		#22 rda = 	0;
		#22 tbr = 	0;
		#92	rda	=	1;
		#07 tbr = 	1;
		#22 rda = 	0;
		#22 tbr = 	0;
		#92	rda	=	1;
		#27 tbr = 	1;
		#22 rda = 	0;
		#32 tbr = 	0;
	end		


	always@(*) begin
		read = 0;
		write = 0;
		load_low = 0;
		load_high = 0;
		case({ioaddr,iocs,iorw})   // Sandesh: If we put 1110 instead of 4'b1110 we get wrong result
			4'b1110: load_high = 1;	
			4'b1010: load_low = 1;
			4'b0010: write = 1;
			4'b0011: read = 1;
			default:  ;
		endcase
	end
	
endmodule