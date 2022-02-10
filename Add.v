`timescale 1ns/10ps
module Add(
	output [31:0] RC,
	output c_out,
	input [31:0] RA, RB,
	input c_in
);
	wire c_in16;
	Add_cla_16 M1(c_in16, RC[15:0], RA[15:0], RB[15:0], c_in);
	Add_cla_16 M2(c_out, RC[31:16], RA[31:16], RB[31:16], c_in16);
	
endmodule

module Add_cla_16(
	output c_out, 
	output [15:0] sum, 
	input [15:0] a, b, 
	input c_in
);
	wire	c_in4, c_in8, c_in12;
	Add_cla_4 M1(c_in4, sum[3:0], a[3:0], b[3:0], c_in);
	Add_cla_4 M2(c_in8, sum[7:4], a[7:4], b[7:4], c_in4);
	Add_cla_4 M3(c_in12, sum[11:8], a[11:8], b[11:8], c_in8);
	Add_cla_4 M4(c_out, sum[15:12], a[15:12], b[15:12], c_in12);
	
endmodule

module Add_cla_4(
	output c_out, 
	output [3:0] sum, 
	input [3:0] a, b, 
	input c_in
);
	wire [3:0] P, G, c;
	
	assign P = a^b;
	assign G = a&b;
	assign c[0] = c_in;
	assign c[1] = G[0] | (P[0]&c[0]);
	assign c[2] = G[1] | (P[1]&G[0]) | P[1]&P[0]&c[0];
	assign c[3] = G[2] | (P[2]&G[1]) | P[2]&P[1]&G[0] | P[2]&P[1]&P[0]&c[0];
	assign c_out = G[3] | (P[3]&G[2]) | P[3]&P[2]&G[1] | P[3]&P[2]&P[1]&G[0] | P[3]&P[2]&P[1]&P[0]&c[0];
	assign sum[3:0] =P^c;
	
endmodule