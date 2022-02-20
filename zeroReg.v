module zeroReg(
	output [31:0] Q,
	input [31:0] D,
	input en, clr, clk, BAout
);
	wire [31:0] A;
	genReg zeroReg(A, D, en, clr, clk);
	assign Q = BAout ? 0 : A;
endmodule
