// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version"
// CREATED		"Thu Feb 17 15:18:50 2022"

module RAM(
	Read,
	Clock,
	ReadEn,
	Write,
	WriteEnable,
	address,
	data,
	out
);


input wire	Read;
input wire	Clock;
input wire	ReadEn;
input wire	Write;
input wire	WriteEnable;
input wire	[8:0] address;
input wire	[31:0] data;
output wire	[31:0] out;






lpm_ram_dp_0	b2v_RAM(
	.rden(Read),
	.rdclock(Clock),
	.rdclken(ReadEn),
	.wren(Write),
	.wrclock(Clock),
	.wrclken(WriteEnable),
	.data(data),
	.rdaddress(address),
	.wraddress(address),
	.q(out));


endmodule

module lpm_ram_dp_0(rden,rdclock,rdclken,wren,wrclock,wrclken,data,rdaddress,wraddress,q);
/* synthesis black_box */

input rden;
input rdclock;
input rdclken;
input wren;
input wrclock;
input wrclken;
input [31:0] data;
input [8:0] rdaddress;
input [8:0] wraddress;
output [31:0] q;

endmodule
