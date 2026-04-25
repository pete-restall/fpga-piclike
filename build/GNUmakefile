SRC_DIR := ../src
OUT_DIR := out
OUT_OBJ_DIR := $(OUT_DIR)/obj
OUT_TESTBENCHES_DIR := $(OUT_DIR)/testbenches
OUT_VERIFICATION_DIR := $(OUT_DIR)/verification
OUT_TOP_DIR := $(OUT_DIR)/top
OUT_DOC_DIR := $(OUT_DIR)/doc

SHELL := bash
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

LOG_EXT := log
PASS_EXT := pass
FAIL_EXT := fail

TB_MODULE_SUFFIX := Testbench
FV_MODULE_SUFFIX := Verification
TOP_MODULE_SUFFIX :=

IVERILOG := iverilog
IVERILOG_ALL_FLAGS := -g2012
IVERILOG_DEPS_FLAGS := $(IVERILOG_ALL_FLAGS) -Y.$(SRC_EXT) -Y.$(IF_SRC_EXT) -i
IVERILOG_VVP_FLAGS := $(IVERILOG_ALL_FLAGS)

VVP := vvp
VVP_ALL_FLAGS :=
VVP_TB_FLAGS := $(VVP_ALL_FLAGS)
VVP_TB_EXTFLAGS := -lxt2-speed
VVP_DUMP_EXT := lxt2

SV2V := sv2v
SV2V_ALL_FLAGS := --siloed
SV2V_TB_FLAGS := $(SV2V_ALL_FLAGS)

########

find_src = $(call find_files,$(SRC_DIR),$(1))
find_files = $(shell find '$(1)' -type f -name '$(2)' 2> '$(NULL_FD)')
src_to_obj = $(patsubst $(SRC_DIR)/%,$(OUT_OBJ_DIR)/%,$(1:%.$(2)=%.$(3)))
src_to_testbench_passes = $(patsubst $(SRC_DIR)/%,$(OUT_TESTBENCHES_DIR)/%,$(1:%.$(SRC_EXT)=%.$(PASS_EXT)))
src_to_verification_passes = $(patsubst $(SRC_DIR)/%,$(OUT_VERIFICATION_DIR)/%,$(1:%.$(SRC_EXT)=%.$(PASS_EXT)))
doc_to_obj = $(patsubst $(SRC_DIR)/%,$(DOC_OBJ_DIR)/%,$(1:%.$(2)=%.$(3)))

TB_SRC := $(call find_src,*.$(TB_SRC_EXT))
TB_ALL_PASSED := $(call src_to_testbench_passes,$(TB_SRC))

FV_SRC := $(call find_src,*.$(FV_SRC_EXT))
FV_SBY_OBJ := $(call src_to_obj,$(FV_SRC),$(FV_SRC_EXT),$(OBJ_SBY_EXT))
FV_ALL_PROVED := $(call src_to_verification_passes,$(FV_SRC))

TOP_SRC := $(call find_src,*.$(TOP_SRC_EXT))
TOP_OBJ := $(call src_to_obj,$(TOP_SRC),$(SRC_EXT),$(OBJ_EXT))

MAKE_DEPS := $(call find_files,$(OUT_OBJ_DIR),*.$(MAKE_DEPS_EXT))

DOC_MD_SRC := $(call find_src,*.$(DOC_MD_SRC_EXT))
DOC_MD_OBJ := $(call doc_to_obj,$(DOC_MD_SRC),$(DOC_MD_SRC_EXT),$(DOC_MD_OBJ_EXT))

DOC_WAVEDROM_SRC := $(call find_src,*.$(DOC_WAVEDROM_SRC_EXT))
DOC_WAVEDROM_OBJ := $(call doc_to_obj,$(DOC_WAVEDROM_SRC),$(DOC_WAVEDROM_SRC_EXT),$(DOC_WAVEDROM_OBJ_EXT))

.PHONY: all bits clean help

.DEFAULT: help

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

testbenches: $(TB_ALL_PASSED)
	$(foreach pass,$<, \
		@set -e; \
		[ -f '$(pass)' ] || (echo && echo '*** Not all testbenches passed; fix the failing ones and re-run "make testbenches".' && echo && exit 1); \
	)

