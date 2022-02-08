module NEG_gate(
	input [31:0] A,
	output [31:0] Q);
	
	wire [31:0] i; 
	wire out;
	NOT_gate not_gate(A, i);
	Add add_op(Q, out, i, 32'd1, 0);
	
endmodule
