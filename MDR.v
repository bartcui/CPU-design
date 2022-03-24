`timescale 1ns/100ps
module MDR(
	output reg [31:0] MDRout,
	input [31:0] busMuxOut, mDataIn, FromRAM,
	input MDRin, clk, clr, read, readRAM
);
	initial MDRout = 0;
	always @(posedge MDRin or posedge clr or posedge read or posedge readRAM or posedge clk)
		begin
			if(clr)
					MDRout = 0;
			else if(MDRin)
				if(read)
					MDRout = mDataIn;
				else if(readRAM)
					#5 MDRout = FromRAM;
				else
					MDRout = busMuxOut;	
		end
endmodule