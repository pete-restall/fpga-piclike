`default_nettype none

module Instructions #(
	parameter integer INSTRUCTION_BIT_WIDTH = 16
);
	initial if (INSTRUCTION_BIT_WIDTH < 14 || INSTRUCTION_BIT_WIDTH > 32) begin
		$display("Instruction bus must have a bit-width in the range [14, 32]");
		$exit(1);
	end

	localparam W_BIT_WIDTH = INSTRUCTION_BIT_WIDTH - 14; // TODO: limit to 4; if using, say, 18 bits then we can use the other two for extending 'f' or something
	localparam NUMBER_OF_W = 1 << W_BIT_WIDTH;

	typedef bit[INSTRUCTION_BIT_WIDTH - 1 : 0] Instruction;
	typedef logic[13:0] InstructionMask;
	typedef bit[W_BIT_WIDTH - 1 : 0] Wbits;
	typedef bit[6:0] Fbits;
	typedef enum bit { W = 0, F = 1 } Dbits;

	logic[W_BIT_WIDTH - 1 : 0] W_MASK = 'b????????_????????_????????;

	InstructionMask ADDWF_MASK = 'b00_0111_????_????;

	function Instruction addwf(Wbits w, Fbits f, Dbits d);
		addwf = {w, ADDWF_MASK | f | (d << 7)};
	endfunction
endmodule
