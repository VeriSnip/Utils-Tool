VTBUILD := $(VTbuild_DIR)/vt_build.py
VTBUILD_ARGS := 
# Check if variable is defined
ifdef PROJECT_SIM_TOP
    VTBUILD_ARGS += --TestBench $(PROJECT_SIM_TOP)
endif
ifdef FPGA_TOP_MODULES
    VTBUILD_ARGS += --Boards "$(FPGA_TOP_MODULES)"
endif
ifdef QUIET 
    VTBUILD_ARGS += --quiet
endif
ifdef DEBUG 
    VTBUILD_ARGS += --debug
endif


hardware-build:
	python3 $(VTBUILD) $(PROJECT_NAME) $(VTBUILD_ARGS)

hardware-clean:
	@python3 $(VTBUILD) --clean all

.PHONY: hardware-build hardware-clean
