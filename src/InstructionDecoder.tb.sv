`default_nettype none
`timescale 10ns/1ns

`include "TestbenchRunner.h.sv"

module InstructionDecoderTestbench #(
	parameter integer INSTRUCTION_BIT_WIDTH = 14
);
	bit sync_reset;
	bit clock;

	TestbenchRunner test_runner (
		.sync_reset(sync_reset),
		.clock(clock)
	);

	bit[INSTRUCTION_BIT_WIDTH - 1 : 0] dut_bus;
	bit dut_is_destination_w;

	InstructionDecoder #(
		.INSTRUCTION_BIT_WIDTH(INSTRUCTION_BIT_WIDTH)
	) dut (
		.bus(dut_bus),
		.is_destination_w(dut_is_destination_w)
	);

	Instructions #(.INSTRUCTION_BIT_WIDTH(INSTRUCTION_BIT_WIDTH)) instructions ();

	initial begin
		dut_bus <= 0;
	end

	`BEGIN_TEST_SUITE(test_runner)
		`TEST(addwf__d_bit_is_0__expect_is_destination_w_true)
		`TEST(addwf__d_bit_is_1__expect_is_destination_w_false)
	`END_TEST_SUITE

	task addwf__d_bit_is_0__expect_is_destination_w_true;
		integer w;
		for (w = 0; w < instructions.NUMBER_OF_W; w += 1) begin
//			@(posedge clock) dut_bus = instructions.addwf(w, any_f(), instructions.Dbits.W);
			@(posedge clock) `ASSERT(dut_is_destination_w);
		end
	endtask

	function bit[6:0] any_f();
		any_f = $urandom_range(0, 127);
	endfunction

	task addwf__d_bit_is_1__expect_is_destination_w_false;
		integer w;
		for (w = 0; w < instructions.NUMBER_OF_W; w += 1) begin
//			@(posedge clock) dut_bus = instructions.addwf(w, any_f(), instructions.Dbits.F);
			@(posedge clock) `ASSERT(!dut_is_destination_w);
		end
	endtask
endmodule
