`timescale 1ns/10ps
module AND_gate(
	input wire [31:0] A,B,
	output wire [31:0] Y);

	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin : loop
			assign Y[i] = ((A[i])&(B[i]));
		end
	endgenerate
endmodule