proofs: # $(FV_ALL_PROVED)

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
.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%.$(i).$(IVERILOG_DEPS_EXT)
$(OUT_TESTBENCHES_DIR)/%.$(i).$(IVERILOG_DEPS_EXT): $(SRC_DIR)/%.$(SRC_EXT) $(OUT_TESTBENCHES_DIR)/%.$(i).$(ARGS_EXT)
	@set -e; \
	top_module_name='$$(call top_module_name_from_src)'; \
	args_file='$$(lastword $$^)'; \
	echo "[DEPENDS ] $$$${top_module_name}: Discovering dependencies ($$$${args_file} -> $$@)"; \
	mkdir -p '$$(dir $$@)'; \
	$$(IVERILOG) $$(IVERILOG_DEPS_FLAGS) \
		'-D_DUMP_FILENAME=$(NULL_FD)' \
		$$(call prefixed_src_dirs_from_src,-I) \
		$$(call prefixed_src_dirs_from_src,-y) \
		$$$$(cat "$$$${args_file}") \
		-o '$(NULL_FD)' \
		'-Mprefix=$$@' \
		-s "$$$${top_module_name}" \
		'$$<';

# TODO: OUT_VERIFICATION_DIR and OUT_TOPMODULES_DIR

_remove_dot_$(i)_suffix = $$(patsubst %.$(i),%,$$(1))
endef

$(foreach i,$(all_possible_args), \
    $(eval $(DEFINE_PARAMETERISED_TOP_RECIPES)) \
)

