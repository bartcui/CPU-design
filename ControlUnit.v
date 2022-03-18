`timescale 1ns/10ps
module ControlUnit(
	output reg	Gra, Grb, Grc, Rin, Rout, Cout, BAout,
					LOout, HIout, Zlowout, Zhighout, MDRout, PCout, 
					LOin, HIin, CONin, PCin, IRin, Yin, Zin, MARin, MDRin, OutPortin, InPortout,
					IncPC, Read, Write, ReadEn, Run, Clear,
					AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT,
	input [31:0] IR,
	input			Clock, Reset, Stop, CON_FF, Interrupts, BranchMet
);
	
	parameter	Reset_state = 7'd0, fetch0 = 7'd1, fetch1 = 7'd2, fetch2 = 7'd3,
					and3 = 7'd4, and4 = 7'd5, and5 = 7'd6, or3 = 7'd7, or4 = 7'd8, or5 = 7'd9, 
					add3 = 7'd10, add4 = 7'd11, add5 = 7'd12, sub3 = 7'd13, sub4 = 7'd14, sub5 = 7'd15,
					mul3 = 7'd16, mul4 = 7'd17, mul5 = 7'd18, mul6 = 7'd81, div3 = 7'd19, div4 = 7'd20, div5 = 7'd21, div6 = 7'd82,
					shr3 = 7'd22, shr4 = 7'd23, shr5 = 7'd24, shl3 = 7'd25, shl4 = 7'd26, shl5 = 7'd27, 
					ror3 = 7'd28, ror4 = 7'd29, ror5 = 7'd30, rol3 = 7'd31, rol4 = 7'd32, rol5 = 7'd33, 
					neg3 = 7'd34, neg4 = 7'd35, not3 = 7'd36, not4 = 7'd37, addi3 = 7'd38, addi4 = 7'd39, addi5 = 7'd40,
					andi3 = 7'd41, andi4 = 7'd42, andi5 = 7'd43, ori3 = 7'd44, ori4 = 7'd45, ori5 = 7'd46,
					brzr3 = 7'd47, brzr4 = 7'd48, brzr5 = 7'd49, brzr6 = 7'd50, brnz3 = 7'd51, brnz4 = 7'd52, brnz5 = 7'd53, brnz6 = 7'd54,
					brpl3 = 7'd55, brpl4 = 7'd56, brpl5 = 7'd57, brpl6 = 7'd58, brmi3 = 7'd59, brmi4 = 7'd60, brmi5 = 7'd61, brmi6 = 7'd62,
					in3 = 7'd63, out3 = 7'd64, jal3 = 7'd65, jal4 = 7'd85, jr3 = 7'd66, mflo3 = 7'd67, mfhi3 = 7'd68,
					ld3 = 7'd69, ld4 = 7'd70, ld5 = 7'd71, ld6 = 7'd72, ld7 = 7'd73, ldi3 = 7'd74, ldi4 = 7'd75, ldi5 = 7'd76,
					st3 = 7'd77, st4 = 7'd77, st5 = 7'd78, st6 = 7'd79, st7 = 7'd80, nop = 7'd83, halt = 7'd84;
	
	reg	[5:0] Present_state = Reset_state;
	
	always @(posedge Clock, posedge Reset)	begin
		if (Reset == 1'b1) Present_state = Reset_state;
		else
			case(Present_state)
				Reset_state	:	Present_state = fetch0;
				fetch0		:	Present_state = fetch1;
				fetch1		:	Present_state = fetch2;
				fetch2		:	begin
										case(IR[31:27])
											5'b00000	:	Present_state = ld3;
											5'b00001	:	Present_state = ldi3;
											5'b00010	:	Present_state = st3;
											5'b00011	:	Present_state = add3;
											5'b00100	:	Present_state = sub3;
											5'b00101	:	Present_state = shr3;
											5'b00110	: 	Present_state = shl3;
											5'b00111	:	Present_state = ror3;
											5'b01000	:	Present_state = rol3;
											5'b01001	:	Present_state = and3;
											5'b01010	:	Present_state = or3;
											5'b01011	:	Present_state = addi3;
											5'b01100	:	Present_state = andi3;
											5'b01101	:	Present_state = ori3;
											5'b01110	:	Present_state = mul3;
											5'b01111	:	Present_state = div3;
											5'b10000	:	Present_state = neg3;
											5'b10001	:	Present_state = not3;
											5'b10010	:	begin
																case(IR[24:23])
																	2'b00	:	Present_state = brzr3;
																	2'b01	:	Present_state = brnz3;
																	2'b10	:	Present_state = brpl3;
																	2'b11	:	Present_state = brmi3;
																endcase
															end
											5'b10011	:	Present_state = jr3;
											5'b10100	:	Present_state = jal3;
											5'b10101	:	Present_state = in3;
											5'b10110	:	Present_state = out3;
											5'b10111	:	Present_state = mfhi3;
											5'b11000	:	Present_state = mflo3;
											5'b11001	:	Present_state = nop;
											5'b11010	:	Present_state = halt;
										endcase
									end
				
				ld3			:	Present_state = ld4;
				ld4			:	Present_state = ld5;
				ld5			:	Present_state = ld6;
				ld6			:	Present_state = ld7;
				ld7			:	Present_state = Reset_state;
				
				ldi3			: 	Present_state = ldi4;
				ldi4			: 	Present_state = ldi5;
				ldi5 			:	Present_state = Reset_state;
				
				st3			: 	Present_state = st4;
				st4			: 	Present_state = st5;
				st5			: 	Present_state = st6;
				st6			: 	Present_state = st7;
				st7 			:	Present_state = Reset_state;
				
				add3			: 	Present_state = add4;
				add4			:	Present_state = add5;
				add5 			:	Present_state = Reset_state;
				
				sub3				: 	Present_state = sub4;
				sub4				: 	Present_state = sub5;
				sub5				:	Present_state = Reset_state;
				
				shr3				: 	Present_state = shr4;
				shr4				: 	Present_state = shr5;
				shr5 				:	Present_state = Reset_state;
			
				shl3				: 	Present_state = shl4;
				shl4				: 	Present_state = shl5;
				shl5 				:	Present_state = Reset_state;
			
				ror3				: 	Present_state = ror4;
				ror4				: 	Present_state = ror5;
				ror5 				:	Present_state = Reset_state;
			
				rol3				: 	Present_state = rol4;
				rol4				: 	Present_state = rol5;
				rol5 				:	Present_state = Reset_state;
			
				and3				: 	Present_state = and4;
				and4				: 	Present_state = and5;
				and5   			:	Present_state = Reset_state;
			
				or3				: 	Present_state = or4;
				or4				: 	Present_state = or5;
				or5				:	Present_state = Reset_state;
			
				addi3				: 	Present_state = addi4;
				addi4				:	Present_state = addi5;
				addi5 				:	Present_state = Reset_state;
			
				andi3				: 	Present_state = andi4;
				andi4				: 	Present_state = andi5;
				andi5 			:	Present_state = Reset_state;
			
				ori3				: 	Present_state = ori4;
				ori4				: 	Present_state = ori5;
				ori5 				:	Present_state = Reset_state;
				
				mul3				: 	Present_state = mul4;
				mul4				: 	Present_state = mul5;
				mul5				: 	Present_state = mul6;
				mul6           :	Present_state = Reset_state;
			
				div3				: 	Present_state = div4;
				div4				: 	Present_state = div5;
				div5				: 	Present_state = div6;
				div6				:	Present_state = Reset_state;
			
				neg3				: 	Present_state = neg4;
				neg4				: 	Present_state = Reset_state;
			
				not3				: 	Present_state = not4;
				not4				: 	Present_state = Reset_state;
			
				brzr3				: 	Present_state = brzr4;
				brzr4				: 	Present_state = brzr5;
				brzr5				: 	Present_state = brzr6;
				brzr6  			:	Present_state = Reset_state;
				
				brnz3				: 	Present_state = brnz4;
				brnz4				: 	Present_state = brnz5;
				brnz5				: 	Present_state = brnz6;
				brnz6  			:	Present_state = Reset_state;
				
				brpl3				: 	Present_state = brpl4;
				brpl4				: 	Present_state = brpl5;
				brpl5				: 	Present_state = brpl6;
				brpl6  			:	Present_state = Reset_state;
				
				brmi3				: 	Present_state = brmi4;
				brmi4				: 	Present_state = brmi5;
				brmi5				: 	Present_state = brmi6;
				brmi6  			:	Present_state = Reset_state;
			
				jr3 				:	Present_state = Reset_state;
				
				jal3				: 	Present_state = jal4;
				jal4 				:	Present_state = Reset_state;
			
				in3 				:	Present_state = Reset_state;
			
				out3 				:	Present_state = Reset_state;
			
				mfhi3 			:	Present_state = Reset_state;
			
				mflo3 			:	Present_state = Reset_state;
			
				nop 				:	Present_state = Reset_state;
			
				halt				:  Present_state = Reset_state;
			
				default			:	Present_state = Reset_state;
			endcase
	end
	
	//Run instructions here
	/*Gra, Grb, Grc, Rin, Rout, Cout, BAout
					LOout, HIout, Zlowout, Zhighout, MDRout, PCout, 
					LOin, HIin, CONin, PCin, IRin, Yin, Zin, MARin, MDRin, OutPortin, InPortout,
					Read, Write, ReadEn, Run, Clear,
					AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT,*/
	always @(Present_state) begin
		case(Present_state) 
			Reset_state: begin
				Run <= 1;
				Gra <= 0; Grb <= 0; Grc <= 0; Rin <= 0; Rout <= 0; Cout <= 0; BAout <= 0;
				LOout <= 0; HIout <= 0; Zlowout <= 0; Zhighout <= 0; MDRout <= 0; PCout <= 0;
				LOin <= 0; HIin <= 0; CONin <= 0; PCin <= 0; IRin <= 0; Yin <= 0; Zin <= 0; MARin <= 0; MDRin <= 0; OutPortin <= 0; InPortout <= 0; 
				Read <= 0; Write <= 0; ReadEn <= 0; Run <= 0; Clear <= 0;
				AND <= 0; OR <= 0; ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0; SHR <= 0; SHL <= 0; ROR <= 0; ROL <= 0; NEG <= 0; NOT <= 0; 
			end
			fetch0: begin
				#5 PCout <= 1; MARin <= 1; IncPC <= 1; Zin = 1;
			end
			fetch1: begin
				#5 PCout <= 0; MARin <= 0; IncPC <= 0; Zin = 0;  
				#5 Zlowout <= 1; ReadEn <= 1; MDRin <= 1;
			end
			fetch2: begin
				#5 Zlowout <= 0; ReadEn <= 0; MDRin <= 0; 
				#5 MDRout <= 1; IRin <= 1;	
			end
			ld3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Grb<=1;BAout<=1;Yin<=1;
			end
			ld4: begin
				#5 Grb<=0;BAout<=0;Yin<=0;
				#5 Cout<=1; ADD <= 1;  Zin <= 1;
			end
			ld5: begin
				#5 Cout<=0; ADD <= 0;  Zin <= 0;
				#5 Zlowout <= 1;MARin<=1;
			end
			ld6: begin
				#5 Zlowout <= 0; MARin <= 0;
				#5 ReadEn <= 1; MDRin <= 1;
			end
			ld7: begin
				#5 ReadEn <= 0; MDRin <= 0;
				#5 MDRout <= 1; Gra <= 1; Rin <= 1;
				
			end
			
			ldi3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Grb<=1;BAout<=1;Yin<=1;
			end
			ldi4: begin
				#5 Grb<=0;BAout<=0;Yin<=0;
				#5 Cout<=1; ADD <= 1;  Zin <= 1;
			end
			ldi5: begin
				#5 Cout<=0; ADD <= 0;  Zin <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
				
			end
			
			st3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Grb<=1;BAout<=1;Yin<=1;
			end

			st4: begin
				#5 Grb<=0;BAout<=0;Yin<=0;
				#5 Cout<=1; ADD <= 1;  Zin <= 1;
			end

			st5: begin
				#5 Cout<=0; ADD <= 0;  Zin <= 0;
				#5 Zlowout <= 1;MARin<=1;
			end

			st6: begin
				#5 Zlowout <= 0; MARin <= 0;
				#5 MDRin <= 1; Gra <= 1; Rout <= 1;
			end
			st7: begin
				#5 MDRin <= 0; Gra <= 0; Rout <= 0;
				#5 Write <= 1;
				
			end
			
			add3: begin	
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1; Rout <= 1;
			end
			add4: begin
				#5 Grb <= 0; Yin <= 0; Rout <= 0;
				#5 Grc <= 1; ADD <= 1; Zin <= 1; Rout <= 1;
			end
			add5: begin
				#5 Grc <= 0; ADD <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1;	Rin <= 1;	
			end
			
			sub3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1;Rout <= 1;
			end
			sub4: begin
				#5 Grb <= 0; Yin <= 0; Rout <= 0;
				#5 Grc <= 1; SUB <= 1; Zin <= 1; Rout <= 1;
			end
			sub5: begin
				#5 Grc <= 0; SUB <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1;	Rin <= 1;
			end
			
			shr3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1;Rout <= 1;
			end
			shr4: begin
				#5 Grb <= 0; Yin <= 0; Rout <= 0;
				#5 Grc <= 1; SHR <= 1; Zin <= 1; Rout <= 1;
			end
			shr5: begin
				#5 Grc <= 0; SHR <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			shl3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1;Rout <= 1;
			end
			shl4: begin
				#5 Grb <= 0; Yin <= 0; Rout <= 0;
				#5 Grc <= 1; SHL <= 1; Zin <= 1; Rout <= 1;
			end
			shl5: begin
				#5 Grc <= 0; SHL <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			ror3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1;Rout <= 1;
			end
			ror4: begin
				#5 Grb <= 0; Yin <= 0; Rout <= 0;
				#5 Grc <= 1; ROR <= 1; Zin <= 1; Rout <= 1;
			end
			ror5: begin
				#5 Grc <= 0; ROR <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			rol3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1;Rout <= 1;
			end
			rol4: begin
				#5 Grb <= 0; Yin <= 0; Rout <= 0;
				#5 Grc <= 1; ROL <= 1; Zin <= 1; Rout <= 1;
			end
			rol5: begin
				#5 Grc <= 0; ROL <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			and3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1;Rout <= 1;
			end
			and4: begin
				#5 Grb <= 0; Yin <= 0; Rout <= 0;
				#5 Grc <= 1; AND <= 1; Zin <= 1; Rout <= 1;
			end
			and5: begin
				#5 Grc <= 0; AND <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			or3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1;Rout <= 1;
			end
			or4: begin
				#5 Grb <= 0; Yin <= 0; Rout <= 0;
				#5 Grc <= 1; OR <= 1; Zin <= 1; Rout <= 1;
			end
			or5: begin
				#5 Grc <= 0; OR <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			addi3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Grb<=1;Rout<=1;Yin<=1;
			end

			addi4: begin
				#5 Grb<=0;Rout<=0;Yin<=0;
				#5 Cout<=1; ADD <= 1; Zin <= 1;
			end

			addi5: begin
				#5 Cout<=0; ADD <= 0;  Zin <= 0;
				#5 Zlowout <= 1;Gra <= 1; Rin <= 1;
			end
			
			andi3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Grb<=1;Rout<=1;Yin<=1;
				end

			andi4: begin
				#5 Grb<=0;Rout<=0;Yin<=0;
				#5 Cout<=1; AND <= 1;  Zin <= 1;
				end

			andi5: begin
				#5 Cout<=0; AND <= 0;  Zin <= 0;
				#5 Zlowout <= 1;Gra <= 1; Rin <= 1;
				end
			
			ori3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Grb<=1;Rout<=1;Yin<=1;
			end

			ori4: begin
				#5 Grb<=0;Rout<=0;Yin<=0;
				#5 Cout<=1;OR <= 1;Zin <= 1;
				end

			ori5: begin
				#5 Cout<=0; OR <= 0;  Zin <= 0;
				#5 Zlowout <= 1;Gra <= 1; Rin <= 1;
				end
				
			mul3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1; Rout<=1;
			end
			mul4: begin
				#5 Grb <= 0; Yin <= 0; Rout<=0;
				#5 Grc <= 1; MUL <= 1; Zin <= 1; Rout <= 1;
			end
			mul5: begin
				#5 Grc <= 0; MUL <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; LOin <= 1;
			end
			mul6: begin
				#5 Zlowout <= 0; LOin <= 0;
				#5 Zhighout <= 1; HIin <= 1;
			end
			
			div3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; Yin <= 1; Rout<=1;
			end
			div4: begin
				#5 Grb <= 0; Yin <= 0; Rout<=0;
				#5 Grc <= 1; DIV <= 1; Zin <= 1; Rout<=1;
			end
			div5: begin
				#5 Grc <= 0; DIV <= 0; Zin <= 0; Rout<=0;
				#5 Zlowout <= 1; LOin <= 1;
			end
			div6: begin
				#5 Zlowout <= 0; LOin <= 0;
				#5 Zhighout <= 1; HIin <= 1;
			end
			
			neg3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; NEG <= 1; Zin <= 1; Rout <= 1; 
			end
			neg4: begin
				#5 Grb <= 0; NEG <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			not3: begin
				#5 MDRout <= 0; IRin <= 0;
				#5 Grb <= 1; NOT <= 1; Zin <= 1; Rout <= 1; 
			end
			not4: begin
				#5 Grb <= 0; NOT <= 0; Zin <= 0; Rout <= 0;
				#5 Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
			
			brzr3, brnz3, brpl3, brmi3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Gra<=1;Rout<=1;CONin<=1;
			end

			brzr4, brnz4, brpl4, brmi4: begin
				#5 Gra<=0;Rout<=0;CONin<=0;
				#5 PCout <=1; Yin <=1;
				end

			brzr5, brnz5, brpl5, brmi5: begin
				#5 PCout <=0; Yin <=0;
				#5 Cout<=1; ADD <= 1;  Zin <= 1;
				end

			brzr6, brnz6, brpl6, brmi6: begin
				#5 Cout<=0; ADD <= 0;  Zin <= 0;
				#5 Zlowout <= 1;PCin <= BranchMet; 
				end
					
			jr3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Gra<=1;Rout<=1;PCin<=1;
			end
			
			jal3: begin
				#5 MDRout <= 0; IRin <= 0; IncPC <= 0;
				#5 Grb <= 1; Rin <= 1; PCout <= 1;
				end

			jal4: begin	
				#5 Grb <= 0; Rin <= 0; PCout <= 0;
				#5 Gra<=1;Rout<=1;PCin<=1;
				end
				
			in3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Gra<=1;Rin<=1;InPortout<=1;
			end
			
			out3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Gra<=1;Rout<=1;OutPortin<=1;
			end
			
			mfhi3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Gra<=1;Rin<=1;HIout<=1;
			end
			
			mflo3: begin
				#5 MDRout <= 0; IRin <= 0;			
				#5 Gra<=1;Rin<=1;LOout<=1;
				end
				
			nop: begin
				end
				
			halt: begin
				Run <= 0;
			end
		endcase	
	end
			
	
endmodule
