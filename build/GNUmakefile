SRC_DIR := ../src
OUT_DIR := out
OUT_OBJ_DIR := $(OUT_DIR)/obj
OUT_TESTBENCHES_DIR := $(OUT_DIR)/testbenches
OUT_VERIFICATION_DIR := $(OUT_DIR)/verification
OUT_DOC_DIR := $(OUT_DIR)/doc

BASH := bash
NULL_FD := /dev/null

SRC_EXT := sv
OBJ_EXT := v
OBJ_VVP_EXT := vvp
OBJ_SBY_EXT := sby

TB_EXT := tb
H_SRC_EXT := h.$(SRC_EXT)
IF_SRC_EXT := if.$(SRC_EXT)
TB_SRC_EXT := $(TB_EXT).$(SRC_EXT)
TB_OBJ_EXT := $(TB_EXT).$(OBJ_EXT)
FV_SRC_EXT := fv.$(SRC_EXT)
FV_OBJ_EXT := fv.$(OBJ_EXT)
TOP_SRC_EXT := top.$(SRC_EXT)
TOP_OBJ_EXT := top.$(OBJ_EXT)
DOC_MD_SRC_EXT := md
DOC_MD_OBJ_EXT := md
DOC_WAVEDROM_SRC_EXT := wd
DOC_WAVEDROM_OBJ_EXT := svg

IVERILOG_DEPS_EXT := ideps
FILE_DEPS_EXT := fdeps
MAKE_DEPS_EXT := mdeps
SV2V_DEPS_EXT := sdeps
ARGS_EXT := args

MAX_ARGS := 16

TB_MODULE_SUFFIX := Testbench
FV_MODULE_SUFFIX := Verification
TOP_MODULE_SUFFIX :=

IVERILOG := iverilog
IVERILOG_ALL_FLAGS := -g2012
IVERILOG_DEPS_FLAGS := $(IVERILOG_ALL_FLAGS) -Y.$(SRC_EXT) -Y.$(IF_SRC_EXT) -i
IVERILOG_TB_FLAGS := $(IVERILOG_ALL_FLAGS)

VVP := vvp
VVP_ALL_FLAGS :=
VVP_TB_FLAGS := $(VVP_ALL_FLAGS)

SV2V := sv2v
SV2V_ALL_FLAGS := --siloed
SV2V_TB_FLAGS := $(SV2V_ALL_FLAGS)

########

find_src = $(call find_files,$(SRC_DIR),$(1))
find_files = $(shell find '$(1)' -type f -name '$(2)' 2>$(NULL_FD))
src_to_obj = $(patsubst $(SRC_DIR)/%,$(OUT_OBJ_DIR)/%,$(1:%.$(2)=%.$(3)))
obj_to_testbench_args = $(patsubst $(OUT_OBJ_DIR)/%,$(OUT_TESTBENCHES_DIR)/%,$(1:%.$(TB_OBJ_EXT)=%/testbench.$(MAKE_DEPS_EXT)))
obj_to_verification_args = $(patsubst $(OUT_OBJ_DIR)/%,$(OUT_VERIFICATION_DIR)/%,$(1:%.$(OBJ_SBY_EXT)=%/verification.$(MAKE_DEPS_EXT)))
doc_to_obj = $(patsubst $(SRC_DIR)/%,$(DOC_OBJ_DIR)/%,$(1:%.$(2)=%.$(3)))

TB_SRC := $(call find_src,*.$(TB_SRC_EXT))
TB_OBJ := $(call src_to_obj,$(TB_SRC),$(TB_SRC_EXT),$(TB_OBJ_EXT))
TB_RUNS := $(call obj_to_testbench_args,$(TB_OBJ))

FV_SRC := $(call find_src,*.$(FV_SRC_EXT))
FV_OBJ := $(call src_to_obj,$(FV_SRC),$(SRC_EXT),$(OBJ_EXT))
FV_SBY_OBJ := $(call src_to_obj,$(FV_SRC),$(FV_SRC_EXT),$(OBJ_SBY_EXT))
FV_RUNS := $(call obj_to_verification_args,$(FV_SBY_OBJ))

TOP_SRC := $(call find_src,*.$(TOP_SRC_EXT))
TOP_OBJ := $(call src_to_obj,$(TOP_SRC),$(SRC_EXT),$(OBJ_EXT))

