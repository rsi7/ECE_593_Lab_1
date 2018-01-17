// Module: sequence_gen.sv
// Author: Rehan Iqbal
// Date: January 15th, 2018
// Organization: Portland State University
//
// Description:
//
// This module generates a sequence (either Fibonacci or triangle).
//
////////////////////////////////////////////////////////////////////////////////

`include "definitions.sv"

module sequence_gen (

	/************************************************************************/
	/* Top-level port declarations											*/
	/************************************************************************/

	input	ulogic1		clk,		// clock signal
	input	ulogic1		reset_n,	// active-low reset

	input	ulogic1		fibonacci,	// mode: perform fibonacci calculation
	input	ulogic1		triangle,	// mode: perform triangle calcuation

	input	ulogic1		load,		// active (2 cycles) --> load data into FSM
	input	ulogic1		clear,		// clear results off 'data_out' bus

	input	ulogic16	order,		// calculate the Nth value of the sequence
	input	ulogic64	data_in,	// initial value of the sequence

	output	ulogic1		done,		// active (1 cycle) --> data is ready
	output	ulogic64	data_out,	// calculated value of the sequence
	output	ulogic1		overflow,	// calculation exceeds bus max
	output	ulogic1		error		// indicates bad control input or bad data

	);

	/*************************************************************************/
	/* Local parameters and variables										 */
	/*************************************************************************/

	state_t		state	= UNKNOWN;
	state_t		next	= UNKNOWN;

	ulogic64	temp_data_out	= '0;
	ulogic1		flag_ovrflow	= 1'b0;
	ulogic1		flag_done		= 1'b0;

	/************************************************************************/
	/* Module instantiations												*/
	/************************************************************************/

	unsigned logic [63:0] op_a;
	unsigned logic [63:0] op_b;
	unsigned logic [63:0] sum;

	n_bit_full_adder i_n_bit_full_adder (

		.op_a		(op_a),		// I [64] operand a
		.op_b		(op_b),		// I [64] operand b
		.sum		(sum),		// O [64] sum
		.overflow	(overflow)	// O [0]  overflow

		);

	/*************************************************************************/
	/* FSM Block 1: reset & state advancement								 */
	/*************************************************************************/

	always_ff@(posedge clk) begin

		// synchronous reset the FSM to idle state
		if (!reset_n) begin
			state <= RESET;
		end

		// otherwise, advance the state
		else begin
			state <= next;
		end

	end

	/*************************************************************************/
	/* FSM Block 2: state transistions & outputs							 */
	/*************************************************************************/

	always_comb begin

		done = 1'b0;
		data_out = '0;
		overflow = 1'b0;
		error = 1'b0;

		next = 'x;

		unique case (state)

			RESET : begin
				if (!reset_n) next = RESET;
				else next = IDLE;
			end

			IDLE : begin
				if (load && triangle) next = LOAD_TRI;
				else if (load && fibonacci) next = LOAD_FIB;
				else next = IDLE;
			end

			LOAD_TRI : begin
				if (!load) next = IDLE;
				else if (~|order) next = ERROR;
				else next = TRI_ADD;
			end

			LOAD_FIB : begin
				if (!load) next = IDLE;
				else if ((~|order) || (~|data_in)) next = ERROR;
				else next = FIB_ADD;
			end

			ERROR : begin
				error = 1'b1;
				data_out = 'x;
				if (clear) next = IDLE;
				else next = ERROR;
			end

			TRI_ADD : begin
				if (flag_ovrflow) next = OVRFLOW;
				else if (flag_done) next = DONE;
				else next = TRI_ADD;
			end

			FIB_ADD : begin
				if (flag_ovrflow) next = OVRFLOW;
				else if (flag_done) next = DONE;
				else next = TRI_ADD;
			end

			DONE : begin
				next = IDLE;
				done = 1'b1;
				data_out = temp_data_out;
			end

			OVRFLOW : begin
				overflow = 1'b1;
				data_out = '1;
				if (clear) next = IDLE;
				else next = OVRFLOW;
			end

		endcase // state

	end // always_comb

endmodule // sequence_gen