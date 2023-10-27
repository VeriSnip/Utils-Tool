VTBUILD := $(VTbuild_DIR)/VTbuild.py

# Check if variable is defined
ifdef TestBench
    TESTBENCH_ARG := --TestBench $(TestBench)
endif
ifdef Supported_Boards
    BOARD_ARG := --Boards "$(Supported_Boards)"
endif

hardware-build:
	python $(VTBUILD) $(PROJECT_NAME) $(TESTBENCH_ARG) $(BOARD_ARG)

hardware-clean:
	@python $(VTBUILD) --clean all

.PHONY: hardware-build hardware-clean