basename_dot_suffix = $(call _basename_dot_suffix,$(1),$(all_possible_args))
_basename_dot_suffix = ci_test_$(1)_$(2)
__basename_dot_suffix = $(let head tail,$(2), \
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

.PRECIOUS: %.$(OBJ_EXT)
%.$(OBJ_EXT): %.$(ARGS_EXT) %.$(SV2V_DEPS_EXT)
	@set -e; \
	top_module_name='$(call top_module_name_from_src)'; \
	deps_file='$(lastword $^)'; \
	echo "[SV2V    ] $${top_module_name}: Transpiling ($< -> $@)"; \
	only_defines="$$(cat '$<' | sed -E "s/(-D[^ =]+(=(([^\"' ]*)|('[^']*')|(\"[^\"]*\")))?)/\n\1\n/g" | grep '^-D' | paste -sd' ' -)"; \
	$(SV2V) $(SV2V_ALL_FLAGS) \
		'-D_DUMP_FILENAME=$(notdir $(@:%.$(OBJ_EXT)=%.$(VVP_DUMP_EXT)))' \
		$${only_defines} \
		--top "$${top_module_name}" \
		$$(cat "$${deps_file}") > $@;

.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(PASS_EXT) $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(FAIL_EXT)
$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(PASS_EXT): $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(LOG_EXT)
	@set -e; \
	echo '[LOG SCAN] $(top_module_name_from_src): Scanning logs for testbench results ($< > $@)'; \
	num_failed=$$((0 + $$(ls -l $(<:%.$(LOG_EXT)=%.*.$(FAIL_EXT)) 2> '$(NULL_FD)' | wc -l))); \
	num_passed=$$((0 + $$(ls -l $(<:%.$(LOG_EXT)=%.*.$(PASS_EXT)) 2> '$(NULL_FD)' | wc -l))); \
	if [ -f '$<' -a $${num_failed} -eq 0 ]; then \
		rm -f '$(@:%.$(PASS_EXT)=%.$(FAIL_EXT))' 2> '$(NULL_FD)'; \
		echo "[TB PASS ] $(call top_module_name_from_src): $${num_passed} runs passed, 0 failed"; \
		touch '$@'; \
	else \
		rm -f '$@' 2> '$(NULL_FD)'; \
		echo "[TB FAIL ] $(call top_module_name_from_src): $${num_passed} runs passed, $${num_failed} failed"; \
		touch '$(@:%.$(PASS_EXT)=%.$(FAIL_EXT))'; \
	fi

.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(LOG_EXT)
$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(LOG_EXT): $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT)
	@set -e; \
	echo '[LOG CAT ] $(top_module_name_from_src): Concatenating logs ($(@:%.$(LOG_EXT)=%.*.$(LOG_EXT)) > $@)'; \
	(cat $(@:%.$(LOG_EXT)=%.*.$(LOG_EXT)) > '$@') || rm -rf '$@' 2> '$(NULL_FD)';

.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT) $(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(ARGS_EXT)
$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT): $(SRC_DIR)/%.$(TB_EXT).$(ARGS_EXT) $(SRC_DIR)/%.$(TB_SRC_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from_src): Creating Testbench Makefile dependencies and arguments ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	num_args=$$(wc -l < '$<'); \
	seq $${num_args} | xargs -I ^ '$(SHELL)' -c "head -n ^ '$<' | tail -n 1 > '$(@:%.$(MAKE_DEPS_EXT)=%.^.$(ARGS_EXT))'"; \
	seq $${num_args} | xargs -I ^ echo '$(@:%.$(MAKE_DEPS_EXT)=%.$(PASS_EXT)) : $(@:%.$(MAKE_DEPS_EXT)=%.^.$(PASS_EXT))' > '$@'; \
	seq $${num_args} | xargs -I ^ echo '$(@:%.$(MAKE_DEPS_EXT)=%.^.$(ARGS_EXT)) : $@' >> '$@';

$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT): $(SRC_DIR)/%.$(TB_SRC_EXT)
	@set -e; \
	echo '[DEPENDS ] $(call top_module_name_from_src): Creating Testbench Makefile dependencies and arguments ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	echo '' > '$(@:%.$(MAKE_DEPS_EXT)=%.1.$(ARGS_EXT))'; \
	echo '$(@:%.$(MAKE_DEPS_EXT)=%.$(PASS_EXT)) : $(@:%.$(MAKE_DEPS_EXT)=%.1.$(PASS_EXT))' > '$@'; \
	echo '$(@:%.$(MAKE_DEPS_EXT)=%.1.$(ARGS_EXT)) : $@' >> '$@';

# TODO: a 'make help' or 'make clean' will run the rule to include these, even if we're not building anything; we rely on this behaviour for testbenches, but for everything else it should be a conditional include (but how ?)
include $(patsubst $(SRC_DIR)/%.$(TB_SRC_EXT),$(OUT_TESTBENCHES_DIR)/%.$(TB_EXT).$(MAKE_DEPS_EXT),$(call find_src,*.$(TB_SRC_EXT)))

.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%.$(PASS_EXT) $(OUT_TESTBENCHES_DIR)/%.$(FAIL_EXT)
$(OUT_TESTBENCHES_DIR)/%.$(PASS_EXT): $(OUT_TESTBENCHES_DIR)/%.$(LOG_EXT)
	@set -e; \
	rm -f '$(@:%.$(PASS_EXT)=%.$(FAIL_EXT))' 2> '$(NULL_FD)'; \
	grep '\[TB FAIL \]' '$<' 2>&1 > '$(NULL_FD)' || touch '$@'; \
	[ -f '$@' ] || touch '$(@:%.$(PASS_EXT)=%.$(FAIL_EXT))';

.PRECIOUS: $(OUT_TESTBENCHES_DIR)/%.$(LOG_EXT)
$(OUT_TESTBENCHES_DIR)/%.$(LOG_EXT): $(OUT_TESTBENCHES_DIR)/%.$(OBJ_VVP_EXT)
	@set -e; \
	echo '[SIMULATE] $(top_module_name_from_src): Simulating ($< -> $@)'; \
	absolute_input_file=$$(readlink -f '$<'); \
	pushd '$(dir $@)'; \
	($(VVP) $(VVP_TB_FLAGS) "$${absolute_input_file}" $(VVP_TB_EXTFLAGS) || echo "[TB FAIL ] Exit code $$?, see $@ for details") 2>&1 | tee '$(notdir $@)'; \
	popd;

.PRECIOUS: %.$(OBJ_VVP_EXT)
%.$(OBJ_VVP_EXT): %.$(OBJ_EXT) %.$(ARGS_EXT)
	@set -e; \
	top_module_name='$(call top_module_name_from_src)'; \
	args_file='$(lastword $^)'; \
	echo "[IVERILOG] $${top_module_name}: Compiling simulation ($${args_file} -> $@)"; \
	mkdir -p '$(dir $@)'; \
	$(IVERILOG) $(IVERILOG_VVP_FLAGS) \
		$(call prefixed_src_dirs_from_src,-I) \
		$(call prefixed_src_dirs_from_src,-y) \
		$$(cat "$${args_file}") \
		-o '$@' \
		-s "$${top_module_name}" \
		'$<';
