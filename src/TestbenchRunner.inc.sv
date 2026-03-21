`ifndef __NET_RESTALL_PICLIKE_TESTBENCHRUNNER
`define __NET_RESTALL_PICLIKE_TESTBENCHRUNNER

`define BEGIN_TEST_SUITE(test_runner) \
	integer __test_number_of_failed_assertions; \
\
	initial if (`"test_runner`" != {"test", "_runner"}) begin \
		$display({"[COMPILATION ERROR] test_runner must be called 'test", "_runner' because iverilog does not fully support 'alias'"}); \
		$finish_and_return(1); \
	end \
\
	initial __test_run_all(); \
	task __test_run_all();

`define TEST(test) \
		__test_number_of_failed_assertions = 0; \
		test_runner.on_next_test(`"test`"); \
		test(); \
		if (__test_number_of_failed_assertions > 0) \
			test_runner.on_test_failed(); \
		else \
			test_runner.on_test_passed();

`define END_TEST_SUITE \
		$display( \
			"[BENCH] %0d tests run; %0d passed, %0d failed", \
			test_runner.number_of_tests, \
			(test_runner.number_of_tests - test_runner.number_of_failed_tests), \
			test_runner.number_of_failed_tests); \
\
		$finish_and_return(test_runner.number_of_failed_tests > 0 ? 1 : 0); \
	endtask

`define ASSERT(predicate) \
	assert(predicate) else begin \
		__test_number_of_failed_assertions += 1; \
	end

`define ASSERT_BECAUSE(predicate, reason) \
	assert(predicate) else begin \
		$display("    because ", reason); \
		__test_number_of_failed_assertions += 1; \
	end

`endif
