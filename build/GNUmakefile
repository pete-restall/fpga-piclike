SRC_DIR := ../src
OUT_DIR := out
OUT_OBJ_DIR := $(OUT_DIR)/obj
OUT_DOC_DIR := $(OUT_DIR)/doc

NULL_FD := /dev/null

SRC_EXT := sv
OBJ_EXT := v
SBY_OBJ_EXT := sby

H_SRC_EXT := h.$(SRC_EXT)
IF_SRC_EXT := if.$(SRC_EXT)
TB_SRC_EXT := tb.$(SRC_EXT)
FV_SRC_EXT := fv.$(SRC_EXT)
TOP_SRC_EXT := top.$(SRC_EXT)
TOP_OBJ_EXT := top.$(OBJ_EXT)
DOC_MD_SRC_EXT := md
DOC_MD_OBJ_EXT := md
DOC_WAVEDROM_SRC_EXT := wd
DOC_WAVEDROM_OBJ_EXT := svg
DEPS_EXT := deps

TB_MODULE_SUFFIX := Testbench
FV_MODULE_SUFFIX := Verification
TOP_MODULE_SUFFIX :=

IVERILOG := iverilog
IVERILOG_ALL_FLAGS := -g2012 -Y.$(SRC_EXT) -Y.$(IF_SRC_EXT)
IVERILOG_DEPS_FLAGS := $(IVERILOG_ALL_FLAGS) -i
IVERILOG_SRC_FLAGS := $(IVERILOG_ALL_FLAGS)

SV2V := sv2v
SV2V_ALL_FLAGS := --siloed

########

find_src = $(call find_files,$(SRC_DIR),$(1))
find_files = $(shell find '$(1)' -type f -name '$(2)' 2>$(NULL_FD))
src_to_obj = $(patsubst $(SRC_DIR)/%,$(OUT_OBJ_DIR)/%,$(1:%.$(2)=%.$(3)))
doc_to_obj = $(patsubst $(SRC_DIR)/%,$(DOC_OBJ_DIR)/%,$(1:%.$(2)=%.$(3)))

TB_SRC := $(call find_src,*.$(TB_SRC_EXT))
TB_OBJ := $(call src_to_obj,$(TB_SRC),$(SRC_EXT),$(OBJ_EXT))

FV_SRC := $(call find_src,*.$(FV_SRC_EXT))
FV_OBJ := $(call src_to_obj,$(FV_SRC),$(SRC_EXT),$(SBY_OBJ_EXT))

TOP_SRC := $(call find_src,*.$(TOP_SRC_EXT))
TOP_OBJ := $(call src_to_obj,$(TOP_SRC),$(SRC_EXT),$(OBJ_EXT))

DEPS := $(call find_files,$(OUT_OBJ_DIR),*.$(DEPS_EXT))

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

testbenches: $(TB_OBJ)
	@echo '[TBENCH] TODO: RUN TESTBENCHES FOR $<';

proofs: $(FV_OBJ)
	@echo '[VERIFY] TODO: RUN VERIFICATION FOR $<';

synth: $(TOP_OBJ)
	@echo '[SYNTH ] TODO: RUN SYNTHESIS FOR $<';

pnr:
	@echo '[PNR   ] TODO: RUN PNR';

bits:
	@echo '[BITS  ] TODO: RUN BITSTREAM COMPILER';

docs: $(DOC_MD_OBJ) $(DOC_WAVEDROM_OBJ)
	@echo '[DOCS  ] TODO: RUN mdBook ON $<';

clean:
	@echo '[CLEAN ] Cleaning up';
	rm -rf '$(OUT_DIR)';

prefixed_src_dirs = $(call prefixed_parent_dirs,$(1),$(SRC_DIR),$<)
prefixed_parent_dirs = $(shell next_dir(){ d=$$(dirname $$1) && echo -n "$(1)$${d} "; [ "_$${d}" != '_$(2)' ] && next_dir "$${d}"; } && next_dir '$(3)')
top_module_name_from_src = $(call top_module_name_from,$<)
top_module_name_from = $(basename $(notdir $(patsubst %.$(TOP_SRC_EXT),%$(TOP_MODULE_SUFFIX),$(patsubst %.$(FV_SRC_EXT),%$(FV_MODULE_SUFFIX),$(1:%.$(TB_SRC_EXT)=%$(TB_MODULE_SUFFIX))))))
top_module_name_from_deps = $(call top_module_name_from,$(<:%.$(DEPS_EXT)=%.$(SRC_EXT)))

$(OUT_OBJ_DIR)/%.$(DEPS_EXT): $(SRC_DIR)/%.$(SRC_EXT)
	@set -e; \
	echo '[DEPS  ] $(top_module_name_from_src) ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	$(IVERILOG) $(IVERILOG_DEPS_FLAGS) $(call prefixed_src_dirs,-I) $(call prefixed_src_dirs,-y) -o '$(NULL_FD)' '-Mprefix=$@.iv' -s '$(top_module_name_from_src)' '$<'; \
	echo "$(@:%.$(DEPS_EXT)=%.$(OBJ_EXT)) $@ : $$(cat '$@.iv' | sed -E 's/^[IM] (.+)$$/\1/' | sort | uniq | paste -sd' ' -)" > '$@';

.PRECIOUS: $(OUT_OBJ_DIR)/%.$(DEPS_EXT)
-include $(DEPS)

$(OUT_OBJ_DIR)/%.$(SBY_OBJ_EXT): $(OUT_OBJ_DIR)/%.$(OBJ_EXT)
	@set -e; \
	echo '[SBYGEN] $(top_module_name_from_obj) ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	echo '    TODO: GENERATE THE SBY FILE HERE...'; \
	touch $@;

$(OUT_OBJ_DIR)/%.$(OBJ_EXT): $(OUT_OBJ_DIR)/%.$(DEPS_EXT)
	@set -e; \
	echo '[SV2V  ] $(top_module_name_from_deps) ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	$(SV2V) $(SV2V_ALL_FLAGS) --top '$(top_module_name_from_deps)' $$(cat '$<' | sed -E 's/^[^:]+: //g') > $@;

$(OUT_OBJ_DIR)/%.$(TOP_OBJ_EXT): $(SRC_DIR)/%.$(PCF_EXT)
	@set -e; \
	echo '[CNSTRN] $< -> $@'; \
	cp '$<' '$@';

$(OUT_DOC_DIR)/%.$(DOC_MD_OBJ_EXT): $(SRC_DIR)/%.$(DOC_MD_SRC_EXT)
	@set -e; \
	echo '[DOCSMD] $< -> $@'; \
	mkdir -p '$(dir $@)'; \
	cp '$<' '$@';

$(OUT_DOC_DIR)/%.$(DOC_WAVEDROM_OBJ_EXT).svg: $(SRC_DIR)/%.$(DOC_WAVEDROM_SRC_EXT)
	@set -e; \
	echo '[DOCSWD] $< -> $@'; \
	mkdir -p '$(dir $@)'; \
	wavedrom --input '$<' --indent 4 > '$@';
