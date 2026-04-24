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

ARGS_EXT := args
MAX_ARGS := 16

TB_EXT := tb
FV_EXT := fv
TOP_EXT := top

H_SRC_EXT := h.$(SRC_EXT)
IF_SRC_EXT := if.$(SRC_EXT)
TB_SRC_EXT := $(TB_EXT).$(SRC_EXT)
TB_OBJ_EXT := $(TB_EXT).$(OBJ_EXT)
FV_SRC_EXT := $(FV_EXT).$(SRC_EXT)
FV_OBJ_EXT := $(FV_EXT).$(OBJ_EXT)
TOP_SRC_EXT := $(TOP_EXT).$(SRC_EXT)
TOP_OBJ_EXT := $(TOP_EXT).$(OBJ_EXT)
DOC_MD_SRC_EXT := md
DOC_MD_OBJ_EXT := md
DOC_WAVEDROM_SRC_EXT := wd
DOC_WAVEDROM_OBJ_EXT := svg

IVERILOG_DEPS_EXT := ideps
FILE_DEPS_EXT := fdeps
MAKE_DEPS_EXT := mdeps
SV2V_DEPS_EXT := sdeps

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
src_to_testbench_logs = $(patsubst $(SRC_DIR)/%,$(OUT_TESTBENCHES_DIR)/%,$(1:%.$(SRC_EXT)=%.log))
src_to_verification_logs = $(patsubst $(SRC_DIR)/%,$(OUT_VERIFICATION_DIR)/%,$(1:%.$(SRC_EXT)=%.log))
doc_to_obj = $(patsubst $(SRC_DIR)/%,$(DOC_OBJ_DIR)/%,$(1:%.$(2)=%.$(3)))

TB_SRC := $(call find_src,*.$(TB_SRC_EXT))
TB_LOGS := $(call src_to_testbench_logs,$(TB_SRC))

FV_SRC := $(call find_src,*.$(FV_SRC_EXT))
FV_SBY_OBJ := $(call src_to_obj,$(FV_SRC),$(FV_SRC_EXT),$(OBJ_SBY_EXT))
FV_LOGS := $(call src_to_verification_logs,$(FV_SRC))

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

testbenches: $(TB_LOGS)

proofs: $(FV_LOGS)

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

.PHONY: blah
blah: ################### TODO: REMOVE THIS - TESTING PURPOSES ONLY !
	@echo $(call basename_dot_suffix,some_file.tb.ext)
	@echo $(call top_module_name_from,some_file.tb.ext)
	@echo $(call basename_dot_suffix,some_file.tb.4.ext)
	@echo $(call top_module_name_from,some_file.tb.4.ext)

prefixed_src_dirs_from_src = $(call prefixed_src_dirs_from,$(1),$<)
prefixed_src_dirs_from = $(call prefixed_parent_dirs,$(1),$(SRC_DIR),$(2))
prefixed_parent_dirs = $(shell next_dir(){ d=$$(dirname $$1) && echo -n "$(1)$${d} "; [ "$$?" -eq 0 -a "_$${d}" != '_$(2)' -a "_$${d}" != "_." -a "_$${d}" != "_/" ] && next_dir "$${d}"; } && [ ! -z '$(3)' ] && next_dir '$(3)')

top_module_name_from_src = $(call top_module_name_from,$<)
top_module_name_from = $(notdir \
	$(patsubst %.$(TOP_EXT),%$(TOP_MODULE_SUFFIX), \
	$(patsubst %.$(FV_EXT),%$(FV_MODULE_SUFFIX), \
	$(patsubst %.$(TB_EXT),%$(TB_MODULE_SUFFIX), \
	$(call basename_dot_suffix,$(1))))) \
)

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

define DEFINE_PARAMETERISED_TOP_RECIPES
$(OUT_TESTBENCHES_DIR)/%.$(i).$(IVERILOG_DEPS_EXT): $(SRC_DIR)/%.$(SRC_EXT) $(OUT_TESTBENCHES_DIR)/%.$(i).$(ARGS_EXT)
	@set -e; \
	top_module_name='$$(call top_module_name_from_src)'; \
	args_file='$$(lastword $$^)'; \
	echo "[DEPENDS ] $$$${top_module_name}: Discovering dependencies ($$$${args_file} -> $$@)"; \
	mkdir -p '$$(dir $$@)'; \
	$$(IVERILOG) $$(IVERILOG_DEPS_FLAGS) $$(call prefixed_src_dirs_from_src,-I) $$(call prefixed_src_dirs_from_src,-y) $$$$(cat "$$$${args_file}") -o '$(NULL_FD)' '-Mprefix=$$@' -s "$$$${top_module_name}" '$$<';

# TODO: OUT_VERIFICATION_DIR and OUT_TOPMODULES_DIR

_remove_dot_$(i)_suffix = $$(patsubst %.$(i),%,$$(1))
endef

$(foreach i,$(all_possible_args), \
    $(eval $(DEFINE_PARAMETERISED_TOP_RECIPES)) \
)

basename_dot_suffix = $(call _basename_dot_suffix,$(1),$(all_possible_args))
_basename_dot_suffix = $(let head tail,$(2), \
	$(call _remove_dot_$(head)_suffix, \
		$(if $(tail), \
			$(call _basename_dot_suffix,$(1),$(tail)), \
			$(basename $(1))) \
	) \
)

