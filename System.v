`timescale 1ns/100ps
module System();

	wire	BranchMet, Gra, Grb, Grc, Rin, Rout, Cout, BAout,
			LOout, HIout, Zlowout, Zhighout, MDRout, PCout, 
			LOin, HIin, CONin, PCin, IRin, Yin, Zin, MARin, MDRin, OutPortin, InPortout,
			IncPC, Read, Write, ReadEn, Clear, strobe,
			AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT;
	reg	Clock, Reset, Stop, CON_FF, Interrupts;
	
	Datapath_P3 DUT(PCout, Zhighout, Zlowout, MDRout, HIout, LOout, InPortout, 
							MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin, OutPortin, IncPC, 
							Read, Write, ReadEn, Gra, Grb, Grc, Rin, Rout, BAout, Cout, CONin, 
							strobe, Clock, Clear, 32'b0, 32'b0, AND, OR, ADD, SUB, MUL, DIV, 
							SHR, SHL, ROR, ROL, NEG, NOT, Stop, CON_FF, Interrupts);
								
	assign BranchMet = 0;
	assign strobe = 0;
	
	initial begin
		CON_FF  <= 0; Reset <= 0; Stop <= 0; Interrupts <= 0;
		Clock = 0; 
		forever #10 Clock = ~Clock;  
	end

endmodule
