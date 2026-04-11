# Experiments in Verilog - A PIC-like CPU

## What is this ?
An exploration of FPGA workflows and tooling - Verilog, SystemVerilog, Yosys, Nextpnr, Icestorm and Icarus Verilog.  The aim is for a simple setup; SpinalHDL is great but there's a lot of abstraction and complexity and I want to strip it back to something simpler that still allows automated testing, verification and synthesis.

## Prerequisites
Required packages for building, testing and verification:
- `abc` - synthesis tool for mapping
- `bash` - BASH
- `gmake` - GNU Make
- `icestorm` - utilities for working with iCE40 FPGAs and bitstreams
- `iverilog` - Verilog simulator
- `nextpnr` - synthesis tool for placing and routing
- `yosys` - various front-end tools for formal verification and synthesis

## Conventions
The build infrastructure in this repository works off some conventions:
- Filenames and `module`s are treated as case-sensitive and must match
- The directory of the file being compiled, along with parent directories, are automatically added to the simulator's / synthesiser's include and library paths so other `module`s at the same level in the hierarchy are automatically discoverable (ie. no `include` is necessary)
- The `module`s and files must only reference `modules` and files in the same directory, a parent directory or a sibling directory, but not in sub-directories; this keeps the dependency arrows all pointing in the same direction and allows Inversion of Control; only the Composition Root can break this rule as all dependencies must be known at synthesis time
- In the case of synthesis, the Composition Root is the top-level `module`; for simulation it is a Testbench or Formal Verification Proof
- Top-Level Modules:
  - Have a file extension of `.top.sv`; `.v` is used for `sv2v` pre-processed output
  - Must have a constraints file named `{BASENAME}.pcf`
- Testbenches:
  - Live side-by-side with the `module` under test
  - Have a file named the same as the `module` under test, with an extension of `.tb.sv`
  - Have a `module` named `{BASENAME}Testbench` which is the top-level
- Formal Verification Proofs:
  - Live side-by-side with the `module` under test
  - Have a file named the same as the `module` under test, with an extension of `.fv.sv`
  - Have a `module` named `{BASENAME}FormalVerification` which is the top-level
- SystemVerilog / Verilog `module`s:
  - Have a file extension of `.sv`; `.v` is used for `sv2v` pre-processed output
  - Have a `module` named `{BASENAME}` to allow them to be automatically discovered by the tooling
- SystemVerilog `interfaces`s:
  - Have a file extension of `.if.sv`
  - Have an `interface` named `{BASENAME}` to allow them to be automatically discovered by the tooling
- SystemVerilog / Verilog header files for `include`s:
  - Have a file extension of `.h.sv`
- Documentation lives side-by-side with the SystemVerilog components and:
  - Has a file with an extension of `.md` for MarkDown
  - Has file(s) with extensions of `.wd` for Wavedrom timing, register and circuit diagrams; these will be transformed to `.svg` for inclusion in Markdown

## Build Status
[![CI](https://github.com/pete-restall/fpga-piclike/actions/workflows/ci.yaml/badge.svg)](https://github.com/pete-restall/fpga-piclike/actions/workflows/ci.yaml)
