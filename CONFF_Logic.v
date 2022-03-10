`timescale 1ns/10ps
module CONFF_Logic(
	output reg conditionMet,
	input [31:0] busOut,
	input [3:0] C2,
	input CONin
);
	reg busNor, D;
	
	integer i;
	
	always @(busOut or C2)
	begin
		busNor = 0;
		for(i = 0; i < 32; i = i + 1) begin
			busNor = busNor || busOut[i];
		end
		busNor = !busNor;
		
		if(C2 == 4'b0000 && busNor)
			D = 1;
		else if(C2 == 4'b0001 && !busNor)
			D = 1;
		else if(C2 == 4'b0010 && !busOut[31])
			D = 1;
		else if(C2 == 4'b0011 && busOut[31])
			D = 1;
	end

	always @(posedge CONin)
	begin
		#3 conditionMet = D;
	end
	
endmodule
		