module DIV(
input signed [31:0] D, Q, 
output reg [31:0] Zhi,Zlo);
	
	always @ (D or Q)
	begin
		Zhi = D % Q;
		Zlo = (D - Zhi) / Q;
	end
				
endmodule