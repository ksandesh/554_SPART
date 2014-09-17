module RX_tb ();
	reg clk;
    reg rx_enable;
    reg rst;
	reg read;
    wire rda;  
    wire [7:0] rx_out;
    reg rxd;
	
	RX RX0 (clk, rx_enable, rst, read, rda, rx_out, rxd);
	
	initial begin
	clk = 0;
	rx_enable = 0;
	rst = 1;
	rxd = 1;
	read = 0;
	end
	
	always 
	#5 clk = ~clk;
	
	always begin  // baudrate is default.
	#390 rx_enable = 1;
	#10  rx_enable = 0;
	end
	
	initial begin
	#22  rst = 0;
	#6400 rxd = 0; // start bit
	#6400 rxd = 0;
	#6400 rxd = 0;
	#6400 rxd = 1;
	#6400 rxd = 0;
	#6400 rxd = 0;
	#6400 rxd = 0;
	#6400 rxd = 1;
	#6400 rxd = 0;
	#6400 rxd = 1; // stop
	#6500 read = 1;
	
	end
	
	
	
	
	
endmodule
