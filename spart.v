`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: 
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
module spart(
    input clk,
    input rst,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
    );
	
reg read, write, load_dbh, load_dbl;
	
RX RX1(
	.clk(clk),
	//.rx_enable(rx_enable),
	.rst(rst),
	.rda(rda),
	.rx_out(databus),
	.rxd(rxd),
	.read(read)
        );

TX TX1(
	.clk(clk),
	.rst(rst),
	.txd(txd),
	.tx_in(databus),
	.tbr(tbr),
	.write(write)
        );
	
brg brg1(
	.clk(clk),
    .rst(rst),				
    .load_low(load_low),			
	.load_high(load_high),		
	.data_in(databus),		
	.enable(enable)
		);


always@(*) begin
	read = 0;
	write = 0;
	load_low = 0;
	load_high = 0;
		case({ioaddr,iocs,iorw})
			1110:	// load high
			1010:
			0010:
			0011:
			default: 
				;
		endcase
endmodule