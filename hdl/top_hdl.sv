// Module: top_hdl.sv
// Author: Rehan Iqbal
// Date: January 15th, 2018
// Organization: Portland State University
//
// Description:
//
// This module provides the top-level HDL code to run in Questa.
//
////////////////////////////////////////////////////////////////////////////////

`include "definitions.sv"
`include "sequence_gen_test.v"
`include "sequence_gen.sv"

module top_hdl();

	timeunit 1ns / 1ps;

	/************************************************************************/
	/* Local parameters and variables										*/
	/************************************************************************/

	ulogic1		clk		= 1'b0;

	/************************************************************************/
	/* Module instantiations												*/
	/************************************************************************/

	//////////////////
	// sequence_gen //
	//////////////////

	sequence_gen i_sequence_gen (

		.clk      		(clk),			// I [0] clock signal
		.reset_n  		(reset_n),		// I [0] active-low reset
		.fibonacci		(fibonacci),	// I [0] mode: perform fibonacci calculation
		.triangle 		(triangle),		// I [0] mode: perform triangle calculation
		.load     		(load),			// I [0] active (2 cycles) --> load data into FSM
		.clear    		(clear),		// I [0] clear results off 'data_out' bus
		.order    		(order),		// I [15:0] calculate the Nth value of the sequence
		.data_in  		(data_in),		// I [63:0] initial value of the sequence

		.done     		(done),			// O [0] active (1 cycle) --> data is ready
		.data_out 		(data_out),		// O [63:0] calculated value of the sequence
		.overflow 		(overflow),		// O [0] calculation exceeds bus max
		.error    		(error)			// O [0] indicates bad control input or bad data

	);

	///////////////////////
	// sequence_gen_test //
	///////////////////////

	sequence_gen_test i_sequence_gen_test (

		.clk      		(clk),			// I [0] clock signal
		.done     		(done),			// I [0] active (1 cycle) --> data is ready
		.error    		(error),		// I [0] indicates bad control input or bad data
		.overflow 		(overflow),		// I [0] calculation exceeds bus max
		.data_out 		(data_out),		// I [63:0] calculed value of the sequence

		.reset_n  		(reset_n),		// O [0] active-low reset
		.load     		(load),			// O [0] active (2 cycles) load data into FSM
		.fibonacci		(fibonacci),	// O [O] mode: perform fibonacci calculation
		.triangle 		(triangle),		// O [0] mode: perform triangle calculation
		.clear    		(clear),		// O [0] clear results off 'data_out' bus
		.order    		(order),		// O [15:0] calculate the Nth value of the sequence
		.data_in  		(data_in)		// O [63:0] initial value of the sequence

	);

	/************************************************************************/
	/* initial block : clk													*/
	/************************************************************************/

	initial begin
		clk = 1'b0;
		forever #0.5 clk = !clk;
	end

endmodule // top_hdl