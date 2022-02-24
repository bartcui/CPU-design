module OutPort(
	output reg [31:0] Port,
	input [31:0] BusOut,
	input Clear, Clock, OutPortIn
);
	initial Port = 0;
	always@(posedge Clock)
	begin
		if(Clear)
			Port[31:0] = 32'b0;
		else if(OutPortIn)
			Port[31:0] = BusOut[31:0];
	end
endmodule
