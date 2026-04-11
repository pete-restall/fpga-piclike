`default_nettype none

module IceSugar(
	input bit ICE_CLK,

	output bit LED_G,
	output bit LED_R,
	output bit LED_B
);

	assign LED_R = 0;
	assign LED_G = 0;
	assign LED_B = 0;

endmodule
