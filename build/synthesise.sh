#!/usr/bin/env bash
set -e;

SRC_DIR="../../src";
TOPLEVEL_DIR="${SRC_DIR}/toplevel/icesugar";

mkdir -p out/synthesis;
cd out/synthesis;

# TODO: Icarus can spit out BLIF, and yosys can read BLIF; this would be more consistent, but does it work...?  Try it...
yosys -p "synth_ice40 -top IceSugar -json piclike.json" \
	"${TOPLEVEL_DIR}/IceSugar.sv" \
	"${SRC_DIR}/InstructionDecoder.sv" \
	"${SRC_DIR}/Instructions.sv";

nextpnr-ice40 \
	--up5k \
	--package sg48 \
	--json piclike.json \
	--pcf "${TOPLEVEL_DIR}/icesugar.pcf" \
	--asc piclike.asc;

icepack piclike.asc piclike.bin;
