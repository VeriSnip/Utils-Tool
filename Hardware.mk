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
	vt_build $(PROJECT_NAME) $(VTBUILD_ARGS)

hardware-clean:
	@vt_build --clean all

.PHONY: hardware-build hardware-clean
