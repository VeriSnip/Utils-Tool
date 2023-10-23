SIMULATION_DIR ?= $(CURDIR)
SIMULATOR ?= IVerilog

PROJECT_TESTBENCH_DIR ?= $(PROJECT_BUILD_DIR)/TestBench
VERILOG_SOURCES += $(wildcard $(PROJECT_TESTBENCH_DIR)/*)

ifeq ($(SIMULATOR),IVerilog)
    INCLUDE_FILE = $(SIMULATION_DIR)/IVerilog.mk
else ifeq ($(SIMULATOR),QuestaSim)
    INCLUDE_FILE = $(SIMULATION_DIR)/QuestaSim.mk
else
    $(error Invalid SIMULATOR value. Use "IVerilog" or "QuestaSim")
endif

include $(INCLUDE_FILE)
