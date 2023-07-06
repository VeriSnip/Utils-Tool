SIMULATOR:=QuestaSim
PROJECT_NAME:=mycpu
PROJECT_PATH:=../..
PROJECT_HW_PATH:=$(PROJECT_PATH)/Hardware
PROJECT_HW_RTL_PATH:=$(PROJECT_HW_PATH)/RTL
PROJECT_HW_Testbench_PATH:=$(PROJECT_HW_PATH)/Testbench

sim-run:
	vlib $(PROJECT_NAME)
	vlog -quiet -work $(PROJECT_NAME) $(PROJECT_HW_RTL_PATH)/mycpu.v $(PROJECT_HW_Testbench_PATH)/mycpu_tb.v
	vsim -c $(PROJECT_NAME).$(PROJECT_NAME)_tb -do "run -all"