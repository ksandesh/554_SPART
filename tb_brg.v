module tb_brg();
reg clk;			
reg rst;			
reg load_low;		
reg load_high;		
reg [7:0]data_in;	
wire tx_enable, rx_enable;

brg brg0(clk,rst,load_low,load_high,data_in,tx_enable,rx_enable);

always	#5 clk = ~ clk;

initial begin
rst = 1;
clk = 0;
load_low = 0;
load_high = 0;
end

initial begin
#7 rst = 0;
#40 load_high = 1 ; load_low=0; data_in = 8'h02;
#10 load_low= 1; load_high = 0; data_in = 8'h8b; 
#10 load_low = 0; load_high = 0; data_in = 8'b0;
#100000 $stop;
end
endmodule