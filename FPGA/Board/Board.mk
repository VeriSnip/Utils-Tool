BOARD_DIR ?= $(FPGA_DIR)/Board
BOARD ?= IceSugar-pro
PROGRAMMING_MODE ?= sram

ifeq ($(PROGRAMMING_MODE), sram)
OPENFPGALOADER_FLAGS = -m
else
OPENFPGALOADER_FLAGS = -f
endif

board-programming: $(PROJECT_NAME).bit
	openFPGALoader $(OPENFPGALOADER_FLAGS) -c cmsisdap --vid=0x1d50 --pid=0x602b $^

board-run: board-programming
	@echo "Not implemented yet."

board-clean:
	-rm ${PROJECT_NAME}.svf $(PROJECT_NAME).bit $(PROJECT_NAME).json $(PROJECT_NAME)_pnr.config

.PHONY: board-programming board-run board-clean
