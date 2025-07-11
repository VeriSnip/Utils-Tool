FPGA ?= ecp5
PROJECT_FPGA_TOP ?= $(PROJECT_NAME)_$(FPGA)
PROJECT_FPGA_DIR ?= $(PROJECT_RTL_DIR)/$(FPGA)

# Use find to search for the file recursively
PROJECT_LPF ?= $(wildcard $(shell find $(CURDIR) -type f -name $(PROJECT_NAME)_$(BOARD).lpf))
PROJECT_LPF := $(firstword $(PROJECT_LPF))

FPGA_SOURCES := $(wildcard $(PROJECT_FPGA_DIR)/*) $(VERILOG_SOURCES)

OUTPUT_FPGA_DIR ?= $(PROJECT_DIR)/fpga_build/$(BOARD)
PROJECT_JSON := $(OUTPUT_FPGA_DIR)/$(PROJECT_NAME).json
PROJECT_PNR := $(OUTPUT_FPGA_DIR)/$(PROJECT_NAME)_pnr.config
PROJECT_BIT := $(OUTPUT_FPGA_DIR)/$(PROJECT_NAME).bit
PROJECT_SVF := $(OUTPUT_FPGA_DIR)/$(PROJECT_NAME).svf

PROGRAMMING_MODE ?= sram
ifeq ($(PROGRAMMING_MODE), sram)
OPENFPGALOADER_FLAGS = -m
else
OPENFPGALOADER_FLAGS = -f
endif

# Rule to create the directory if it doesn't exist
$(OUTPUT_FPGA_DIR):
	@mkdir -p $(OUTPUT_FPGA_DIR)

# fpga-synthesis
$(PROJECT_JSON): $(OUTPUT_FPGA_DIR)
	yosys -p "synth_ecp5 -top $(PROJECT_FPGA_TOP) -json $@" $(FPGA_SOURCES)

# fpga-place_and_route
$(PROJECT_PNR): $(PROJECT_JSON)
	nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json $< --textcfg $@ --lpf $(PROJECT_LPF) --freq 25

# fpga-bitstream
$(PROJECT_BIT): $(PROJECT_PNR)
	ecppack --svf ${PROJECT_SVF} $< $@

board-programming: $(PROJECT_BIT)
	openFPGALoader $(OPENFPGALOADER_FLAGS) -c cmsisdap --vid=0x1d50 --pid=0x602b $^

board-clean:
	@echo "Cleaning $(BOARD) Makefile generated files."
	-@rm -rf $(OUTPUT_FPGA_DIR)

.PHONY: board-programming board-clean
