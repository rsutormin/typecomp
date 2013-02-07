TOP_DIR = ../..
include $(TOP_DIR)/tools/Makefile.common

DEPLOY_RUNTIME ?= /kb/runtime
TARGET ?= /kb/deployment

SERVICE_NAME = typecomp
SERVICE = $(SERVICE_NAME)

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

deploy: deploy-dir-service deploy-scripts deploy-libs deploy-docs

deploy-docs:
	-mkdir -p doc
	$(DEPLOY_RUNTIME)/bin/pod2html -t "KBase Type Compiler" scripts/compile_typespec.pl > doc/compile_typespec.html
	$(DEPLOY_RUNTIME)/bin/pod2html -t "KBase Java Client Compiler" scripts/gen_java_client.pl > doc/gen_java_client.html
	cp doc/*html $(SERVICE_DIR)/webroot/.

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
