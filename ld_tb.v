`timescale 1ns/10ps

module ld_tb;
	reg  Zhiout, Zlowout, HIout, LOout, Yout, PCout, MDRout, MARout;
   reg  MARin, Zin, PCin, MDRin, IRin, Yin, HIin, LOin, Zlowin, Zhiin;    
   reg  IncPC, Read, Rin, Rout, BAout, conffout, conffin,Cout; 	//Add other signals for different operations (SUB, DIV, etc)
   reg  Clock, Clear; 
   reg  [31:0] Mdatain;
	reg  Gra, Grb, Grc, MDR_read;	
	wire signed [63:0] outp;
	reg  CON_enable, R_enable; 
	wire [31:0] bus_contents;
	reg RAM_write, MDR_enable, MAR_enable, IR_enable;
	reg [15:0] R0_R15_enable, R0_R15_out;
	reg HI_enable, LO_enable, Y_enable, PC_enable, InPort_enable, OutPort_enable;
	reg InPortout;
	wire [4:0] opcode;
	wire[31:0] OutPort_output;
	reg [31:0] InPort_input;
			
	parameter Default = 4'b0000, T0 = 4'b0111, T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101, T7 = 4'b1110;
	reg [3:0] Present_state = Default;
	Datapath_P2 DUT(outp, PCout, Zhiout, Zlowout, MDRout, R2out, R4out, 0, 0, MARin, Zin, PCin, MDRin, IRin, Yin, 0, 0, IncPC, Read, R5in, R2in, R4in, Clock, Clear, Mdatain, 
						0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0); 
	
	initial
	begin
		Clock = 0; 
   forever #10 Clock = ~Clock; 
end

always @(posedge Clock)  // finite state machine; if clock rising-edge 
	begin
		case (Present_state)
			Default			:	Present_state = T0;
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
				PCout <= 0; Zlowout <= 0; MDRout <= 0; 
				MAR_enable <= 0; Zhiin <= 0; Zlowin <= 0; CON_enable<=0; 
				InPort_enable<=0; OutPort_enable<=0;
				InPort_input<=32'd0;
				PC_enable <=0; MDR_enable <= 0; IR_enable <= 0; 
				Y_enable <= 0;
				IncPC <= 0; RAM_write<=0;
				Mdatain <= 32'h00000000; Gra<=0; Grb<=0; Grc<=0;
				BAout<=0; Cout<=0;
				InPortout<=0; Zhiout<=0; LOout<=0; HIout<=0; 
				HI_enable<=0; LO_enable<=0;
				Rout<=0;R_enable<=0;MDR_read<=0;
				R0_R15_enable<= 16'd0; R0_R15_out<=16'd0;
			end	

T0: begin 
	PCout <= 1; MAR_enable <= 1; 
end

T1: begin //Loads MDR from RAM output
		PCout <= 0; MAR_enable <= 0;  
		MDR_enable <= 1; MDR_read<=1; Zlowout <= 1; 
end

T2: begin
	MDR_enable <= 0; MDR_read<=0;Zlowout <= 0; 
	MDRout <= 1; IR_enable <= 1; PC_enable <= 1; IncPC <= 1;			
end

T3: begin
	MDRout <= 0; IR_enable <= 0;			
	Grb<=1;BAout<=1;Y_enable<=1;
end

T4: begin
	Grb<=0;BAout<=0;Y_enable<=0;
	Cout<=1;Zhiin <= 1;  Zlowin <= 1;
end

T5: begin
	Cout<=0; Zhiin <= 0;  Zlowin <= 0;
	Zlowout <= 1;MAR_enable<=1;
end

T6: begin
	Zlowout <= 0; MAR_enable <= 0;
	MDR_read <= 1; MDR_enable <= 1;
end
T7: begin
	MDR_read <= 0; MDR_enable <= 0;
	MDRout <= 1; Gra <= 1; R_enable <= 1;
end

endcase

end

endmodule