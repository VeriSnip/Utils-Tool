SIMULATION_DIR ?= $(CURDIR)
SIMULATOR ?= IVerilog

PROJECT_TESTBENCH_DIR ?= $(PROJECT_BUILD_DIR)/TestBench
SIMULATION_SOURCES := $(wildcard $(PROJECT_TESTBENCH_DIR)/*)

# Supported Simulators are those that have a .mk file under this directory
INCLUDE_FILE = $(SIMULATION_DIR)/$(SIMULATOR).mk

ifeq ($(wildcard $(INCLUDE_FILE)),)
    $(error $(INCLUDE_FILE) does not exist. Please make sure it is available.)
else
    include $(INCLUDE_FILE)
endif