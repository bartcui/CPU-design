`timescale 1ns/10ps
module st_tb;
	reg  PCout, Zhiout, Zlowout, MDRout, InPortout;
   reg  MARin, Zin, PCin, MDRin, IRin, Yin, OutPortin;  
   reg  IncPC, Read, Write, ReadEn;
	reg  Gra, Grb, Grc, Rin, Rout, BAout, Cout, CONIn, Strobe;
   reg  Clock, Clear; 
   reg  [31:0] Mdatain;
	wire [31:0] outp;
	reg ADD;
	wire BranchMet;
			
	parameter Default = 5'b00000, RAM_load1a = 5'b00001, RAM_load1b = 5'b00010, RAM_load1c = 5'b00011, RAM_load1d = 5'b00100, Reg_load2a = 5'b00101,  
             Reg_load2b = 5'b00110, Reg_load2c = 5'b00111, Reg_load2d = 5'b01001, Reg_load3a = 5'b01010, Reg_load3b = 5'b01011, Reg_load3c = 5'b01100, Reg_load3d = 5'b01101,
				 T0 = 5'b01110, T1 = 5'b01111, T2 = 5'b10000, T3 = 5'b10001, T4 = 5'b10010, T5 = 5'b10011, T6 = 5'b10100, T7 = 5'b10101;
				 
	reg [4:0] Present_state = Default;
	Datapath_P2 DUT(outp, BranchMet, PCout, Zhiout, Zlowout, MDRout, 0, 0, InPortout, MARin, Zin, PCin, MDRin, IRin, Yin, 0, 0, OutPortin, IncPC, Read, Write, ReadEn, Gra, Grb, Grc, Rin, Rout, BAout, Cout, CONIn, Strobe, Clock, Clear, Mdatain, 32'b0, 0, 0, ADD); 
		
initial begin 
	Clock = 0; 
   forever #15 Clock = ~Clock;  
end

always @(posedge Clock)  // finite state machine; if clock rising-edge 
	begin
		case (Present_state)
			Default 		:  Present_state = RAM_load1a; 
			RAM_load1a 	:  Present_state = RAM_load1b; 
			RAM_load1b 	:  Present_state = RAM_load1c;
			RAM_load1c 	:  Present_state = RAM_load1d; 
			RAM_load1d 	:  Present_state = Reg_load2a;	
			Reg_load2a  :  Present_state = Reg_load2b; 
			Reg_load2b  :  Present_state = Reg_load2c;
			Reg_load2c	:	Present_state = Reg_load2d;
			Reg_load2d	:	Present_state = Reg_load3a;	
			Reg_load3a  :  Present_state = Reg_load3b; 
			Reg_load3b  :  Present_state = Reg_load3c;
			Reg_load3c	:	Present_state = Reg_load3d;
			Reg_load3d	:	Present_state = T0;
			T0					:	Present_state = T1;
			T1					:	Present_state = T2;
			T2					:	Present_state = T3;
			T3					:	Present_state = T4;
			T4					:	Present_state = T5;
			T5					:	Present_state = T6;
			T6					:	Present_state = T7;
		endcase
end

always @(Present_state) 
	begin
	#10 
		case (Present_state) 
			Default: begin 
				PCout <= 0; Zhiout <= 0; Zlowout <= 0; MDRout <= 0; InPortout <= 0;
				MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0; OutPortin <= 0;
				IncPC <= 0;  Read <= 0; ReadEn <= 0; Write <= 0;  Gra <= 0;  Grb <= 0;  Grc <= 0;  Rin <= 0;  Rout <= 0;  BAout <= 0;  
				Cout <= 0;  CONIn <= 0;  Strobe <= 0;  Clock <= 0;  Clear <= 0; 
				Mdatain <= 32'd0;  ADD <= 0;
			end	
		RAM_load1a: begin
			Mdatain <= 32'd85; 
			Read = 0; MDRin = 0;
			#10 Read <= 1; MDRin <= 1; 
			end
		RAM_load1b: begin
			#5 Read <= 0; MDRin <= 0;
			#5 MDRout <= 1; MARin <= 1;
			end
		RAM_load1c: begin
			#5 MDRout <= 0; MARin <= 0;
			Mdatain <= 32'd15;
			#5 Read <= 1; MDRin <= 1;
			end
		RAM_load1d: begin
			#5 Read <= 0; MDRin <= 0;
			#5 Write <= 1;
			end
		
		Reg_load2a: begin
			#5 Write <= 0;
			Mdatain <= 32'b00000000100000000000000000000000;
			#5 Read <= 1; MDRin <= 1;
			end
		Reg_load2b: begin
			#5 Read <= 0; MDRin <= 0;
			#5 MDRout <= 1; IRin <= 1;
			end
		Reg_load2c: begin
			#5 MDRout <= 0; IRin <= 0;
			Mdatain <= 32'd10;
			#5 Read <= 1; MDRin <= 1;
			end
		Reg_load2d: begin
			#5 Read <= 0; MDRin <= 0;
			#5 MDRout <= 1; Gra <= 1; Rin <= 1;
			end
			
		Reg_load3a: begin
			#5 MDRout <= 0; Gra <= 0; Rin <= 0;
			Mdatain <= 32'b00000000000000000000000000000000;
			#5 Read <= 1; MDRin <= 1;
			end
		Reg_load3b: begin
			#5 Read <= 0; MDRin <= 0;
			#5 MDRout <= 1; IRin <= 1;
			end
		Reg_load3c: begin
			#5 MDRout <= 0; IRin <= 0;
			Mdatain <= 32'd0;
			#5 Read <= 1; MDRin <= 1;
			end
		Reg_load3d: begin
			#5 Read <= 0; MDRin <= 0;
			#5 MDRout <= 1; Gra <= 1; Rin <= 1;
			end
			
		T0: begin 
			#5 MDRout <= 0; Gra <= 0; Rin <= 0; 
			#5 PCout <= 1; MARin <= 1; IncPC <= 1; Zin = 1;
			end
		T1: begin 
			#5 PCout <= 0; MARin <= 0; IncPC <= 0; Zin = 0;  
			Mdatain = 32'b00010000100000000000000001010101;
			#5 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
			end

		T2: begin
			#5 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0; 
			#5 MDRout <= 1; IRin <= 1;		
			end

		T3: begin
			#5 MDRout <= 0; IRin <= 0;			
			#5 Grb<=1;BAout<=1;Yin<=1;
			end

		T4: begin
			#5 Grb<=0;BAout<=0;Yin<=0;
			#5 Cout<=1; ADD <= 1;  Zin <= 1;
			end

		T5: begin
			#5 Cout<=0; ADD <= 0;  Zin <= 0;
			#5 Zlowout <= 1;MARin<=1;
			end

		T6: begin
			#5 Zlowout <= 0; MARin <= 0;
			#5 MDRin <= 1; Gra <= 1; Rout <= 1;
			end
		T7: begin
			#5 MDRin <= 0; Gra <= 0; Rout <= 0;
			#5 Write <= 1;
			#25 Write <= 0;
			end
		endcase
	end
endmodule