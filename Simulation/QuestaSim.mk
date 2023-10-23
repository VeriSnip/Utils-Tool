LICENSE_FILE=/home/pantunes/intelFPGA_lite/LR-127519_License.dat

sim-run:
	export LM_LICENSE_FILE=$(LICENSE_FILE)
	vlib $(PROJECT_NAME)
	vlog -quiet -work $(PROJECT_NAME) $(VERILOG_SOURCES)
	vsim -c $(PROJECT_NAME).$(PROJECT_NAME)_tb -do "run -all"
