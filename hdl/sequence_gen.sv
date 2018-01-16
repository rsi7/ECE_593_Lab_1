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

	/************************************************************************/
	/* Module instantiations												*/
	/************************************************************************/

	/*************************************************************************/
	/* FSM Block 1: reset & state advancement								 */
	/*************************************************************************/

	always@(posedge clk or negedge reset_n) begin

		// reset the FSM to idle state
		if (!reset_n) begin
			state <= IDLE;
		end

		// otherwise, advance the state
		else begin
			state <=next;
		end

	end

	/*************************************************************************/
	/* FSM Block 2: state transistions										 */
	/*************************************************************************/

	/*************************************************************************/
	/* FSM Block 3: assigning outputs										 */
	/*************************************************************************/


endmodule // sequence_gen