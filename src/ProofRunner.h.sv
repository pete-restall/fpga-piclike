`ifndef __NET_RESTALL_PICLIKE_PROOFHRUNNER
`define __NET_RESTALL_PICLIKE_PROOFRUNNER

`define BEGIN_PROOF \
	bit __proof_sync_reset; \
	bit __proof_proof_clock; \
	bit __proof_clock; \
	bit[31:0] __proof_past; \
	bit[31:0] __proof_past_after_reset; \
\
	initial assume(__proof_sync_reset); \
	initial assume(__proof_past == 0 && __proof_past_after_reset == 0); \
\
	always @(__proof_proof_clock) begin \
		assume(__proof_past >= __proof_past_after_reset); \
		assume(!__proof_sync_reset || __proof_past_after_reset == 0); \
	end \
\
	always @(posedge __proof_clock) begin \
		assume(__proof_past == 0 || $stable(__proof_sync_reset) || ($fell(__proof_sync_reset) && !$rose(__proof_sync_reset))); \
	end \
\
	ProofRunner __proof_runner ( \
		.sync_reset(__proof_sync_reset), \
		.proof_clock(__proof_proof_clock), \
		.clock(__proof_clock), \
		.past(__proof_past), \
		.past_after_reset(__proof_past_after_reset) \
	);

`define ALWAYS_POSEDGE_CLOCK always @(posedge __proof_clock)
`define ALWAYS_NEGEDGE_CLOCK always @(negedge __proof_clock)

`define ALWAYS_POSEDGE_CLOCK_WITH_PAST_AFTER_RESET(number_of_clocks) `ALWAYS_POSEDGE_CLOCK if (__proof_past_after_reset >= number_of_clocks)
`define ALWAYS_NEGSEDGE_CLOCK_WITH_PAST_AFTER_RESET(number_of_clocks) `ALWAYS_NEGEDGE_CLOCK if (__proof_past_after_reset >= number_of_clocks)

`define ALWAYS_POSEDGE_CLOCK_WITH_PAST(number_of_clocks) `ALWAYS_POSEDGE_CLOCK if (__proof_past >= number_of_clocks)
`define ALWAYS_NEGEDGE_CLOCK_WITH_PAST(number_of_clocks) `ALWAYS_NEGEDGE_CLOCK if (__proof_past >= number_of_clocks)

`endif
