`timescale 1ns/10ps
module Min_Add_tb();
	wire [31:0] Z;
	reg [31:0] A;
	reg Clock, Enable;
	
	genReg Zff(Z[31:0], A, Enable, 0, Clock);
	
	initial begin
		Clock = 0; 
		forever #10 Clock = ~Clock;
	end
	initial begin
		#20 A <= 32'd12; Enable <= 1;
		#25 Enable <= 0;
	end
endmodule
