module InPort(
	output reg [31:0] BusIn,
	input [31:0] Port,
	input Clear, Clock
);
	initial BusIn = 0;
	always@(posedge Clock)
	begin
		if(Clear)
			BusIn[31:0] = 32'b0;
		else
			BusIn[31:0] = Port[31:0];
	end
endmodule
