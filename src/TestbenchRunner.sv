`default_nettype none
`timescale 1ns/100ps

module TestbenchRunner #(
	parameter string VCD_FILENAME,
	parameter integer TIMEOUT_CLOCKS = 1024
)(
	output bit sync_reset,
	output bit clock
);
	initial begin
		clock <= 0;
		sync_reset <= 1;
		__test_number = 0;

		if (VCD_FILENAME != "") begin
			$dumpfile(VCD_FILENAME);
			$dumpvars(0);
		end
	end

	event __next_test;
	integer __test_number;
	event __test_done;

	task run();
		fork;
			clock_stimuli(TIMEOUT_CLOCKS, 10ns);
			run_tests();
		join;
	endtask

	task clock_stimuli(integer timeout_clocks, time clock_period);
		for (integer i = 0; i < timeout_clocks + 1; i++) begin
			clock <= 1;
			#(clock_period / 2ns);
			clock <= 0;
			#(clock_period - clock_period / 2ns);
			fail_if(i >= timeout_clocks, "testbench ran for too long (infinite loop protection in 'clock_stimuli')");
		end
	endtask

	task fail_if(bool has_failed, string reason);
		if (has_failed) begin
			$display("Failing because ", reason);
			$finish(1);
		end
	endtask

	task run_tests();
		for (__test_number = 0; __test_number < 1024; __test_number++) begin
			reset();
			-> __next_test;
			@(__test_done);
		end
		fail_if(1, "testbench ran for too long (infinite loop protection in 'run_tests')");
		$finish(0);
	endtask

	task reset();
		sync_reset <= 1;
		@(posedge clock);
		@(negedge clock);
		sync_reset <= 0;
	endtask
endmodule
