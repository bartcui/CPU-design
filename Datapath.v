//Set this file as top level entity
`timescale 1ns/10ps
module Datapath(
	output reg [31:0] out,
	input PCout, Zhiout, Zlowout, MDRout, R2out, R4out, HIout, LOout,
   input MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin,    
   input IncPC, Read, R5in, R2in, R4in,
   input Clock, Clear, 
   input [31:0] Mdatain,
	input AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT
);
	
	reg [31:0] encIn;	//initialize encoder input
	always @(R2out or R4out or HIout or LOout or Zhiout or Zlowout or PCout or MDRout) begin
		encIn[1:0] = 2'b0;
		encIn[2] = R2out;
		encIn[3] = 1'b0;
		encIn[4] = R4out;
		encIn[15:5] = 11'b0;
		encIn[16] = HIout;
		encIn[17] = LOout;
		encIn[18] = Zhiout;
		encIn[19] = Zlowout;
		encIn[20] = PCout;
		encIn[21] = MDRout;
		encIn[31:22] = 10'b0;
	end
	
	
	wire [4:0] s;	//bus select wire
	encoder_32_5 busEnc(s, encIn);	//encoder entity
	
	wire [31:0] busOut;
	
	reg [63:0] Z;
	wire [32:0] ZAdd, ZSub;
	wire [63:0] ZMult, ZDiv;
	wire [31:0] ZAnd, ZOr, ZShr, ZShl, ZRor, ZRol, ZNeg, ZNot;

	wire [31:0] R2, R4, R5, PC, IR, ZHi, ZLo, Y, MAR, MDRo, HI, LO;
	genReg R2ff(R2, busOut, R2in, Clear, Clock);
	genReg R4ff(R4, busOut, R4in, Clear, Clock);
	genReg R5ff(R5, busOut, R5in, Clear, Clock);
	PCReg PCff(PC, busOut, PCin, Clear, Clock, IncPC);
	genReg IRff(IR, busOut, IRin, Clear, Clock);
	genReg ZHiff(ZHi, Z[63:32], Zin, Clear, Clock);
	genReg ZLoff(ZLo, Z[31:0], Zin, Clear, Clock);
	genReg Yff(Y, busOut, Yin, Clear, Clock);
	genReg MARff(MAR, busOut, MARin, Clear, Clock);
	MDR MDRreg(MDRo, busOut, Mdatain, MDRin, Clock, Clear, Read);
	genReg HIff(HI, busOut, HIin, Clear, Clock);
	genReg LOff(LO, busOut, LOin, Clear, Clock);
	
	always @(ADD or SUB or MUL or NEG or NOT or DIV or AND or OR or SHR or SHL or ROR or ROL or NEG or NOT) begin
		#5;
		if(AND)
			Z = ZAnd;
		else if(OR)
			Z = ZOr;
		else if(ADD)
			Z = ZAdd;
		else if(SUB)
			Z = ZSub;
		else if(MUL)
			Z = ZMult;
		else if(DIV)
			Z = ZDiv;
		else if(SHR)
			Z = ZShr;
		else if(SHL)
			Z = ZShl;
		else if(ROR)
			Z = ZRor;
		else if(ROL)
			Z = ZRol;
		else if(NEG)
			Z = ZNeg;
		else if(NOT)
			Z = ZNot;
		//Have other ALU operations here
		out[31:0] = Z[63:32];
		#5
		out[31:0] = Z[31:0];
	end
	
	//Add the other operations needed for the datapath
	AND_gate andd(Y, busOut, ZAnd);
	OR_gate orr(Y, busOut, ZOr);
	Add add(ZAdd[31:0], ZAdd[32], Y, busOut, 1'b0);
	Sub sub(ZSub[31:0], ZSub[32], Y, busOut);
	Mult_booth_bit mult(ZMult[63:32], ZMult[31:0], Y, busOut);
	Div div(Y, busOut, ZDiv[63:32], ZDiv[31:0]);
	SHIFT_right shr(Y, busOut, ZShr);
	SHIFT_left shl(Y, busOut, ZShl);
	ROTATE_right ror(Y, busOut[4:0], ZRor);
	ROTATE_left rol(Y, busOut[4:0], ZRol);
	NEG_gate neg(busOut, ZNeg);
	NOT_gate nott(busOut, ZNot);
	
	busmux BUS(busOut, s, 32'b0, 32'b0, R2, 32'b0, R4, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0,
					32'b0, 32'b0, 32'b0, 32'b0, HI, LO, ZHi, ZLo, PC, MDRo);
endmodule
