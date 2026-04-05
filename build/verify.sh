#!/usr/bin/env bash
set -e;

PROOF_OUT_DIR="out/proofs/working";
PROOF_OUT_PROVEN_DIR="out/proofs/proven";
PROOF_OUT_DISPROVEN_DIR="out/proofs/disproven";

run_proofs() {
	proofs=$@;

	number_of_proofs=0;
	number_of_proof_failures=0;
	for proof_sv in ${proofs}; do
		number_of_proofs=$((${number_of_proofs} + 1));
		proof="$(dirname "${proof_sv}")/$(basename -s.sv "${proof_sv}")";

		set +e;
		if [ -f "${proof}.params" ]; then
			cat "${proof}.params";
		else
			echo "";
		fi | xargs -I % bash -c "run_proof '${PROOF_OUT_DIR}' '${PROOF_OUT_PROVEN_DIR}' '${PROOF_OUT_DISPROVEN_DIR}' '${proof}' %";
		if [ $? -ne 0 ]; then
			number_of_proof_failures=$((${number_of_proof_failures} + 1));
		fi
		set -e;
	done

	echo "---";
	echo "[RESULT] ${number_of_proofs} proofs; $((${number_of_proofs} - ${number_of_proof_failures})) passed, ${number_of_proof_failures} failed.";
	if [ ${number_of_proof_failures} -ne 0 ]; then
		return 1;
	else
		return 0;
	fi
}

run_proof() {
	proof_out_dir="$1";
	proof_out_proven_dir="$2";
	proof_out_disproven_dir="$3";
	proof="$4";
	args=${@:5};

	proof_dir="$(dirname "${proof}")";
	proof_name="$(basename "${proof}")";
	dut_module_name="$(basename -s.fv "${proof_name}")";
	proof_module_name="${dut_module_name}Verification";

	proving_parent_dir="${proof_out_dir}/${proof_dir}";
	mkdir -p "${proving_parent_dir}";
	proving_dir="$(mktemp -d "${proving_parent_dir}/XXXX")";

# TODO: USE sv2v, which allows the use of interfaces, etc.  There's no module / include discovery, however, so think of a better way to add all files to its input.
# With sv2v the resulting Verilog ought to be more consistently parsed between tools, but the names of the signals will differ.
	iverilog -g2012 "-I${proof_dir}" "-y${proof_dir}" -Y.sv -o /dev/null "-Mprefix=${proving_dir}/proof.deps" -i -s "${proof_module_name}" "${proof}.sv";
	if [ $? -eq 0 ]; then
		dep_modules=$(cat "${proving_dir}/proof.deps" | grep '^M ' | sort | uniq | sed -E 's/^M (.+)$/\1/' | grep -v "^${proof}.sv\$");
		dep_includes=$(cat "${proving_dir}/proof.deps" | grep '^I ' | sort | uniq | sed -E 's/^I (.+)$/\1/' | grep -v "^${proof}.sv\$");
		cat > "${proving_dir}/proof.sby" <<-EOF
			[tasks]
			bmc
			prove
			cover
			bmc prove cover : default

			[options]
			bmc:
			mode bmc
			multiclock on
			--
			prove:
			mode prove
			multiclock on
			--
			cover:
			mode cover
			multiclock on
			--

			[engines]
			smtbmc

			[script]
			plugin -i slang
			read_slang --std 1800-2023 "${proof}.sv"
			#read -sv -formal "${proof}.sv"
			$(for m in ${dep_modules}; do echo "read_slang --std 1800-2023 \"${m}\" #read -sv \"${m}\""; done)
			$(for i in ${dep_includes}; do echo "read_slang --std 1800-2023 \"${m}\" #read -sv \"${i}\""; done)
			hierarchy -check -top ${proof_module_name} ${args}
			prep -top ${proof_module_name}

			[files]
			$(echo -e "${proof}.sv\t${proof}.sv" | sed -E 's/ /\\ /g' | tr "\t" " ")
			$(for m in ${dep_modules}; do echo -e "${m}\t${m}" | sed -E 's/ /\\ /g' | tr "\t" " "; done)
			$(for i in ${dep_includes}; do echo -e "${i}\t${i}" | sed -E 's/ /\\ /g' | tr "\t" " "; done)
		EOF

		sby --prefix "${proving_dir}/yosys" -f "${proving_dir}/proof.sby";
		result=$?;
	else
		result=1;
	fi

	if [ ${result} -eq 0 ]; then
		mkdir -p "${proof_out_proven_dir}/${proof_dir}";
		mv "${proving_dir}" "${proof_out_proven_dir}/${proof_dir}/";
	else
		mkdir -p "${proof_out_disproven_dir}/${proof_dir}";
		mv "${proving_dir}" "${proof_out_disproven_dir}/${proof_dir}/";
	fi

	return ${result};
}

export -f run_proof;

rm -rf "${PROOF_OUT_DIR}" "${PROOF_OUT_PROVEN_DIR}" "${PROOF_OUT_DISPROVEN_DIR}";
mkdir -p "${PROOF_OUT_DIR}" "${PROOF_OUT_PROVEN_DIR}" "${PROOF_OUT_DISPROVEN_DIR}";

proofs=${*:-$(find src/ -iname '*.fv.sv')};
run_proofs ${proofs};
