`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2020 11:08:53 PM
// Design Name: 
// Module Name: ten_sec
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

module ten_sec(
	input clock,
	input enable,
	output ten_sec_up
	);

logic [27:0] ten_seconds_counter; // counter for generating 1 second clock enable


always_ff@(posedge clock or posedge enable)
begin
    if(enable==1)
        ten_seconds_counter <= 0;
        else begin
        if(ten_seconds_counter>=999999999) 
	        ten_seconds_counter <= 0;
        else
            ten_seconds_counter <= ten_seconds_counter + 1;
    end
end

assign ten_sec_up = (ten_seconds_counter == 999999999) ? 1 : 0;

endmodule