MAKE_DEPS := $(call find_files,$(OUT_OBJ_DIR),*.$(MAKE_DEPS_EXT))

DOC_MD_SRC := $(call find_src,*.$(DOC_MD_SRC_EXT))
DOC_MD_OBJ := $(call doc_to_obj,$(DOC_MD_SRC),$(DOC_MD_SRC_EXT),$(DOC_MD_OBJ_EXT))

DOC_WAVEDROM_SRC := $(call find_src,*.$(DOC_WAVEDROM_SRC_EXT))
DOC_WAVEDROM_OBJ := $(call doc_to_obj,$(DOC_WAVEDROM_SRC),$(DOC_WAVEDROM_SRC_EXT),$(DOC_WAVEDROM_OBJ_EXT))

.PHONY: bits clean docs help pnr

help:
	@echo 'The following Makefile targets are available:';
	@echo '    all            Testbenches, proofs, synth, pnr, bits and docs';
	@echo '    bits           Generate FPGA bitstream';
	@echo '    clean          Remove all build artefacts';
	@echo '    docs           Build documentation';
	@echo '    help           This message (default)';
	@echo '    pnr            Place and Route';
	@echo '    proofs         Verify all formal proofs (*.$(FV_SRC_EXT))';
	@echo '    synth          Synthesise';
	@echo '    testbenches    Run all testbenches (*.$(TB_SRC_EXT))';
	@echo;

all: testbenches proofs synth pnr bits docs

testbenches: | $(TB_RUNS)

proofs: | $(FV_RUNS)

synth: $(TOP_OBJ)
	@echo '[SYNTH   ] TODO: RUN SYNTHESIS FOR $<';

pnr:
	@echo '[PNR     ] TODO: RUN PNR';

bits:
	@echo '[BITS    ] TODO: RUN BITSTREAM COMPILER';

docs: $(DOC_MD_OBJ) $(DOC_WAVEDROM_OBJ)
	@echo '[DOCS    ] TODO: RUN mdBook ON $<';

clean:
	@echo '[CLEAN   ] Cleaning up';
	rm -rf '$(OUT_DIR)';

prefixed_src_dirs = $(call prefixed_parent_dirs_from,$(1),$<)
prefixed_src_dirs_from = $(call prefixed_parent_dirs,$(1),$(SRC_DIR),$2)
prefixed_parent_dirs = $(shell next_dir(){ d=$$(dirname $$1) && echo -n "$(1)$${d} "; [ "_$${d}" != '_$(2)' ] && next_dir "$${d}"; } && next_dir '$(3)')
top_module_name_from_src = $(call top_module_name_from,$<)
top_module_name_from = $(basename $(notdir $(patsubst %.$(TOP_SRC_EXT),%$(TOP_MODULE_SUFFIX),$(patsubst %.$(FV_SRC_EXT),%$(FV_MODULE_SUFFIX),$(1:%.$(TB_SRC_EXT)=%$(TB_MODULE_SUFFIX))))))
top_module_name_from_make_deps = $(call top_module_name_from,$(<:%.$(MAKE_DEPS_EXT)=%.$(SRC_EXT)))

#$(OUT_OBJ_DIR)/%.$(MAKE_DEPS_EXT): $(SRC_DIR)/%.$(SRC_EXT)
#	@set -e; \
#	echo '[DEPS  ] $(top_module_name_from_src) ($< -> $@)'; \
#	mkdir -p '$(dir $@)'; \
#	$(IVERILOG) $(IVERILOG_DEPS_FLAGS) $(call prefixed_src_dirs,-I) $(call prefixed_src_dirs,-y) -o '$(NULL_FD)' '-Mprefix=$@.iv' -s '$(top_module_name_from_src)' '$<'; \
#	echo "$(@:%.$(DEPS_EXT)=%.$(OBJ_EXT)) $@ : $$(cat '$@.iv' | sed -E 's/^[IM] (.+)$$/\1/' | sort | uniq | paste -sd' ' -)" > '$@';
#
#.PRECIOUS: $(OUT_OBJ_DIR)/%.$(MAKE_DEPS_EXT)
#-include $(DEPS)

