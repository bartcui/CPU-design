`timescale 1ns/10ps
module SystemP4();

	reg	Clock, Clear, Reset, Stop;
	wire	Run;
	reg 	[31:0] InputDev;
	wire 	[31:0] OutPorto;
	
	Datapath_P4 DUT(SlowClock, Clear, Reset, Stop, Run, InputDev, OutPorto);
	
	initial begin
		InputDev = 32'b0;
		Clear <= 0;
		Reset <= 0;
		Stop <= 0;
		Clock <= 0;
		forever #10 Clock = ~Clock;
	end

endmodule
