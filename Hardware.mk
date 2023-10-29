VTBUILD := $(VTbuild_DIR)/VTbuild.py
VTBUILD_ARGS := 
# Check if variable is defined
ifdef TestBench
    VTBUILD_ARGS += --TestBench $(TestBench)
endif
ifdef Board_Modules
    VTBUILD_ARGS += --Boards "$(Board_Modules)"
endif
ifdef QUIET 
    VTBUILD_ARGS += --quiet
endif
ifdef DEBUG 
    VTBUILD_ARGS += --debug
endif


hardware-build:
	python $(VTBUILD) $(PROJECT_NAME) $(VTBUILD_ARGS)

hardware-clean:
	@python $(VTBUILD) --clean all

.PHONY: hardware-build hardware-clean
