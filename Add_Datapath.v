module Datapath(
	output reg [63:0] out,
	input PCout, Zhiout, Zlowout, MDRout, R2out, R4out,
   input MARin, Zin, PCin, MDRin, IRin, Yin,    
   input IncPC, Read, ADD, R5in, R2in, R4in,	//Add other signals for different operations (SUB, DIV, etc)
   input Clock, Clear, 
   input [31:0] Mdatain
);
	reg [31:0] encIn;
	always @(*) begin
		encIn = {2'b0, R2out, 1'b0, R4out, 11'b0, 2'b0, Zhiout, Zlowout, PCout, MDRout, 10'b0};
	end
	
	wire [4:0] s;
	encoder_32_5 busEnc(s, encIn);
	
	wire [31:0] busOut;
	reg [63:0] Z;
	wire [63:0] Zinter;

	wire [31:0] R2, R4, R5, PC, IR, ZHi, ZLo, Y, MAR, MDRo;
	genReg R2ff(R2, busOut, R2in, Clear, Clock);
	genReg R4ff(R4, busOut, R4in, Clear, Clock);
	genReg R5ff(R5, busOut, R5in, Clear, Clock);
	PCReg PCff(PC, busOut, PCin, Clear, Clock, IncPC);
	genReg IRff(IR, busOut, IRin, Clear, Clock);
	genReg ZHiff(ZHi, Z[31:0], Zin, Clear, Clock);
	genReg ZLoff(ZLo, Z[63:32], Zin, Clear, Clock);
	genReg Yff(Y, busOut, Yin, Clear, Clock);
	genReg MARff(MAR, busOut, MARin, Clear, Clock);
	MDR MDRreg(MDRo, busOut, Mdatain, MDRin, Clock, Clear, Read);
	
	//Add the other operations needed for the datapath
	Add add(Zinter[31:0], Zinter[32], Y, busOut, 0);
	
	busmux BUS(busOut, s, 32'b0, 32'b0, R2, 32'b0, R4, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0,
					32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, ZHi, ZLo, PC, MDRo);
	
	always @(*) begin
		if(ADD)
			Z <= Zinter;
			out <= Zinter;
	end
endmodule