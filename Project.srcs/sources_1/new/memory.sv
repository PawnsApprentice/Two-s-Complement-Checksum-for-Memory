`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2020 11:10:33 PM
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module memory(
	input clock,
	input [7:0]data,
	input [3:0]addr,
	input sel,
	input logic reset,
	output logic [7:0]data_out
);


reg [7:0]memory_array[15:0];
reg [3:0]addr_reg;

assign data_out = memory_array[addr_reg];

always@(posedge clock or posedge reset) begin
	if(reset)
	begin
		memory_array[0] <= 8'h00;
		memory_array[1] <= 8'h01;
		memory_array[2] <= 8'h02;
		memory_array[3] <= 8'h03;
		memory_array[4] <= 8'h04;
		memory_array[5] <= 8'h05;
		memory_array[6] <= 8'h06;
		memory_array[7] <= 8'h07;
		memory_array[8] <= 8'h08;
		memory_array[9] <= 8'h09;
		memory_array[10] <= 8'h0A;
		memory_array[11] <= 8'h0B;
		memory_array[12] <= 8'h0B;
		memory_array[13] <= 8'h0D;
		memory_array[14] <= 8'h0E;
		memory_array[15] <= 8'h0F;
	end
	else
	begin
		if (sel )
		begin
			memory_array[addr] <= data;
			 
		end
		else if (~sel)
			addr_reg <= addr;
			
	end
end
endmodule 

