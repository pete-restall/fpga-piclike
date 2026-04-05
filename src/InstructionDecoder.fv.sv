`default_nettype none
`timescale 10ns/1ns

`include "ProofRunner.inc.sv"

module InstructionDecoderVerification #(
	parameter integer INSTRUCTION_BIT_WIDTH = 14
);
	`BEGIN_PROOF

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

	`ALWAYS_POSEDGE_CLOCK begin
		if (!__proof_sync_reset) begin
			casez (dut_bus)
				instructions.ADDWF_MASK | (1 << 7): assert(dut_is_destination_w);
				default: assert(!dut_is_destination_w);
			endcase
		end else begin
			assert(!dut_is_destination_w);
		end
	end
endmodule
