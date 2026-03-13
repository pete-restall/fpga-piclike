`default_nettype none

module IceSugar(
	input bit CLOCK,

	output bit LED_G,
	output bit LED_R,
	output bit LED_B,

	input bit UART_RX,
	output bit UART_TX,

	input bit USB_DP,
	input bit USB_DN,
	input bit USB_PULLUP,

	output bit SPI_SS,
	output bit SPI_SCK,
	output bit SPI_MOSI,
	input bit SPI_MISO
);

	assign LED_R = 0;
	assign LED_G = 0;
	assign LED_B = 0;

	assign UART_TX = 0;

	assign SPI_SS = 0;
	assign SPI_SCK = 0;
	assign SPI_MOSI = 0;

endmodule
