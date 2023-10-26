MyUtils_DIR ?= $(CURDIR)
SIMULATION_DIR ?= $(MyUtils_DIR)/Simulation
BOARD_DIR ?= $(MyUtils_DIR)/Board

PROJECT_DIR ?= $(CURDIR)
PROJECT_BUILD_DIR ?= $(PROJECT_DIR)/build
PROJECT_RTL_DIR ?= $(PROJECT_BUILD_DIR)/RTL

VERILOG_SOURCES := $(wildcard $(PROJECT_RTL_DIR)/*)

nix:
	nix-shell $(MyUtils_DIR)/shell.nix

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  build          to create a directory with the built rtl code."

hardware-build:
	python $(VTbuild_DIR)/VTbuild.py $(PROJECT_NAME)

hardware-clean:
	python $(VTbuild_DIR)/VTbuild.py --clean all

clean-all: board-clean hardware-clean

.PHONY: help clean-all hardware-build hardware-clean

include $(SIMULATION_DIR)/Simulation.mk
include $(BOARD_DIR)/Board.mk