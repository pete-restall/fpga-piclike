#!/usr/bin/env bash
set -e;

TEST_OUT_DIR="out/tests/working";
TEST_OUT_PASSED_DIR="out/tests/passed";
TEST_OUT_FAILED_DIR="out/tests/failed";

run_testbenches() {
	testbenches=$@;

	number_of_testbenches=0;
	number_of_testbench_failures=0;
	for testbench_sv in ${testbenches}; do
		number_of_testbenches=$((${number_of_testbenches} + 1));
		testbench="$(dirname "${testbench_sv}")/$(basename -s.sv "${testbench_sv}")";
		if [ -f "${testbench}.params" ]; then
			cat "${testbench}.params";
		else
			echo "";
		fi | xargs -I % bash -c "run_testbench '${TEST_OUT_DIR}' '${TEST_OUT_PASSED_DIR}' '${TEST_OUT_FAILED_DIR}' '${testbench}' %";
		if [ $? -ne 0 ]; then
			number_of_testbench_failures=$((${number_of_testbench_failures} + 1));
		fi
	done

	echo "---";
	echo "[RESULT] ${number_of_testbench_failures} out of ${number_of_testbenches} testbenches failed.";
	if [ ${number_of_testbench_failures} -ne 0 ]; then
		return 1;
	else
		return 0;
	fi
}

run_testbench() {
	test_out_dir="$1";
	test_out_passed_dir="$2";
	test_out_failed_dir="$3";
	testbench="$4";
	args=${@:5};

	testbench_dir="$(dirname "${testbench}")";
	testbench_name="$(basename "${testbench}")";
	dut_module_name="$(basename -s.tb "${testbench_name}")";
	testbench_module_name="${dut_module_name}Testbench";

	testing_parent_dir="${test_out_dir}/${testbench_dir}";
	mkdir -p "${testing_parent_dir}";
	testing_dir="$(mktemp -d "${testing_parent_dir}/XXXX")";
	iverilog -g2012 "-I${testbench_dir}" "-y${testbench_dir}" -Y.sv -o "${testing_dir}/${testbench_name}.vvp" -s "${testbench_module_name}" ${args} "${testbench}.sv";
	if [ $? -eq 0 ]; then
		pushd "${testing_dir}";
		vvp "${testbench_name}.vvp";
		result=$?;
		popd;
	else
		result=1;
	fi

	if [ ${result} -eq 0 ]; then
		mkdir -p "${test_out_passed_dir}/${testbench_dir}";
		mv "${testing_dir}" "${test_out_passed_dir}/${testbench_dir}/";
	else
		mkdir -p "${test_out_failed_dir}/${testbench_dir}";
		mv "${testing_dir}" "${test_out_failed_dir}/${testbench_dir}/";
	fi

	return ${result};
}

export -f run_testbench;

rm -rf "${TEST_OUT_DIR}" "${TEST_OUT_PASSED_DIR}" "${TEST_OUT_FAILED_DIR}";
mkdir -p "${TEST_OUT_DIR}" "${TEST_OUT_PASSED_DIR}" "${TEST_OUT_FAILED_DIR}";

testbenches=${*:-$(find src/ -iname '*.tb.sv')};
run_testbenches ${testbenches};
