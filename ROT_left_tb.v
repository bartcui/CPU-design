`timescale 1ns / 10ps
module ROT_left_tb; 	
	reg	PCout, Zhiout, Zlowout, MDRout, R2out, R4out;
	reg	MARin, PCin, MDRin, IRin, Yin, Zin;
	reg 	IncPC, Read;
	reg 	R5in, R2in, R4in;
	reg	Clock, Clear;
	reg	[31:0] Mdatain;
	wire 	[31:0] outp;
	reg	ROTL; 

	parameter	Default = 4'b0000, Reg_load1a= 4'b0001, Reg_load1b= 4'b0010,
					Reg_load2a= 4'b0011, Reg_load2b = 4'b0100, Reg_load3a = 4'b0101,
					Reg_load3b = 4'b0110, T0= 4'b0111, T1= 4'b1000,T2= 4'b1001, T3= 4'b1010, T4= 4'b1011, T5= 4'b1100;
	reg	[3:0] Present_state= Default;

	Datapath DUT(outp, PCout, Zhiout, Zlowout, MDRout, R2out, R4out, 0, 0, MARin, Zin, PCin, MDRin, IRin, Yin, 0, 0, IncPC, Read, R5in, R2in, R4in, Clock, Clear, Mdatain, 
						0, 0, 0, 0, 0, 0, 0, 0, 0, ROTL, 0, 0);

initial 
	begin
		Clock = 0;
		forever #15 Clock = ~Clock; 
end

always @(posedge Clock)//finite state machine; if clock rising-edge
begin
	case (Present_state)
		Default			:	Present_state = Reg_load1a;
		Reg_load1a		:	Present_state = Reg_load1b;
		Reg_load1b		:	Present_state = Reg_load2a;
		Reg_load2a		:	Present_state = Reg_load2b;
		Reg_load2b		:	Present_state = Reg_load3a;
		Reg_load3a		:	Present_state = Reg_load3b;
		Reg_load3b		:	Present_state = T0;
		T0					:	Present_state = T1;
		T1					:	Present_state = T2;
		T2					:	Present_state = T3;
		T3					:	Present_state = T4;
		T4					:	Present_state = T5;
		endcase
	end

always @(Present_state)
begin
	case (Present_state)            
		Default: begin
				PCout <= 0; Zhiout <= 0; Zlowout <= 0; MDRout <= 0; R2out <= 0; R4out <= 0;
				MARin <= 0; Zin <= 0; PCin <= 0; MDRin <= 0; IRin <= 0; Yin <= 0; 
				IncPC <= 0; Read <= 0; ROTL <= 0; R5in <= 0; R2in <= 0; R4in <= 0;
				Clear <= 0; Mdatain <= 32'd0; 
		end
		Reg_load1a: begin
				Mdatain <= 32'hAA220000;
				Read = 0; MDRin = 0;
				#10 Read <= 1; MDRin <= 1;
			end
			Reg_load1b: begin
				#5 Read <= 0; MDRin <= 0;
				#5 MDRout <= 1; R2in <= 1;
			end
			Reg_load2a: begin
				#5 MDRout <= 0; R2in <= 0;
				Mdatain <= 32'd3;
				#5 Read <= 1; MDRin <= 1;
			end
			Reg_load2b: begin
				#5 Read <= 0; MDRin <= 0;
				#5 MDRout <= 1; R4in <= 1;
			end
			Reg_load3a: begin
				#5 MDRout <= 0; R4in <= 0;
				Mdatain <= 32'd10;
				#5 Read <= 1; MDRin <= 1;
			end
			Reg_load3b: begin
				#5 Read <= 0; MDRin <= 0;
				#5 MDRout <= 1; R5in <= 1;
			end
			T0: begin
				#5 MDRout <= 0; R5in <= 0;
				#5 PCout <= 1; MARin <= 1; IncPC <= 1; Zin <= 1;
			end
			T1: begin
				#5 PCout <= 0; MARin <= 0; IncPC <= 0; Zin <= 0;
				Mdatain <= 32'h1A920000;
				#5 Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
			end
			T2: begin
				#5 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
				#5 MDRout <= 1; IRin <= 1;
			end
			T3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 R2out <= 1; Yin <= 1;
			end
			T4: begin
				#5 R2out <= 0; Yin <= 0;
				#5 R4out <= 1; ROTL <= 1; Zin <= 1;
			end
			T5: begin
				#5 R4out <= 0; ROTL <= 0; Zin <= 0;
				#5 Zlowout <= 1; R5in <= 1;
				#25 Zlowout <= 0; R5in <= 0;
			end
		endcase
	end
endmodule