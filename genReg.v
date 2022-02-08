module genReg(
	output reg [31:0] Q,
	input [31:0] D,
	input en, clr, clk
);
	initial Q = 0;
	always @(posedge clk)
	begin
		if(clr)
			Q = 0;
		else if(en)
			Q = D;
	end
endmodule
