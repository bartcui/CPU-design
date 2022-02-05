module Sub(
	output [31:0] RC,
	output c_out,
	input [31:0] RA, RB
);
	wire [31:0] RBneg;
	NEG_gate(RB, RBneg);
	Add(RC, c_out, RA, RBneg, 0);
endmodule
