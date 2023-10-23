FPGA_DIR ?= $(CURDIR)
BOARD_DIR ?= $(FPGA_DIR)/Board
FPGA ?= ecp5

fpga-synthesis:
	yosys -p "synth_$(FPGA) -top $(PROJECT_NAME) -json $(PROJECT_NAME).json" $(VERILOG_SOURCES)

fpga-pnr: fpga-synthesis
	@echo "Not implemented yet."

fpga-bitstream: fpga-pnr
	@echo "Not implemented yet."

include $(BOARD_DIR)/Board.mk
