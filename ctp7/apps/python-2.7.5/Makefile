ifndef PETA_STAGE
$(error "Error: PETA_STAGE environment variable not set.  Change to the root of your PetaLinux install, and source the settings.sh file")
endif

include ../apps.common.mk


# Source should be tar.bz2 type because extrace command is hard coded
#SOURCE_DIR = $(basename $(basename $(SOURCE)))
SOURCE_DIR = ./src/

TARGET_APP = $(SOURCE_DIR)/final/bin/python
HOST_APP = $(SOURCE_DIR)/hostpython

all: build install

build: $(TARGET_APP)

# Host Python compilation
# depends on extracted sources
# use env -i to remove all the environment variable PetaLinux set
# only use the very pure PATH env to generate host Python
$(HOST_APP): $(SOURCE_DIR)
	@echo "Compiling Python for host PC"
	cp hostpython.mk $(SOURCE_DIR)/hostpython.mk
	cd $(SOURCE_DIR); env -i PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make -f hostpython.mk 



# Cross Compile python for ARM
$(TARGET_APP): $(HOST_APP) $(PATCH)
	@echo "Cross-compiling Python for target platform"
	cp targetpython.mk $(SOURCE_DIR)/targetpython.mk
	cd $(SOURCE_DIR); make -f targetpython.mk

clean:
	-rm -rf $(SOURCE_DIR)

.PHONY: build install clean help all

install: 
	$(TARGETINST) -d $(SOURCE_DIR)/_install/bin/ /usr/local/bin/
	$(TARGETINST) -d $(SOURCE_DIR)/_install/include /usr/local/include
	$(TARGETINST) -d $(SOURCE_DIR)/_install/lib/ /usr/local/lib/

help:
	@echo ""
	@echo "Quick reference for various supported build targets for $(INSTANCE)."
	@echo "----------------------------------------------------"
	@echo "  clean                  clean out build objects"
	@echo "  all                    build $(INSTANCE) and install to rootfs host copy"
	@echo "  build                  build subsystem"
	@echo "  install                install built objects to rootfs host copy"

# The compilation process is referred to these sites:
# - http://randomsplat.com/id5-cross-compiling-python-for-embedded-linux.html
# - http://www.csce.uark.edu/~yfrancku/cross-python.html
