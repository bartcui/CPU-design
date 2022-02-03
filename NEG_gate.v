module NEG_gate(
	input wire [31:0] A,
	output wire [31:0] Q);
	
	wire [31:0] i; 
	wire out;
	NOT_gate not_gate(.A(A),.Q(i));
	Add add_op(.c_out(out),.sum(Rz), .A(i), .B(32'd1), .c_in(1'd0) );
	
endmodule