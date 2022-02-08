//Set this file as top level entity
`timescale 1ns/10ps
module Datapath(
	output reg [63:0] out,
	input PCout, Zhiout, Zlowout, MDRout, R2out, R4out, HIout, LOout,
   	input MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin,    
   	input IncPC, Read, R5in, R2in, R4in,
   	input Clock, Clear, 
   	input [31:0] Mdatain,
	input AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT
);
	reg [31:0] encIn;
	always @(*) begin
		encIn = {2'b0, R2out, 1'b0, R4out, 11'b0, HIout, LOout, Zhiout, Zlowout, PCout, MDRout, 10'b0};
	end
	
	wire [4:0] s;
	encoder_32_5 busEnc(s, encIn);
	
	wire [31:0] busOut;
	
	reg [63:0] Z;
	wire [32:0] ZAdd, ZSub;
	wire [63:0] ZMult;
	wire [31:0] ZNeg, ZNot;
	
	always @(*) begin
		if(ADD)
			Z <= ZAdd;
		else if(SUB)
			Z <= ZSub;
		else if(MUL)
			Z <= ZMult;
		else if(NEG)
			Z <= ZNeg;
		else if(NOT)
			Z <= ZNot;
		//Have other ALU operations here
		out[31:0] <= MDRo;
	end

	wire [31:0] R2, R4, R5, PC, IR, ZHi, ZLo, Y, MAR, MDRo, HI, LO;
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
	genReg HIff(HI, busOut, HIin, Clear, Clock);
	genReg LOff(LO, busOut, LOin, Clear, Clock);
	
	//Add the other operations needed for the datapath
	Add add(ZAdd[31:0], ZAdd[32], Y, busOut, 0);
	Sub sub(ZSub[31:0], ZSub[32], Y, busOut, 0);
	Mult_booth_bit mult(ZMult[31:0], ZMult[63:32], Y, busOut);
	NEG_gate neg(busOut, ZNeg);
	NOT_gate nott(busOut, ZNot);
	
	busmux BUS(busOut, s, 32'b0, 32'b0, R2, 32'b0, R4, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0,
					32'b0, 32'b0, 32'b0, 32'b0, HI, LO, ZHi, ZLo, PC, MDRo);
endmodule
