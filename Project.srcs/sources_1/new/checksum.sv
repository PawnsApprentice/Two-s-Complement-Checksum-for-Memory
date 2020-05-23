`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2020 11:12:17 PM
// Design Name: 
// Module Name: checksum
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


module checksum(
	input clock,
	input reset,
	input [7:0]data_in,
	input start,
	input counter_sel,
	output logic [15:0]counter_value,
	output logic checksum_complete,
	output logic [3:0]addr_out,
	output [7:0]data_out
	);

logic [4:0]addr_count = 0;
reg [7:0]data_buffer;

assign addr_out = addr_count[3:0];
assign data_out = checksum_complete ? (~data_buffer) + 1'b1 : 8'b0;

always_ff @(posedge clock) begin
	if(reset) 
	begin
		data_buffer <= 0;
		addr_count <= 0;
		checksum_complete <= 0;
	end
	else if(start)
		begin
			if(addr_count == 16)
			begin
				checksum_complete <= 1;
			end
			else
				addr_count <= addr_count + 1'b1;
				data_buffer <= data_buffer + data_in;
		end
end

    always @(posedge clock)
    begin
        if(~counter_sel && start)
            counter_value <= 0;
        else if (counter_sel && start)
            counter_value <= counter_value + 1;
    end

endmodule: checksum


