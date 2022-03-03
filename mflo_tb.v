`timescale 1ns/10ps
module mflo_tb;
	reg  PCout, Zhiout, Zlowout, MDRout, LOWout, InPortout;
   reg  MARin, Zin, PCin, MDRin, IRin, Yin, OutPortin;  
   reg  IncPC, Read, Write;
	reg  Gra, Grb, Grc, Rin, Rout, BAout, Cout, CONIn, Strobe;
   reg  Clock, Clear; 
   reg  [31:0] Mdatain;
	wire [31:0] outp;
	
			
	parameter Default = 4'b0000, T0 = 4'b0111, T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010;
	reg [3:0] Present_state = Default;
	Datapath_P2 DUT(outp, PCout, Zhiout, Zlowout, MDRout, 0, LOWout, InPortout, MARin, Zin, PCin, MDRin, IRin, Yin, 0, 0, OutPortin, IncPC, Read, Write, Gra, Grb, Grc, Rin, Rout, BAout, Cout, CONIn, Strobe, Clock, Clear, Mdatain,); 
	
initial begin 
	Clock = 0; 
   forever #15 Clock = ~Clock;  
end

always @(posedge Clock)  // finite state machine; if clock rising-edge 
	begin
		case (Present_state)
			Default			:	Present_state = T0;
			T0					:	Present_state = T1;
			T1					:	Present_state = T2;
			T2					:	Present_state = T3;
		endcase
end

always @(Present_state) 
	begin
	#10 
		case (Present_state) 
			Default: begin 
				PCout <= 0; Zhiout <= 0; Zlowout <= 0; MDRout <= 0; InPortout <= 0;
				MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0; OutPortin <= 0;
				IncPC <= 0;  Read <= 0;  Write <= 0;  Gra <= 0;  Grb <= 0;  Grc <= 0;  Rin <= 0;  Rout <= 0;  BAout <= 0;  
				Cout <= 0;  CONIn <= 0;  Strobe <= 0;  Clock <= 0;  Clear <= 0; 
				Mdatain <= 32'd0;  LOWout <= 0;
			end	

		T0: begin 
			#5 PCout <= 1; MARin <= 1; IncPC <= 1; Zin = 1;
			end
		T1: begin 
			#5 PCout <= 0; MARin <= 0; IncPC <= 0; Zin = 0;  
			Mdatain = 110000010; //mflo R2
			#5 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
			end

		T2: begin
			#5 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0; 
			#5 MDRout <= 1; IRin <= 1;		
			end

		T3: begin
			#5 MDRout <= 0; IRin <= 0;			
			#5 Gra<=1;Rout<=1;LOWout<=1;
			#25 Gra<=0;Rout<=0;LOWout<=0;
			end
		endcase
	end
endmodule