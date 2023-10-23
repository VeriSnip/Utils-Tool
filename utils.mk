MyUtils_DIR ?= $(CURDIR)
SIMULATION_DIR ?= $(MyUtils_DIR)/Simulation
FPGA_DIR ?= $(MyUtils_DIR)/FPGA

PROJECT_DIR ?= $(CURDIR)
PROJECT_BUILD_DIR ?= $(PROJECT_DIR)/build
PROJECT_RTL_DIR ?= $(PROJECT_BUILD_DIR)/RTL

VERILOG_SOURCES := $(wildcard $(PROJECT_RTL_DIR)/*)

nix:
	nix-shell $(MyUtils_DIR)/shell.nix

include $(SIMULATION_DIR)/Simulation.mk
include $(FPGA_DIR)/FPGA.mk