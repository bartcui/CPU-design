module CONFF_Logic(
	output reg conditionMet,
	input signed [31:0] busOut,
	input [3:0] C2,
	input CONin
);
	wire [15:0] C2_Decoded;
	reg busNor, D;
	
	decoder_4_16 DEC(C2_Decoded, C2);
	
	integer i;
	
	always @(busOut or C2_Decoded)
	begin
		busNor = 0;
		for(i = 0; i < 32; i = i + 1) begin
			busNor = busNor || busOut[i];
		end
		busNor = !busNor;
		
		if(C2_Decoded[15:0] == 0 && busNor)
			D = 1;
		else if(C2_Decoded[15:0] == 1 && !busNor)
			D = 1;
		else if(C2_Decoded[15:0] == 2 && !busOut[31])
			D = 1;
		else if(C2_Decoded[15:0] == 3 && busOut[31])
			D = 1;
	end

	always @(CONin)
	begin
		conditionMet = D;
	end
	
endmodule
		