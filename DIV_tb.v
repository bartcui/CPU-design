module DIV_tb();
	wire [31:0] Zhi,Zlo;
	reg signed [31:0] D,Q;
	reg Clock;
	DIV div1(D,Q,Zhi,Zlo);
	
parameter Default = 4'b000, T0= 4'b0001, T1= 4'b0010;

reg [3:0] state= Default;

initial 
begin
	Clock = 0;
	forever #10 Clock = ~Clock;
	#100 $monitor;
end
	
always @(posedge Clock)
begin
	case(state)
		Default : state = T0;
		T0: state = T1;
	endcase
end

always @(state)
begin
	case(state)
	Default: begin
					#10 D = 32'd0;
				end
	T0: begin
			#10 D = 32'd6; Q = 32'd3;
		end
	T1: begin	
			#10 D = 32'd6; Q = -32'd3;
		end
	endcase
end
endmodule