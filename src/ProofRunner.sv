`default_nettype none
`timescale 1ns/100ps

module ProofRunner #(
	parameter bit[7:0] RESET_COUNTER = 4
)(
	output bit sync_reset,
	output bit proof_clock,
	output bit clock,
	output bit[31:0] past,
	output bit[31:0] past_after_reset
);
	bit[7:0] reset_counter;

	initial begin
		reset_counter <= RESET_COUNTER;

		sync_reset <= 1;
		proof_clock <= 0;
		clock <= 1;
		past <= 0;
		past_after_reset <= 0;
	end

	(* gclk *) bit yosys_clock;
	always @(*) proof_clock <= yosys_clock;
	always @(yosys_clock) clock <= !clock;

	always @(posedge clock) begin
		past <= past + 1;
		assert(past < ~0);

		if (reset_counter != 0) begin
			reset_counter <= reset_counter - 1;
			past_after_reset <= 0;
		end else begin
			past_after_reset <= past_after_reset + 1;
			assert(past_after_reset < ~0);
		end

		sync_reset <= reset_counter != 0;
	end
endmodule
