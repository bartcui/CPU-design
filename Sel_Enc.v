module Sel_Enc(
	output reg[15:0] RegIn, RegOut, 
	output reg[31:0] C_sign_extended,
	input Gra, Grb, Grc, Rin, Rout, BAout,
	input [31:0] IR
);
	reg[3:0] regSel;
	wire[15:0] regSelDec;
	
	decoder_4_16 Decoder(regSelDec, regSel);
	
	always@(*)
	begin
		if(Gra)
			regSel = IR[26:23];
		else if(Grb)
			regSel = IR[22:19];
		else if(Grc)
			regSel = IR[18:15];
			
		if(Rin)
			begin
				RegIn = regSelDec;
				RegOut = 0;
			end
		else if(Rout || BAout)
			begin
				RegIn = 0;
				RegOut = regSelDec;
			end
		else
			begin
				RegIn = 0;
				RegOut = 0;
			end
		
		if(IR[18] == 1)
			C_sign_extended = {13'b1111111111111, IR[18:0]};
		else
			C_sign_extended = {13'b0000000000000, IR[18:0]};
		
	end

endmodule
