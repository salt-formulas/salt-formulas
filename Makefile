help:
	@echo "submodules    Get submodules"
	@echo "update        Checkout master, get submodules and pull all formulas"
	@echo "release       Make new major release of all formulas"
	@echo "mrconfig      Re-generate .mrconfig with all formulas on Github"
	@echo "html          Build html documentation"
	@echo "pdf           Build pdf documentation"

FORMULAS=`for i in {1..5}; do curl -s "https://api.github.com/orgs/salt-formulas/repos?page=$$i&per_page=100" |grep -E 'clone_url.*salt-formula-' | sed 's/.*salt-formula-\([-_[:alnum:]]*\).git.*/\1/'; done| xargs -n1 | sort -u `;

pull:
	git pull --rebase

list_formulas:
	@echo $(FORMULAS)

sync_submodules:
	@mkdir -p formulas;
	@for formula in $(FORMULAS) do\
		if [ ! -e formulas/$$formula ]; then\
			echo "## Adding submodule: $$formula";\
			git submodule add -b master https://github.com/salt-formulas/salt-formula-$$formula.git formulas/$$formula ;\
		fi;\
	done

sync_forks:
	@mkdir -p formulas.fork
	@for formula in $(FORMULAS) do\
		echo "## Forking: $$formula";\
		test -e formulas.fork/$$formula || git clone https://github.com/salt-formulas/salt-formula-$$formula.git formulas.fork/$$formula;\
		if [ -n "$$GH_USERNAME" ]; then\
			cd formulas.fork/$$formula >/dev/null;\
			if ! git remote | grep "$$GH_USERNAME" > /dev/null; then\
				echo "## Adding remote: $$GH_USERNAME (git://github.com/$$GH_USERNAME/salt-formula-$$formula)";\
				git remote add $$GH_USERNAME git://github.com/$$GH_USERNAME/salt-formula-$$formula;\
			fi;\
			cd - >/dev/null;\
		fi;\
	done;

submodules: pull
	git submodule init
	git submodule update

update: submodules
	(for formula in formulas/*; do FORMULA=`basename $$formula` && cd $$formula && git remote set-url --push origin git@github.com:salt-formulas/salt-formula-$$FORMULA.git && cd ../..; done)
	mr --trust-all -j4 run git checkout master
	mr --trust-all -j4 update

sync: sync_submodules sync_forks

release:
	mr --trust-all -j4 run make release-major

mrconfig:
	./scripts/update_mrconfig.py

html:
	make -C doc html

pdf:
	make -C doc latexpdf
