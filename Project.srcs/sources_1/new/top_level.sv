`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2020 11:13:34 PM
// Design Name: 
// Module Name: top_level
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


module top_level(
	// Inputs
	input clock,			// 100 Mhz clock source on Basys 3 FPGA
	input [7:0]data, 		// SW15 to SW8
	input [3:0]address, 	// SW3 to SW0
	input master_reset,		// Active High Reset

	// Buttons to select opetations
	input enter_data,		
	input run_checksum,
	input previous_data,
	input next_data,
	input display_counter,


	// Outputs
	output [7:0]data_LEDs, 	// LEDs corresponding to Data Input Switches
	output [3:0]addr_LEDs, 	// LEDs correspoding to Address Input Switches

	// Seven Segment Outputs
	output [6:0]seg, logic dp, output [3:0] an
	);

// Debouncing button wires
logic enter_data_fix;		
logic run_checksum_fix;
logic previous_data_fix;
logic next_data_fix;
logic display_counter_fix;

assign data_LEDs = data;
assign addr_LEDs = address;

// Debounce Module Instantiation	
debouncer d1(clock, enter_data, enter_data_fix);
debouncer d2(clock, run_checksum, run_checksum_fix);
debouncer d3(clock, previous_data, previous_data_fix);
debouncer d4(clock,next_data,next_data_fix);
debouncer d5(clock, display_counter, display_counter_fix);

// Wires to the memory
logic [7:0]mem_data;
logic [3:0]mem_address;
logic [7:0]mem_data_out1;
logic reseted;

// Memory Module Instantiation
memory m1(clock, mem_data, mem_address,enter_data_fix,reseted, mem_data_out1);

// Wires to the operation module
logic [3:0]seg_datams;
logic [3:0]seg_datals;
logic [3:0]seg_address;
logic[5:0] eqordash;



// Seven Segment Module Instantiation
Seven_segment s1(clock, seg_datals, seg_datams, eqordash  ,seg_address , seg, dp, an);
    

// Check sum wires
logic [7:0] checksum_data;
logic checksum_complete;
logic [3:0]checksum_addr;
logic [15:0]counter_value;
logic [7:0] mem_data_out;
logic resetcheck;
logic startcheck;

// Check sum module instatiation
checksum c1(clock, resetcheck, mem_data_out, startcheck, display_counter_fix, counter_value, checksum_complete, checksum_addr, checksum_data);
// Mode Operations

always @(posedge clock)
begin
if(master_reset == 1)
begin
seg_datams = 0;
seg_datals = 0;
seg_address = 0;
mem_data = 0;
mem_address = 0;
eqordash = 0;
resetcheck = 0;
reseted = 1;
end

else if(enter_data_fix && (!next_data_fix)&& (!previous_data_fix)&& (!run_checksum_fix) && !display_counter_fix)
begin
reseted = 0;
mem_data = data;
mem_address = address;
//has to do with checksum
mem_data_out = data;
startcheck = enter_data_fix;
end

else if(!enter_data_fix && (next_data_fix)&& (!previous_data_fix)&& (!run_checksum_fix) && !display_counter_fix)
begin

reseted = 0;
mem_address = address+1;
seg_datams = mem_data_out1[7:4];
seg_datals =  mem_data_out1[3:0];
seg_address = address+1;
eqordash = 16;
startcheck = enter_data_fix;

//in case the button doesnt work startcheck = 0;

end

else if(!enter_data_fix && (!next_data_fix) && (previous_data_fix)&& (!run_checksum_fix) && !display_counter_fix)
begin

mem_address = address-1;
seg_datams = mem_data_out1[7:4];
seg_datals =  mem_data_out1[3:0];
seg_address = address-1;
eqordash = 16;
startcheck = enter_data_fix;
end

else if(!enter_data_fix && (!next_data_fix) && (!previous_data_fix) && (run_checksum_fix) && !display_counter_fix)
begin
seg_datams = checksum_data[7:4];
seg_datals = checksum_data[3:0];
seg_address = 12;
eqordash = 17;
startcheck = 1;
end


else if(!enter_data_fix && (!next_data_fix) && (!previous_data_fix) && (!run_checksum_fix) && display_counter_fix)
begin
seg_datams = counter_value[7:4];
seg_datals = counter_value[3:0];
seg_address = 12;
eqordash = 16;
startcheck = 1;
end


end
endmodule : top_level