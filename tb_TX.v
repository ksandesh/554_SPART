module tb_TX;

	reg clk;
    reg tx_enable;
    reg rst;
	reg write;
    wire txd;
    reg [7:0] tx_in;
    wire tbr;
	
	TX TX0(clk,tx_enable,rst,write,txd,tx_in,tbr);
	
	initial begin
	clk = 0;
	rst = 1;
	tx_enable = 0;
	write = 0;
	end
	
	always  #5  clk = ~ clk ;
	
	always  begin
	#300 tx_enable = 1;
	#10 tx_enable = 0; 
	end
	
	initial begin
	#100 write = 1; tx_in = 8'b00100010;
	#400 write = 0; 
	end
	
	initial begin
	# 22 rst = 1'b0; //disabling reset  
	end

endmodule
