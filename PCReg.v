`timescale 1ns/10ps
module PCReg(
	output reg [31:0] Q,
	input [31:0] D, 
	input br, clr, clk, IncPC
);
	initial Q = 0;
	always @(posedge clk)
	begin
		if(IncPC)
			Q = Q + 4;
		else if(clr)
			Q = 0;
		else if(br)
			Q = D;
	end
endmodule 