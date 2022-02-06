module SHIFT_left(
	input wire [31:0] in, shift,
	output wire [31:0] out);

	assign out[31:0] = in<<shift;
endmodule