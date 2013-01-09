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


deploy-service: deploy
deploy-client: deploy

deploy: deploy-scripts deploy-libs deploy-docs

deploy-docs:
	# need to add docs and move them to the deployment directory

bin: $(BIN_PERL)

# test targets
test: test-client test-scripts test-service
test-client:
	@echo "client tests not defined"
test-scripts:
	@echo "script tests not defined"
test-service:
	@echo "service tests not defined"


include $(TOP_DIR)/tools/Makefile.common.rules
