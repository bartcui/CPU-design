module NOT_gate(input wire [31:0] A, output wire [31:0] Q);

	genvar i;
	generate
		for (i=0; i<32, i=i+1) begin : loop
			assign Q[i] = !A[i];
		end
	endgenerate
endmodule
