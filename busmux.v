`timescale 1ns/10ps
module busmux(
	output reg [31:0] out,
	input wire [4:0] s,
	input [31:0] r0,
	input [31:0] r1,
	input [31:0] r2,
	input [31:0] r3,
	input [31:0] r4,
	input [31:0] r5,
	input [31:0] r6,
	input [31:0] r7,
	input [31:0] r8,
	input [31:0] r9,
	input [31:0] r10,
	input [31:0] r11,
	input [31:0] r12,
	input [31:0] r13,
	input [31:0] r14,
	input [31:0] r15,
	
	input [31:0] HI,
	input [31:0] LO,
	input [31:0] Zhigh,
	input [31:0] Zlow,
	input [31:0] PC,
	input [31:0] MDR,
	input [31:0] InPort,
	input [31:0] C_sign_extended
);
	always @(*)
		begin
			case(s)
				5'd0 : out <= r0[31:0];
				5'd1 : out <= r1[31:0];
				5'd2 : out <= r2[31:0];
				5'd3 : out <= r3[31:0];
				5'd4 : out <= r4[31:0];
				5'd5 : out <= r5[31:0];
				5'd6 : out <= r6[31:0];
				5'd7 : out <= r7[31:0];
				5'd8 : out <= r8[31:0];
				5'd9 : out <= r9[31:0];
				5'd10: out <= r10[31:0];
				5'd11 : out <= r11[31:0];
				5'd12 : out <= r12[31:0];
				5'd13 : out <= r13[31:0];
				5'd14 : out <= r14[31:0];
				5'd15 : out <= r15[31:0];
				5'd16 : out <= HI[31:0];
				5'd17 : out <= LO[31:0];
				5'd18 : out <= Zhigh[31:0];
				5'd19 : out <= Zlow[31:0];
				5'd20 : out <= PC[31:0];
				5'd21 : out <= MDR[31:0];
				5'd22 : out <= InPort[31:0];
				5'd23 : out <= C_sign_extended[31:0];
				default: out <= 32'd0;
			endcase
		end
endmodule