#$(OUT_TESTBENCHES_DIR)/%/testbench.$(DEPS_EXT): $(wildcard $(SRC_DIR)/%.args)
#	@set -e; \
#	echo '[TBENCH] Generating testbench arguments for $(call top_module_name_from,$(<:%.args=%.$(SRC_EXT))) ($< -> $@)'; \
#	seq $$(wc -l < '$<') | xargs -I ^ echo "$@ : $(@:%.$(DEPS_EXT)=%.^.$(OBJ_VVP_EXT))";
#
#.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%/testbench.$(DEPS_EXT)
#-include $(TB_DEPS)

#$(OUT_TESTBENCHES_DIR)/%.$(OBJ_VVP_EXT):
#	# TODO: run the vvp - need to figure out how to parameterise the runs (there is one VVP per parameter set...)
#	@set -e; \
#	echo '[TBENCH] Running $(top_module_name_from_src) ($< -> $@)'; \
#	pushd '$@'; \
#	$(VVP) $(VVP_TB_FLAGS) '$<';

#$(OUT_TESTBENCHES_DIR)/%/testbench.*.$(OBJ_VVP_EXT): $(OUT_OBJ_DIR)/%.$(OBJ_EXT)
#	# TODO: how to compile one VVP for each set of parameters ?
#	@set -e; \
#	echo '[TBENCH] Compiling $(top_module_name_from_src) ($< -> $@)'; \
#	mkdir -p '$(dir $@)'; \
#	$(IVERILOG) $(IVERILOG_TB_FLAGS) -o '$@' -s "${testbench_module_name}" ${args} '$<';

define _script_create_target_sby =
	@cat > '$@' <<-EOF
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
		read -formal "$<"
		hierarchy -check -top $(top_module_name_from_obj) # TODO: NEED TO FIGURE OUT HOW TO ADD CONTENTS OF *.params
		prep -top $(top_module_name_from_obj)

		[files]
	EOF
endef

export script_create_target_sby = $(value _script_create_target_sby)

#$(OUT_OBJ_DIR)/%.$(OBJ_SBY_EXT): $(OUT_OBJ_DIR)/%.$(OBJ_EXT)
#	@set -e; \
#	echo '[VERIFY] Generating SBY project for $(top_module_name_from_obj) ($< -> $@)'; \
#	mkdir -p '$(dir $@)'; \
#	eval "$${script_create_target_sby}";
#
#$(OUT_OBJ_DIR)/%.$(OBJ_EXT): $(OUT_OBJ_DIR)/%.$(DEPS_EXT)
#	@set -e; \
#	echo '[SV2V  ] $(top_module_name_from_deps) ($< -> $@)'; \
#	mkdir -p '$(dir $@)'; \
#	$(SV2V) $(SV2V_ALL_FLAGS) --top '$(top_module_name_from_deps)' $$(cat '$<' | sed -E 's/^[^:]+: //g') > $@;

$(OUT_OBJ_DIR)/%.$(TOP_OBJ_EXT): $(SRC_DIR)/%.$(PCF_EXT)
	@set -e; \
	echo '[COPY    ] Device constraints ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	cp '$<' '$@';

$(OUT_DOC_DIR)/%.$(DOC_MD_OBJ_EXT): $(SRC_DIR)/%.$(DOC_MD_SRC_EXT)
	@set -e; \
	echo '[COPY    ] Markdown Documentation ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	cp '$<' '$@';

$(OUT_DOC_DIR)/%.$(DOC_WAVEDROM_OBJ_EXT).svg: $(SRC_DIR)/%.$(DOC_WAVEDROM_SRC_EXT)
	@set -e; \
	echo '[WAVEDROM] Wavedrom Documentation ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	wavedrom --input '$<' --indent 4 > '$@';




all_possible_args := $(shell seq $(MAX_ARGS))

SED_REGEX_EXTRACT_DEFINES := "s/.*?(-D[^ =]+(=([^\"' ]+)|('[^']+')|(\"[^\"]+\"))?).*?/ \1/g"

