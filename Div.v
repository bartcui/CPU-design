module Div(
input signed [31:0] D, Q, 
output reg [31:0] Zhi,Zlo);
	always @ (*)
	begin
		Zhi = D % Q;
		Zlo = (D - Zhi) / Q;
	end		
endmodule
