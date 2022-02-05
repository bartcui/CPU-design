module Mult_booth_bit(
	output reg [31:0] Zhi, Zlo,
	input signed [31:0] RM, RQ
);
	parameter 	plus1_0	= 3'b001,
					plus1_1	= 3'b010,
					plus2		= 3'b011,
					minus2	= 3'b100,
					minus1_0	= 3'b101,
					minus1_1 = 3'b110;
	
	reg [2:0]	bitCount;
	reg [32:0] Zinter [15:0];
	reg [63:0] Zexpanded [15:0];
	reg [63:0] Ztotal;
	
	wire [31:0] neg_RM;
	NEG_gate inv(RM, neg_RM);
	
	integer i, k;
	
	always @(RM or RQ) begin
		bitCount = {RQ[1:0], 1'b0};
		case(bitCount)
			plus1_0 	: Zinter[0] = {RM[31], RM};
			plus1_1 	: Zinter[0] = {RM[31], RM};
			plus2		: Zinter[0] = {RM, 1'b0};
			minus2	: Zinter[0] = {neg_RM, 1'b0};
			minus1_0	: Zinter[0] = {neg_RM[31], neg_RM};
			minus1_1	: Zinter[0] = {neg_RM[31], neg_RM};
			default	: Zinter[0] = 0;
		endcase
		Zexpanded[0] = $signed(Zinter[0]);
	
		for(k = 2; k<32; k = k+2)begin
				bitCount = {RQ[k+1], RQ[k], RQ[k-1]};
				case(bitCount)
					plus1_0 	: Zinter[k/2] = {RM[31], RM};
					plus1_1 	: Zinter[k/2] = {RM[31], RM};
					plus2		: Zinter[k/2] = {RM, 1'b0};
					minus2	: Zinter[k/2] = {neg_RM, 1'b0};
					minus1_0	: Zinter[k/2] = {neg_RM[31], neg_RM};
					minus1_1	: Zinter[k/2] = {neg_RM[31], neg_RM};
					default	: Zinter[k/2] = 0;
				endcase
				Zexpanded[k/2] = $signed(Zinter[k/2]);
				
				for (i=0; i<k/2; i=i+1)
					Zexpanded[k/2] = {Zexpanded[k/2], 2'b00};
		end
		
		Ztotal = Zexpanded[0];
		
		for (i=1; i<k/2; i=i+1)
			Ztotal = Ztotal + Zexpanded[i];
		
		Zlo = Ztotal[31:0];
		Zhi = Ztotal[63:32];
	end	
	
endmodule
				