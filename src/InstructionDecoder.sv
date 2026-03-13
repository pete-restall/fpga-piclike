`default_nettype none

module InstructionDecoder #(
	parameter integer INSTRUCTION_BIT_WIDTH = 16
)(
	input bit[INSTRUCTION_BIT_WIDTH - 1 : 0] bus,
	output bit is_destination_w
);

	Instructions #(.INSTRUCTION_BIT_WIDTH(INSTRUCTION_BIT_WIDTH)) instructions ();

	assign is_destination_w = (bus & 128) == 0 && INSTRUCTION_BIT_WIDTH != 16;
endmodule
