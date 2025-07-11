FPGA ?= max10
PROJECT_FPGA_TOP ?= $(PROJECT_NAME)_$(FPGA)
PROJECT_FPGA_DIR ?= $(PROJECT_RTL_DIR)/$(FPGA)

# Use find to search for the file recursively
PROJECT_TCL ?= $(firstword $(wildcard $(shell find $(CURDIR) -type f -name $(PROJECT_NAME)_$(BOARD).tcl)))
PROJECT_SDC ?= $(firstword $(wildcard $(shell find $(CURDIR) -type f -name $(PROJECT_NAME)_$(BOARD).sdc)))
SINTAX_CHECK_TCL := $(BOARD_DIR)/Quartus/check_sintax.tcl

FPGA_SOURCES := $(wildcard $(PROJECT_FPGA_DIR)/*) $(VERILOG_SOURCES)

OUTPUT_FPGA_DIR ?= $(PROJECT_DIR)/fpga_build/$(BOARD)
PROJECT_SOF := $(OUTPUT_FPGA_DIR)/$(PROJECT_NAME).sof
PROJECT_POF := $(OUTPUT_FPGA_DIR)/$(PROJECT_NAME).pof

PROGRAMMING_MODE ?= sram
ifeq ($(PROGRAMMING_MODE), sram)
OPENFPGALOADER_FLAGS = -m
else
OPENFPGALOADER_FLAGS = -f
endif

# fpga-bitstream
$(PROJECT_SOF): 
	quartus_sh -t $(PROJECT_TCL) $(PROJECT_NAME) "$(FPGA_SOURCES)" $(PROJECT_FPGA_TOP) $(PROJECT_SDC) $(OUTPUT_FPGA_DIR)
	quartus_sh --flow compile $(PROJECT_NAME)
	quartus_cpf  --option=bitstream_compression=off -c $(PROJECT_NAME).sof $(PROJECT_NAME).rbf

board-programming: $(PROJECT_SOF)
	quartus_pgm -m jtag -c 1 -o "p;$(PROJECT_POF)"
#	openFPGALoader $(OPENFPGALOADER_FLAGS) -b de10lite $^

board-clean:
	@echo "Cleaning $(BOARD) Makefile generated files."
	-@rm -rf $(OUTPUT_FPGA_DIR)
	-@rm -rf work
	-@rm -rf incremental_db
	-@rm -rf db
	-@rm -f myuart.*

.PHONY: board-programming board-clean
