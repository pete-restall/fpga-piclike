# Experiments in Verilog - A PIC-like CPU

## What is this ?
An exploration of FPGA workflows and tooling - Verilog, SystemVerilog, Yosys, Nextpnr, Icestorm and Icarus Verilog.  The aim is for a simple setup; SpinalHDL is great but there's a lot of abstraction and complexity and I want to strip it back to something simpler that still allows automated testing, verification and synthesis.

## Prerequisites
Required packages for building, testing and verification:
- `abc` - synthesis tool for mapping
- `icestorm` - utilities for working with iCE40 FPGAs and bitstreams
- `iverilog` - Verilog simulator
- `nextpnr` - synthesis tool for placing and routing
- `yosys` - various front-end tools for formal verification and synthesis

## Build Status
[![CI](https://github.com/pete-restall/fpga-piclike/actions/workflows/ci.yaml/badge.svg)](https://github.com/pete-restall/fpga-piclike/actions/workflows/ci.yaml)
