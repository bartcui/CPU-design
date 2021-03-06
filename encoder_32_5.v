`timescale 1ns/10ps
module encoder_32_5(
	output reg [4:0] s,
	input wire [31:0] in
);
	//00000001, 00000010, 00000100
	always @(*)
	begin
		case(in)
			32'h00000001 : s <= 5'd0;
			32'h00000002 : s <= 5'd1;
			32'h00000004 : s <= 5'd2;
			32'h00000008 : s <= 5'd3;
			32'h00000010 : s <= 5'd4;
			32'h00000020 : s <= 5'd5;
			32'h00000040 : s <= 5'd6;
			32'h00000080 : s <= 5'd7;
			32'h00000100 : s <= 5'd8;
			32'h00000200 : s <= 5'd9;
			32'h00000400 : s <= 5'd10;
			32'h00000800 : s <= 5'd11;
			32'h00001000 : s <= 5'd12;
			32'h00002000 : s <= 5'd13;
			32'h00004000 : s <= 5'd14;
			32'h00008000 : s <= 5'd15;
			32'h00010000 : s <= 5'd16;
			32'h00020000 : s <= 5'd17;
			32'h00040000 : s <= 5'd18;
			32'h00080000 : s <= 5'd19;
			32'h00100000 : s <= 5'd20;
			32'h00200000 : s <= 5'd21;
			32'h00400000 : s <= 5'd22;
			32'h00800000 : s <= 5'd23;
			default: s <= 5'd31;
      endcase
   end
endmodule
