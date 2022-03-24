//Set this file as top level entity
`timescale 1ns/100ps
module Datapath_P3(
	output PCout, Zhighout, Zlowout, MDRout, HIout, LOout, InPortout,
   output MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin, OutPortin,   
   output IncPC, Read, Write, ReadEn,
	output Gra, Grb, Grc, Rin, Rout, BAout, Cout, CONin, Strobe,
	input Clock,
	output Clear, 	
   input [31:0] Mdatain,
	input [31:0] InputDev,
	output AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT,
	input Stop, CON_FF, Interrupts
);
	
	wire [15:0] RegIn, RegOut;
	wire [31:0] C_sign;
	
	wire [31:0] RAMout;
	
	reg [31:0] encIn;
	wire [4:0] s;
	
	wire [31:0] busOut;
	
	wire BranchMet;
	
	reg [63:0] Z;
	
	initial begin
		Z = 0;
	end
	
	wire [32:0] ZAdd, ZSub;
	wire [63:0] ZMult, ZDiv;
	wire [31:0] ZAnd, ZOr, ZShr, ZShl, ZRor, ZRol, ZNeg, ZNot;

	wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
					PC, IR, ZHi, ZLo, Y, MAR, MDRo, HI, LO, InPorto, OutPorto, C_sign_extended;
	
	Sel_Enc RegSel(RegIn, RegOut, C_sign, Gra, Grb, Grc, Rin, Rout, BAout, IR);
	
	RAMP3 ram(MAR[8:0], Clock, MDRo, Write, RAMout);
	
	CONFF_Logic CONFF(BranchMet, busOut, IR[22:19], CONin);
	
	InPort IP(InPorto, InputDev, Clear, Clock, Strobe);
	
	OutPort OP(OutPorto, busOut, Clear, Clock, OutPortin);
	
	//initialize encoder input
	always @(RegOut or HIout or LOout or Zhighout or Zlowout or PCout or MDRout or InPortout or Cout) begin
		encIn[15:0] = RegOut;
		encIn[16] = HIout;
		encIn[17] = LOout;
		encIn[18] = Zhighout;
		encIn[19] = Zlowout;
		encIn[20] = PCout;
		encIn[21] = MDRout;
		encIn[22] = InPortout;
		encIn[23] = Cout;
		encIn[31:24] = 8'b0;
	end
	
	
	//bus select wire
	encoder_32_5 busEnc(s, encIn);	//encoder entity
	
	zeroReg R0ff(R0, busOut, RegIn[0], Clear, Clock, BAout);
	genReg R1ff(R1, busOut, RegIn[1], Clear, Clock);
	genReg R2ff(R2, busOut, RegIn[2], Clear, Clock);
	genReg R3ff(R3, busOut, RegIn[3], Clear, Clock);
	genReg R4ff(R4, busOut, RegIn[4], Clear, Clock);
	genReg R5ff(R5, busOut, RegIn[5], Clear, Clock);
	genReg R6ff(R6, busOut, RegIn[6], Clear, Clock);
	genReg R7ff(R7, busOut, RegIn[7], Clear, Clock);
	genReg R8ff(R8, busOut, RegIn[8], Clear, Clock);
	genReg R9ff(R9, busOut, RegIn[9], Clear, Clock);
	genReg R10ff(R10, busOut, RegIn[10], Clear, Clock);
	genReg R11ff(R11, busOut, RegIn[11], Clear, Clock);
	genReg R12ff(R12, busOut, RegIn[12], Clear, Clock);
	genReg R13ff(R13, busOut, RegIn[13], Clear, Clock);
	genReg R14ff(R14, busOut, RegIn[14], Clear, Clock);
	genReg R15ff(R15, busOut, RegIn[15], Clear, Clock);
	
	PCReg PCff(PC, busOut, PCin, Clear, Clock, IncPC);
	genReg IRff(IR, busOut, IRin, Clear, Clock);
	genReg ZHiff(ZHi, Z[63:32], Zin, Clear, Clock);
	genReg ZLoff(ZLo, Z[31:0], Zin, Clear, Clock);
	genReg Yff(Y, busOut, Yin, Clear, Clock);
	MARReg MARff(MAR, busOut, MARin, Clear, Clock);
	MDR MDRreg(MDRo, busOut, Mdatain, RAMout, MDRin, Clock, Clear, Read, ReadEn);
	genReg HIff(HI, busOut, HIin, Clear, Clock);
	genReg LOff(LO, busOut, LOin, Clear, Clock);
	genReg Cff(C_sign_extended, C_sign, 1, Clear, Clock);
	
	busmux BUS(busOut, s, R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, 
					HI, LO, ZHi, ZLo, PC, MDRo, InPorto, C_sign_extended);
	
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
	end
	
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
	
	ControlUnit CONTROL(Gra, Grb, Grc, Rin, Rout, Cout, BAout,
								LOout, HIout, Zlowout, Zhighout, MDRout, PCout, 
								LOin, HIin, CONin, PCin, IRin, Yin, Zin, MARin, MDRin, OutPortin, InPortout,
								IncPC, Read, Write, ReadEn, Clear,
								AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT,
								IR, Clock, Reset, Stop, CON_FF, Interrupts, BranchMet);
	
endmodule
