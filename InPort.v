module InPort(
	output reg [31:0] BusIn,
	input [31:0] Port,
	input Clear, Clock,
	input Strobe
);
	initial BusIn = 0;
	always@(posedge Clock)
	begin
		if(Clear)
			BusIn[31:0] = 32'b0;
		else if(Strobe)
			BusIn[31:0] = Port[31:0];
	end
endmodule
