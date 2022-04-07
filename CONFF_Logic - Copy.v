`timescale 1ns/10ps
module CONFF_Logic(
	output reg conditionMet,
	input [31:0] busOut,
	input [3:0] C2,
	input CONin
);
	reg busNor, D;
	
	initial conditionMet = 0;
	
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
		else if(C2 == 4'b0100 && !busNor)
			D = 1;
		else if(C2 == 4'b1000 && !busOut[31])
			D = 1;
		else if(C2 == 4'b1100 && busOut[31])
			D = 1;
		else
			D = 0;
	end

	always @(posedge CONin)
	begin
		#3 conditionMet = D;
	end
	
endmodule
		