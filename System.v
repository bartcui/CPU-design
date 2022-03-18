`timescale 1ns/10ps
module System();

	wire	BranchMet, Gra, Grb, Grc, Rin, Rout, Cout, BAout,
			LOout, HIout, Zlowout, Zhighout, MDRout, PCout, 
			LOin, HIin, CONin, PCin, IRin, Yin, Zin, MARin, MDRin, OutPortin, InPortout,
			IncPC, Read, Write, ReadEn, Run, Clear, strobe,
			AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT;
	reg	Clock, Reset, Stop, CON_FF, Interrupts;
	
	Datapath_P3 DUT(PCout, Zhighout, Zlowout, MDRout, HIout, LOout, InPortout, 
							MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin, OutPortin, IncPC, 
							Read, Write, ReadEn, Gra, Grb, Grc, Rin, Rout, BAout, Cout, CONin, 
							strobe, Clock, Clear, 32'b0, 32'b0, AND, OR, ADD, SUB, MUL, DIV, 
							SHR, SHL, ROR, ROL, NEG, NOT, Run, Stop, CON_FF, Interrupts);
								
	assign CONin = 0;
	assign BranchMet = 0;
	assign ReadEn = 0;
	assign strobe = 0;
	
	initial begin
		CON_FF  <= 0; Reset <= 0; Stop <= 0; Interrupts <= 0; 
		Clock = 0; 
		forever #10 Clock = ~Clock;  
	end

endmodule
