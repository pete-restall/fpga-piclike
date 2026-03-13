`ifndef __NET_RESTALL_PICLIKE_TESTBENCHRUNNER
`define __NET_RESTALL_PICLIKE_TESTBENCHRUNNER

`define BEGIN_TEST_SUITE(test_runner) \
	integer __number_of_test_failures; \
	integer __number_of_assertion_failures; \
	event __assertion_failure; \
\
	initial test_runner.run(); \
	initial __monitor_assertions(); \
	task __monitor_assertions(); \
		forever begin \
			@(__assertion_failure); \
			__number_of_assertion_failures += 1; \
		end \
	endtask \
\
	initial __dispatch_tests(); \
	task __dispatch_tests(); \
		__number_of_test_failures = 0; \
		forever begin \
			@(test_runner.__next_test); \
			if (__number_of_assertion_failures > 0) \
				__number_of_test_failures += 1; \
\
			__number_of_assertion_failures = 0; \
			fork; \
				case (test_runner.__test_number) \

`define END_TEST_SUITE \
					default: begin \
						$display("[BENCH] %0d out of %0d tests failed", __number_of_test_failures, test_runner.__test_number); \
						$finish_and_return(__number_of_test_failures > 0 ? 1 : 0); \
					end \
				endcase \
			join; \
			-> test_runner.__test_done; \
		end \
	endtask

`define ASSERT(predicate) assert(predicate) else -> __assertion_failure;

`define ASSERT_BECAUSE(predicate, reason) \
	assert(predicate) else begin \
		$display("    because ", reason); \
		-> __assertion_failure; \
	end

`endif
