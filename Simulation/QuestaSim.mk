QUESTASIM_LICENSE ?= $(HOME)/intelFPGA_lite/LR-127519_License.dat
QUESTASIM_SOURCES := $(VERILOG_SOURCES) $(SIMULATION_SOURCES)
QUESTASIM_FLAGS := -quiet +incdir+$(PROJECT_TESTBENCH_DIR) +incdir+$(PROJECT_RTL_DIR)
ifeq ($(VCD),1)
    QUESTASIM_FLAGS += +define+VCD
endif

ifdef TestBench
    PROJECT_SIM_TOP := $(TestBench)
else
    PROJECT_SIM_TOP := $(PROJECT_NAME)_tb
endif

sim-run: export LM_LICENSE_FILE=$(QUESTASIM_LICENSE)
sim-run: sim-clean
	vlog $(QUESTASIM_FLAGS) $(QUESTASIM_SOURCES)
	vsim -voptargs="+acc" -c $(PROJECT_SIM_TOP) -do "run -all"

sim-clean:
	-rm -f transcript *.vcd *.wlf
	-rm -rf work

.PHONY: sim-run sim-clean