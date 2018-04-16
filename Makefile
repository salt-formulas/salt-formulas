help:
	@echo "submodules    Get submodules"
	@echo "update        Checkout master, get submodules and pull all formulas"
	@echo "release       Make new major release of all formulas"
	@echo "mrconfig      Re-generate .mrconfig with all formulas on Github"
	@echo "html          Build html documentation"
	@echo "pdf           Build pdf documentation"
	@echo "remote_gerrit Add git remote gerrit"
	@echo "remote_github Add git remote github"

pull:
	git pull --rebase

submodules: pull
	git submodule init
	git submodule update

update: submodules
	# TODO: safe set-url push origin on update target
	#(for formula in formulas/*; do FORMULA=`basename $$formula` && cd $$formula && git remote set-url --push origin git@github.com:salt-formulas/salt-formula-$$FORMULA.git && cd ../..; done)
	mr --trust-all -j4 run git checkout master
	mr --trust-all -j4 update

release:
	mr --trust-all -j4 run make release-major

mrconfig:
	./scripts/update_mrconfig.py

muconfig:
	mu group add salt-formulas --empty
	mu register $(FORKED_FORMULAS_DIR)/*

html:
	make -C doc html

pdf:
	make -C doc latexpdf

FORKED_FORMULAS_DIR=formulas
FORMULAS=`$(pipenv --py) -c 'import sys; sys.path.append("scripts");from update_mrconfig import *; print(*get_org_repos(make_github_agent(), "salt-formulas"), sep="\n")'| egrep 'salt-formula-' | sed 's/salt-formula-//'`

set_push:
	(for formula in $${FORMULAS_DIR:-$(FORKED_FORMULAS_DIR)}/*; do FORMULA=`basename $$formula` && cd $$formula && git remote set-url --push origin git@github.com:salt-formulas/salt-formula-$$FORMULA.git && cd ../..; done)

scripts_prerequisites:
	@if ! which pipenv; then echo "Please install pipenv first";  exit 2; fi
	pipenv --three install

list: scripts_prerequisites
	@echo $(FORMULAS)

update_forks: scripts_prerequisites
	@mkdir -p $(FORKED_FORMULAS_DIR)
	@for FORMULA in $(FORMULAS) ; do\
     test -e $(FORKED_FORMULAS_DIR)/$$FORMULA || git clone  https://github.com/salt-formulas/salt-formula-$$FORMULA.git $(FORKED_FORMULAS_DIR)/$$FORMULA;\
   done;


GERRIT_REMOTE_URI=gerrit.mcp.mirantis.net:29418/salt-formulas
remote_gerrit: FORMULAS_DIR=$(FORKED_FORMULAS_DIR)
remote_gerrit: remote_gerrit_add

remote_gerrit_add:
	@#(for formula in $(FORMULAS_DIR)/*; do FORMULA=`basename $$formula` && cd $$formula && git remote remove gerrit || true && cd ../.. ; done)
	@mkdir -p $(FORMULAS_DIR)
	@ID=$${GERRIT_USERNAME:-$$USER};\
   for FORMULA in `ls $(FORMULAS_DIR)/`; do\
     cd $(FORMULAS_DIR)/$$FORMULA > /dev/null;\
     if ! git remote | grep gerrit 2>&1 > /dev/null ; then\
       git remote add gerrit ssh://$$ID@$(GERRIT_REMOTE_URI)/$$FORMULA;\
     fi;\
     cd - > /dev/null;\
     done;

remote_github: FORMULAS_DIR=$(FORKED_FORMULAS_DIR)
remote_github: remote_github_add

remote_github_add:
	@mkdir -p $(FORMULAS_DIR)
	@ID=$${GITHUB_USERNAME:-$$USER};\
   for FORMULA in `ls $(FORMULAS_DIR)/`; do\
     cd $(FORMULAS_DIR)/$$FORMULA > /dev/null;\
     if ! git remote | grep $$ID 2>&1 > /dev/null ; then\
       git remote add $$ID git://github.com/$$ID/salt-formula-$$FORMULA;\
     fi;\
     cd - > /dev/null;\
     done;


install:
	@SALT_ENV=$${SALT_ENV:-/usr/share/salt-formulas/env}
	@mkdir -p $(SALT_ENV)/_formulas
	for FORMULA in `ls $(FORMULAS_DIR)/`; do\
		cp -fva $$FORMULA $$SALT_ENV/_formulas/$$FORMULA;
	done;
	# TODO, what should be linked now?

