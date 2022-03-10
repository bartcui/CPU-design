//Set this file as top level entity
`timescale 1ns/10ps
module Datapath_P2(
	output reg [31:0] out,
	input PCout, Zhiout, Zlowout, MDRout, HIout, LOout, InPortout,
   input MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin, OutPortin,   
   input IncPC, Read, Write, ReadIn,
	input Gra, Grb, Grc, Rin, Rout, BAout, Cout, CONIn, Strobe,
   input Clock, Clear, 
   input [31:0] Mdatain,
	input [31:0] InputDev,
	input AND, OR, ADD
);
	
	wire [15:0] RegIn, RegOut;
	wire [31:0] C_sign;
	
	wire [31:0] RAMout;
	
	wire BranchMet;
	
	reg [31:0] encIn;
	wire [4:0] s;
	
	wire [31:0] busOut;
	
	reg [63:0] Z;
	
	wire [32:0] ZAdd;
	
	wire [31:0] ZAnd, ZOr;

	wire [31:0] R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15,
					PC, IR, ZHi, ZLo, Y, MAR, MDRo, HI, LO, InPorto, OutPorto, C_sign_extended;
	
	Sel_Enc RegSel(RegIn, RegOut, C_sign, Gra, Grb, Grc, Rin, Rout, BAout, IR);
	
	RAM ram(MDRo, MAR[8:0], Write, Clock, RAMout);
	
	CONFF_Logic CONFF(BranchMet, busOut, IR[22:19], CONIn);
	
	InPort IP(InPorto, InputDev, Clear, Clock, Strobe);
	
	OutPort OP(OutPorto, busOut, Clear, Clock, OutPortin);
	
	//initialize encoder input
	always @(RegOut or HIout or LOout or Zhiout or Zlowout or PCout or MDRout or InPortout or Cout) begin
		encIn[15:0] = RegOut;
		encIn[16] = HIout;
		encIn[17] = LOout;
		encIn[18] = Zhiout;
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
	MDR MDRreg(MDRo, busOut, Mdatain, RAMout, MDRin, Clock, Clear, Read, ReadIn);
	genReg HIff(HI, busOut, HIin, Clear, Clock);
	genReg LOff(LO, busOut, LOin, Clear, Clock);
	genReg Cff(C_sign_extended, C_sign, 1, Clear, Clock);
	
	busmux BUS(busOut, s, R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, 
					HI, LO, ZHi, ZLo, PC, MDRo, InPorto, C_sign_extended);
	
	always @(ADD or AND or OR or R2) begin
		#5;
		if(AND) begin
			Z = ZAnd;
			out[31:0] = Z[31:0];
		end
		else if(OR) begin
			Z = ZOr;
			out[31:0] = Z[31:0];
		end
		else if(ADD) begin
			Z = ZAdd;
			out[31:0] = Z[31:0];
		end
		else
			#10 out = R2;
		//Have other ALU operations here
	end
	
	AND_gate andd(Y, busOut, ZAnd);
	OR_gate orr(Y, busOut, ZOr);
	Add add(ZAdd[31:0], ZAdd[32], Y, busOut, 1'b0);
endmodule
