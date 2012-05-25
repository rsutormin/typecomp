TOP_DIR = ../..
include $(TOP_DIR)/tools/Makefile.common

SRC_PERL = $(wildcard scripts/*.pl)
BIN_PERL = $(addprefix $(BIN_DIR)/,$(basename $(notdir $(SRC_PERL))))

LDEST = lib/Bio/KBase/KIDL

all: $(LDEST)/typedoc.pm $(LDEST)/erdoc.pm bin

$(LDEST)/typedoc.pm: typedoc.yp
	yapp -o $(LDEST)/typedoc.pm typedoc.yp

$(LDEST)/erdoc.pm: erdoc.yp
	yapp -o $(LDEST)/erdoc.pm erdoc.yp

what:
	@echo $(BIN_PERL)

deploy: deploy-scripts deploy-libs

deploy-scripts:
	export KB_TOP=$(TARGET); \
	export KB_RUNTIME=$(DEPLOY_RUNTIME); \
	export KB_PERL_PATH=$(TARGET)/lib bash ; \
	for src in $(SRC_PERL) ; do \
		basefile=`basename $$src`; \
		base=`basename $$src .pl`; \
		echo install $$src $$base ; \
		cp $$src $(TARGET)/plbin ; \
		bash $(TOOLS_DIR)/wrap_perl.sh "$(TARGET)/plbin/$$basefile" $(TARGET)/bin/$$base ; \
	done 

deploy-libs:
	rsync -arv lib/. $(TARGET)/lib/.


bin: $(BIN_PERL)

$(BIN_DIR)/%: scripts/%.pl 
	$(TOOLS_DIR)/wrap_perl '$$KB_TOP/modules/$(CURRENT_DIR)/$<' $@
