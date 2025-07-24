VSBUILD_ARGS := 
# Check if variable is defined
ifdef PROJECT_SIM_TOP
    VSBUILD_ARGS += --TestBench $(PROJECT_SIM_TOP)
endif
ifdef FPGA_TOP_MODULES
    VSBUILD_ARGS += --Boards "$(FPGA_TOP_MODULES)"
endif
ifdef QUIET 
    VSBUILD_ARGS += --quiet
endif
ifdef DEBUG 
    VSBUILD_ARGS += --debug
endif


hardware-build:
	vs_build $(PROJECT_NAME) $(VSBUILD_ARGS)

hardware-clean:
	@vs_build --clean all

.PHONY: hardware-build hardware-clean
