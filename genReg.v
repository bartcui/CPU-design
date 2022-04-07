`timescale 1ns/10ps
module genReg(
	output reg [31:0] Q,
	input [31:0] D,
	input en, clr, clk
);
	initial Q = 0;
	always @(posedge clk)
	begin
		if(clr)
			Q[31:0] = 32'b0;
		else if(en)
			Q[31:0] = D[31:0];
	end
endmodule