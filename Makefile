help:
	@echo "submodules    Get submodules"
	@echo "update        Checkout master and pull all formulas"
	@echo "mrconfig      Re-generate .mrconfig with all formulas on Github"
	@echo "html          Build html documentation"
	@echo "pdf           Build pdf documentation"

submodules:
	git submodule init
	git submodule update

update:
	mr --trust-all -j4 run git checkout master
	mr --trust-all -j4 update

mrconfig:
	./scripts/update_mrconfig.py

html:
	make -C doc html

pdf:
	make -C doc latexpdf
