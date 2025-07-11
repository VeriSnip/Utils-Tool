IVERILOG_OUTPUT_DIR ?= $(PROJECT_DIR)/$(SIMULATOR)
IVERILOG_OUTPUT := $(IVERILOG_OUTPUT_DIR)/a.out
IVERILOG_SOURCES := $(VERILOG_SOURCES) $(SIMULATION_SOURCES)
IVERILOG_FLAGS := -W all -g2012 -I$(PROJECT_TESTBENCH_DIR) -I$(PROJECT_RTL_DIR)
ifeq ($(VCD),1)
    IVERILOG_FLAGS += -DVCD
endif

# Rule to create the directory if it doesn't exist
$(IVERILOG_OUTPUT_DIR):
	@mkdir -p $(IVERILOG_OUTPUT_DIR)

sim-run: $(IVERILOG_OUTPUT_DIR)
	iverilog -o $(IVERILOG_OUTPUT) $(IVERILOG_FLAGS) $(IVERILOG_SOURCES) 
	$(IVERILOG_OUTPUT)

sim-clean:
	@echo "Cleaning $(SIMULATOR) Makefile generated files."
	-@rm -rf $(IVERILOG_OUTPUT_DIR)
	-@rm -f *.vcd

.PHONY: sim-run sim-clean