module spart_top_tb ();

	reg clk;       
    reg rst;        
    wire txd;       
    reg rxd;       
    reg [1:0] br_cfg;
	
	top_level top_level0 (clk,rst,txd,rxd,br_cfg);
	
	initial begin
	rst =1;
	clk = 0;
	
	br_cfg = 2'b01;
	
	#22  rst = 0;
	
	end
	
	always 
	#5 clk = ~clk;
	
	initial begin
	rxd = 1;
	#640 rxd = 0; // start bit
	#6400 rxd = 1;
	#6400 rxd = 0;
	#6400 rxd = 1;
	#6400 rxd = 0;
	#6400 rxd = 0;
	#6400 rxd = 0;
	#6400 rxd = 1;
	#6400 rxd = 0;
	#6400 rxd = 1; // stop
	
	end
endmodule	
	
	