module MDR(
	output reg [31:0] MDRout,
	input [31:0] busMuxOut, mDataIn,
	input MDRin, clk, clr, read
);
	initial MDRout = 0;
	always @(posedge clk)
		begin
			if(clr)
					MDRout = 0;
			else if(MDRin)
				if(read)
					MDRout = mDataIn;
				else
					MDRout = busMuxOut;	
		end
endmodule