define DEFINE_PARAMETERISED_TOP_RECIPES
$(OUT_TESTBENCHES_DIR)/%.$(i).$(IVERILOG_DEPS_EXT): $(OUT_TESTBENCHES_DIR)/%.$(i).$(ARGS_EXT) $(SRC_DIR)/%.$(SRC_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from,$(lastword $<)) ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	$(IVERILOG) $(IVERILOG_DEPS_FLAGS) $(call prefixed_src_dirs_from,-I,$(lastword $<)) $(call prefixed_src_dirs_from,-y,$(lastword $<)) $$(cat '$(firstword $<)') -o '$(NULL_FD)' '-Mprefix=$@' -s '$(call top_module_name_from,$(lastword $<))' '$(lastword $<)';

# TODO: OUT_VERIFICATION_DIR and OUT_TOPMODULES_DIR
endef

$(foreach i,$(all_possible_args), \
    $(eval $(DEFINE_PARAMETERISED_TOP_RECIPES)) \
)

.PRECIOUS: %.$(IVERILOG_DEPS_EXT) %.$(FILE_DEPS_EXT) %.$(MAKE_DEPS_EXT) %.$(SV2V_DEPS_EXT)
-include $(MAKE_DEPS)

%.$(MAKE_DEPS_EXT): %.$(FILE_DEPS_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from_src) ($< -> $@)'; \
	echo "$(@:%.$(DEPS_EXT)=%.$(OBJ_EXT)) $@ : $$(cat '$<')" > '$@';

%.$(FILE_DEPS_EXT): %.$(IVERILOG_DEPS_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from_src) ($< -> $@)'; \
	cat '$<' | sed -E 's/^[IM] (.+)$$/\1/' | sort | uniq | paste -sd' ' - > '$@';

%.$(SV2V_DEPS_EXT): %.$(FILE_DEPS_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from_src) ($< -> $@)'; \
	cp '$<' '$@';

%.$(OBJ_EXT): %.$(ARGS_EXT) %.$(SV2V_DEPS_EXT)
	@set -e; \
	echo '[SV2V    ] $(call top_module_name_from,$(lastword $<)) ($< -> $@)'; \
	$(SV2V) $(SV2V_ALL_FLAGS) \
		$$(cat '$(firstword $<)' | sed -E '$(SED_REGEX_EXTRACT_DEFINES)') \
		--top '$(call top_module_name_from,$(lastword $<))' \
		$$(cat '$(lastword $<)') > $@;






# thrash out the call hierarchy that the testbenches recipe needs; build X.log from X.*.deps (run vvp for each), build X.N.deps from each line in X.args (iverilog -Mprefix), build X.N.vvp from X.N.v, build X.N.v from X.N.deps (sv2v)

$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).log: $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT) $(wildcard $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).*.log)
	@set -e; \
	mkdir -p '$(dir $@)'; \
	cat $($(filter %.log,$<):%='%') > '$@'; \
	# TODO: grep for ^\[TB FAIL ] in $@ and abort Makefile if found

$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT): $(wildcard $(SRC_DIR)/%.$(TB_EXT).$(ARGS_EXT))
	@set -e; \
	if [ -f '$<' ]; then \
		mkdir -p '$(dir $@)'; \
		seq $$(wc -l < '$<') | xargs -I ^ '$(BASH)' -c "head -n ^ '$<' | tail -n 1 > '$(@:%.$(ARGS_EXT)=%.^.$(ARGS_EXT))'"; \
		seq $$(wc -l < '$<') | xargs -I ^ echo "$@ : $(@:%.$(TB_EXT).$(ARGS_EXT)=%.$(TB_EXT).^.log)" > '$@'; \
	else \
		echo "TODO: NEED TO WRITE SOMETHING TO HANDLE WHEN THERE IS NO .tb.args" && exit 1; \
	fi

-include $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT)

$(OUT_TESTBENCHES_DIR)/%.log : $(OUT_TESTBENCHES_DIR)/%.$(OBJ_VVP_EXT)
	# TODO: top_module_name_from_src is not what we want here...
	@set -e; \
	echo '[TB RUN  ] Running $(top_module_name_from_src) ($< -> $@)'; \
	($(VVP) $(VVP_TB_FLAGS) '$<' 2>&1 | tee '$@') || echo "[TB FAIL ] Exit code $?, see $@ for details";

%.$(OBJ_VVP_EXT) : %.$(OBJ_EXT) %.$(ARGS_EXT)
	echo "TODO: run iverilog here, using '$(firstword $<)' for source and '$(lastword $<)' for arguments, with -o '$@'";
