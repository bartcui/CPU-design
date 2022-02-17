module ZERO_REG(
	input [31:0] D,
	output [31:0] Q,
	input clr, clk, en, BAout
);
	wire [31:0] A;
	genReg zeroReg(A, D, en, clr, clk);
	assign Q = BAout ? 0 : A;
endmodule