.PHONY: %.$(IVERILOG_DEPS_EXT)
%.$(IVERILOG_DEPS_EXT):
	@echo '*** No recipe to make $@; do you need to increase MAX_ARGS from $(MAX_ARGS) ?';
	@exit 1;

.PRECIOUS: %.$(MAKE_DEPS_EXT)
%.$(MAKE_DEPS_EXT): %.$(FILE_DEPS_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from_src): Converting dependencies ($< -> $@)'; \
	echo "$(@:%.$(DEPS_EXT)=%.$(OBJ_EXT)) $@ : $$(cat '$<')" > '$@';

.PRECIOUS: %.$(FILE_DEPS_EXT)
%.$(FILE_DEPS_EXT): %.$(IVERILOG_DEPS_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from_src): Converting dependencies ($< -> $@)'; \
	cat '$<' | sed -E 's/^[IM] (.+)$$/\1/' | sort | uniq | paste -sd' ' - > '$@';

.PRECIOUS: %.$(SV2V_DEPS_EXT)
%.$(SV2V_DEPS_EXT): %.$(FILE_DEPS_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from_src): Converting dependencies ($< -> $@)'; \
	cp '$<' '$@';

%.$(OBJ_EXT): %.$(ARGS_EXT) %.$(SV2V_DEPS_EXT)
	@set -e; \
	top_module_name='$(call top_module_name_from_src)'; \
	deps_file='$(lastword $^)'; \
	echo "[SV2V    ] $${top_module_name}: Transpiling ($< -> $@)"; \
	only_defines="$$(cat '$<' | sed -E "s/(-D[^ =]+(=(([^\"' ]*)|('[^']*')|(\"[^\"]*\")))?)/\n\1\n/g" | grep '^-D' | paste -sd' ' -)"; \
	$(SV2V) $(SV2V_ALL_FLAGS) \
		$${only_defines} \
		--top "$${top_module_name}" \
		$$(cat "$${deps_file}") > $@;






# thrash out the call hierarchy that the testbenches recipe needs; build X.log from X.*.deps (run vvp for each), build X.N.deps from each line in X.args (iverilog -Mprefix), build X.N.vvp from X.N.v, build X.N.v from X.N.deps (sv2v)

.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).log
$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).log: $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT) out/testbenches/InstructionDecoder.tb.1.log out/testbenches/InstructionDecoder.tb.2.log
	@echo "ALL INPUTS: $^";
	@set -e; \
	mkdir -p '$(dir $@)'; \
	(cat '$(@:%.log=%.*.log)' > '$@') || echo "TODO: TEMPORARY IGNORE ERROR"; \
	grep '\[TB FAIL \]' '$@' || echo '[TB PASS ] $(call top_module_name_from_src)';

.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT) $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(ARGS_EXT)
$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT): $(SRC_DIR)/%.$(TB_EXT).$(ARGS_EXT) $(SRC_DIR)/%.$(TB_SRC_EXT)
	@set -e; \
	echo "[DEPENDS ] $(call top_module_name_from_src): Creating Testbench Makefile dependencies and arguments ($< -> $@)"; \
	mkdir -p '$(dir $@)'; \
	seq $$(wc -l < $<) | xargs -I ^ '$(BASH)' -c "head -n ^ '$<' | tail -n 1 > '$(@:%.$(MAKE_DEPS_EXT)=%.^.$(ARGS_EXT))'"; \
	seq $$(wc -l < $<) | xargs -I ^ echo "$(@:%.$(MAKE_DEPS_EXT)=%.log) : $(@:%.$(MAKE_DEPS_EXT)=%.^.log)" > '$@'; \
	seq $$(wc -l < $<) | xargs -I ^ echo "$(@:%.$(MAKE_DEPS_EXT)=%.^.$(ARGS_EXT)) : $@" >> '$@';

$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT): $(SRC_DIR)/%.$(TB_SRC_EXT)
	@set -e; \
	echo "[DEPENDS ] $(call top_module_name_from_src): Creating Testbench Makefile dependencies and arguments ($< -> $@)"; \
	mkdir -p '$(dir $@)'; \
	echo "" > '$(@:%.$(MAKE_DEPS_EXT)=%.1.$(ARGS_EXT))'; \
	echo "$(@:%.$(MAKE_DEPS_EXT)=%.log) : $(@:%.$(MAKE_DEPS_EXT)=%.1.log)" > '$@'; \
	echo "$(@:%.$(MAKE_DEPS_EXT)=%.1.$(ARGS_EXT)) : $@" >> '$@';

#-include $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT)

$(OUT_TESTBENCHES_DIR)/%.log : $(OUT_TESTBENCHES_DIR)/%.$(OBJ_VVP_EXT)
	# TODO: top_module_name_from_src is not what we want here...
	@set -e; \
	echo '[TB RUN  ] $(top_module_name_from_src): Running ($< -> $@)'; \
	($(VVP) $(VVP_TB_FLAGS) '$<' 2>&1 | tee '$@') || echo "[TB FAIL ] Exit code $?, see $@ for details";

%.$(OBJ_VVP_EXT) : %.$(OBJ_EXT) %.$(ARGS_EXT)
	echo "TODO: run iverilog here, using '$<' for source and '$(lastword $^)' for arguments, with -o '$@'";
	touch '$@'

-include out/testbenches/InstructionDecoder.tb.mdeps # $(call find_files,$(OUT_OBJ_DIR),*.$(MAKE_DEPS_EXT))
