FPGA_DIR ?= $(CURDIR)
BOARD_DIR ?= $(FPGA_DIR)/Board
FPGA ?= ecp5

# fpga-synthesis
$(PROJECT_NAME).json:
	yosys -p "synth_$(FPGA) -top $(PROJECT_NAME) -json $@" $(VERILOG_SOURCES)

# fpga-place_and_route
$(PROJECT_NAME)_pnr.config: $(PROJECT_NAME).json
	nextpnr-ecp5 --25k --package CABGA256 --speed 6 --json $< --textcfg $@ --lpf $(PROJECT_NAME).lpf --freq 65

# fpga-bitstream
$(PROJECT_NAME).bit: $(PROJECT_NAME)_pnr.config
	ecppack --svf ${PROJECT_NAME}.svf $< $@

include $(BOARD_DIR)/Board.mk
