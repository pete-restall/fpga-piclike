SRC_DIR := ../src
OUT_DIR := out
OUT_OBJ_DIR := $(OUT_DIR)/obj
OUT_DOC_DIR := $(OUT_DIR)/doc

NULL_FD := /dev/null

SRC_EXT := sv
OBJ_EXT := v

SRC_H_EXT := h.$(SRC_EXT)
SRC_IF_EXT := if.$(SRC_EXT)
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
IVERILOG_ALL_FLAGS := -g2012 -Y.$(SRC_EXT) -Y.$(SRC_IF_EXT)
IVERILOG_DEPS_FLAGS := $(IVERILOG_ALL_FLAGS) -i
IVERILOG_SRC_FLAGS := $(IVERILOG_ALL_FLAGS)

SV2V := sv2v
SV2V_ALL_FLAGS :=

TB_SRC := $(shell find '$(SRC_DIR)' -type f -name '*.$(TB_SRC_EXT)')
TB_OBJ := $(patsubst $(SRC_DIR)/%,$(OUT_OBJ_DIR)/%,$(TB_SRC:%.$(SRC_EXT)=%.$(OBJ_EXT)))

FV_SRC := $(shell find '$(SRC_DIR)' -type f -name '*.$(FV_SRC_EXT)')
FV_OBJ := $(patsubst $(SRC_DIR)/%,$(OUT_OBJ_DIR)/%,$(FV_SRC:%.$(SRC_EXT)=%.$(OBJ_EXT)))

TOP_SRC := $(shell find '$(SRC_DIR)' -type f -name '*.$(TOP_SRC_EXT)')
TOP_OBJ := $(patsubst $(SRC_DIR)/%,$(OUT_OBJ_DIR)/%,$(TOP_SRC:%.$(SRC_EXT)=%.$(OBJ_EXT)))

DEPS := $(shell find '$(OUT_OBJ_DIR)' -type f -name '*.$(DEPS_EXT)' 2>$(NULL_FD))

DOC_MD_SRC := $(shell find '$(SRC_DIR)' -type f -name '*.$(DOC_MD_SRC_EXT)')
DOC_MD_OBJ := $(patsubst $(SRC_DIR)/%,$(DOC_OBJ_DIR)/%,$(DOC_MD_SRC:%.$(DOC_MD_SRC_EXT)=%.$(DOC_MD_OBJ_EXT)))

DOC_WAVEDROM_SRC := $(shell find '$(SRC_DIR)' -type f -name '*.$(DOC_WAVEDROM_SRC_EXT)')
DOC_WAVEDROM_OBJ := $(patsubst $(SRC_DIR)/%,$(DOC_OBJ_DIR)/%,$(DOC_WAVEDROM_SRC:%.$(DOC_WAVEDROM_SRC_EXT)=%.$(DOC_WAVEDROM_OBJ_EXT)))

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
module_name = $(basename $(notdir $(patsubst %.$(TOP_SRC_EXT),%$(TOP_MODULE_SUFFIX),$(patsubst %.$(FV_SRC_EXT),%$(FV_MODULE_SUFFIX),$(<:%.$(TB_SRC_EXT)=%$(TB_MODULE_SUFFIX))))))

$(OUT_OBJ_DIR)/%.$(DEPS_EXT): $(SRC_DIR)/%.$(SRC_EXT)
	@set -e; \
	echo '[DEPS  ]: $(module_name) ($< -> $@)'; \
	mkdir -p '$(dir $@)'; \
	$(IVERILOG) $(IVERILOG_DEPS_FLAGS) $(call prefixed_src_dirs,-I) $(call prefixed_src_dirs,-y) -o '$(NULL_FD)' '-Mprefix=$@.iv' -s '$(module_name)' '$<'; \
	echo "$(@:%.$(DEPS_EXT)=%.$(OBJ_EXT)) $@ : $$(cat '$@.iv' | sed -E 's/^[IM] (.+)$$/\1/' | sort | uniq | paste -sd' ' -)" > '$@';

.PRECIOUS: $(OUT_OBJ_DIR)/%.$(DEPS_EXT)
-include $(DEPS)

$(OUT_OBJ_DIR)/%.$(OBJ_EXT): $(OUT_OBJ_DIR)/%.$(DEPS_EXT)
	@set -e; \
	mkdir -p '$(dir $@)'; \
	echo 'TODO: RUN sv2v TO CREATE ONE BIG VERILOG95 FILE $< -> $@'; \
	touch '$@';

$(OUT_OBJ_DIR)/%.$(TOP_OBJ_EXT): $(SRC_DIR)/%.$(PCF_EXT)
	@set -e; \
	echo '[CNSTRN]: $< -> $@'; \
	cp '$<' '$@';

$(OUT_DOC_DIR)/%.$(DOC_MD_OBJ_EXT): $(SRC_DIR)/%.$(DOC_MD_SRC_EXT)
	@set -e; \
	echo '[DOCSMD]: $< -> $@'; \
	mkdir -p '$(dir $@)'; \
	cp '$<' '$@';

$(OUT_DOC_DIR)/%.$(DOC_WAVEDROM_OBJ_EXT).svg: $(SRC_DIR)/%.$(DOC_WAVEDROM_SRC_EXT)
	@set -e; \
	echo '[DOCSWD]: $< -> $@'; \
	mkdir -p '$(dir $@)'; \
	wavedrom --input '$<' --indent 4 > '$@';
