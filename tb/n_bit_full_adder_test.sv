// Module: n_bit_full_adder_test.sv
// Author: Rehan Iqbal
// Date: January 16th, 2018
// Organziation: Portland State University
//
// Description:
//
// Simple testbench module for the "n_bit_full_adder.sv" module. Randomly
// generates some data on input operands A & B and compares DUT results
// against testbench arithmetic.
//
////////////////////////////////////////////////////////////////////////////////

`include "../hdl/definitions.sv"
`include "../hdl/n_bit_full_adder.sv"

module n_bit_full_adder_test ();

	timeunit 10ns / 1ns;

	/*************************************************************************/
	/* Local parameters and variables										 */
	/*************************************************************************/

	ulogic1		clk;
	localparam	rounds = 128;

	// Signals used by SW testbench internally
	ulogic64	sw_sum;
	ulogic1		sw_overflow;

	// Signals from hardware DUT
	ulogic64	op_a, op_b;
	ulogic64	sum;
	ulogic1		overflow;

	/************************************************************************/
	/* Module instantiations												*/
	/************************************************************************/

	n_bit_full_adder n_bit_full_adder (.*);

	/************************************************************************/
	/* initial block : clk													*/
	/************************************************************************/

	initial begin
		clk = 1'b0;
		forever #0.5 clk = !clk;
	end

	initial begin

		int fhandle_wr;

		// format time units for printing later
		// also setup the output file location

		$timeformat(-9, 0, "ns", 8);
		fhandle_wr = $fopen("C:/Users/riqbal/Dropbox/ECE 593/Labs/Lab 1/results/n_bit_full_adder_test_results.txt");

		// print header at top of write log
		$fwrite(fhandle_wr,"ECE 593 -- Lab 1 -- n_bit_full_adder_test:\n\n");

		repeat (5) @ (posedge clk);

		for (int i = 0; i < rounds; i++) begin

			op_a = {2{$urandom_range(32'hFFFFFFFF, 32'd0)}};
			op_b = {2{$urandom_range(32'hFFFFFFFF, 32'd0)}};

			{sw_overflow, sw_sum} = op_a + op_b;

			repeat (1) @ (posedge clk);

			$fwrite(fhandle_wr,		"Time:%t\t", $time,
									"Round:%2d\t", i,
									"Op A: %h\t", op_a,
									"Op B: %h\t", op_b,
									"HW sum: %h\t", sum,
									"SW sum: %h\t", sw_sum,
									"HW overflow: %b\t", overflow,,
									"SW overflow: %b\n", sw_overflow);

		end // for

		$fwrite(fhandle_wr, "\nEND OF SIMULATION");
		$fclose(fhandle_wr);
		$stop;

	end	// initial

endmodule // n_bit_full_adder_test