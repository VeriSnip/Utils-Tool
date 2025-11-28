VSBUILD_ARGS ?= 
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

lint:
	verilator --lint-only --Wall --Wno-fatal --top-module $(PROJECT_NAME) $(VERILOG_SOURCES)
	verible-verilog-lint --rules=-always-comb $(VERILOG_SOURCES)
#	slang -Wall -Werror -top $(PROJECT_NAME) $(VERILOG_SOURCES)

synth_estimate:
	yosys -p "read_verilog $(VERILOG_SOURCES); hierarchy -check -top $(PROJECT_NAME); synth; stat"

vs_build:
	vs_build $(PROJECT_NAME) $(VSBUILD_ARGS)

hardware-clean:
	@vs_build --clean all

.PHONY: lint synth_estimate hardware-build hardware-clean
