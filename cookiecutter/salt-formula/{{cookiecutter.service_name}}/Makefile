DESTDIR=/
SALTENVDIR=/usr/share/salt-formulas/env
RECLASSDIR=/usr/share/salt-formulas/reclass
FORMULANAME=$(shell grep name: metadata.yml|head -1|cut -d : -f 2|grep -Eo '[a-z0-9\-\_]*')

MAKE_PID := $(shell echo $$PPID)
JOB_FLAG := $(filter -j%, $(subst -j ,-j,$(shell ps T | grep "^\s*$(MAKE_PID).*$(MAKE)")))

ifneq ($(subst -j,,$(JOB_FLAG)),)
JOBS := $(subst -j,,$(JOB_FLAG))
else
JOBS := 1
endif

KITCHEN_LOCAL_YAML?=.kitchen.yml
KITCHEN_OPTS?="--concurrency=$(JOBS)"
KITCHEN_OPTS_CREATE?=""
KITCHEN_OPTS_CONVERGE?=""
KITCHEN_OPTS_VERIFY?=""
KITCHEN_OPTS_TEST?=""

all:
	@echo "make install - Install into DESTDIR"
	@echo "make test    - Run tests"
	@echo "make kitchen - Run Kitchen CI tests (create, converge, verify)"
	@echo "make clean   - Cleanup after tests run"

install:
	# Formula
	[ -d $(DESTDIR)/$(SALTENVDIR) ] || mkdir -p $(DESTDIR)/$(SALTENVDIR)
	cp -a $(FORMULANAME) $(DESTDIR)/$(SALTENVDIR)/
	[ ! -d _modules ] || cp -a _modules $(DESTDIR)/$(SALTENVDIR)/
	[ ! -d _states ] || cp -a _states $(DESTDIR)/$(SALTENVDIR)/ || true
	# Metadata
	[ -d $(DESTDIR)/$(RECLASSDIR)/service/$(FORMULANAME) ] || mkdir -p $(DESTDIR)/$(RECLASSDIR)/service/$(FORMULANAME)
	cp -a metadata/service/* $(DESTDIR)/$(RECLASSDIR)/service/$(FORMULANAME)

test:
	[ ! -d tests ] || (cd tests; ./run_tests.sh)

kitchen: kitchen-create kitchen-converge kitchen-verify kitchen-list

kitchen-create:
	kitchen create ${KITCHEN_OPTS} ${KITCHEN_OPTS_CREATE}
	[ "$(shell echo $(KITCHEN_LOCAL_YAML)|grep -Eo docker)" = "docker" ] || sleep 120

kitchen-converge:
	kitchen converge ${KITCHEN_OPTS} ${KITCHEN_OPTS_CONVERGE} &&\
	kitchen converge ${KITCHEN_OPTS} ${KITCHEN_OPTS_CONVERGE}

kitchen-verify:
	[ ! -d tests/integration ] || kitchen verify -t tests/integration ${KITCHEN_OPTS} ${KITCHEN_OPTS_VERIFY}
	[ -d tests/integration ]   || kitchen verify ${KITCHEN_OPTS} ${KITCHEN_OPTS_VERIFY}

kitchen-test:
	[ ! -d tests/integration ] || kitchen test -t tests/integration ${KITCHEN_OPTS} ${KITCHEN_OPTS_TEST}
	[ -d tests/integration ]   || kitchen test ${KITCHEN_OPTS} ${KITCHEN_OPTS_TEST}

kitchen-list:
	kitchen list

clean:
	[ ! -x "$(shell which kitchen)" ] || kitchen destroy
	[ ! -d .kitchen ] || rm -rf .kitchen
	[ ! -d tests/build ] || rm -rf tests/build
	[ ! -d build ] || rm -rf build
