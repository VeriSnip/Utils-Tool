BOARD_DIR ?= $(CURDIR)
BOARD ?= IceSugar_pro

# Supported Boards are those that have a .mk file under this directory
INCLUDE_FILE := $(BOARD_DIR)/$(BOARD).mk

board-connect:
	picocom -b 115200 /dev/ttyACM0
	@echo "Not implemented yet."

ifeq ($(wildcard $(INCLUDE_FILE)),)
    $(error $(INCLUDE_FILE) does not exist. Please make sure it is available.)
else
    include $(INCLUDE_FILE)
endif