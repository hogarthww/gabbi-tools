.PHONY: clean-pyc clean-build docs

SHELL=/bin/bash

# Guess which command to use to open files.
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	OPEN_CMD := xdg-open
endif
ifeq ($(UNAME_S),Darwin)
	OPEN_CMD := open
endif


PORT=8080
TEST_PATH=./src/tests/

help:
	@echo ""
	@echo "BUILD"
	@echo ""
	@echo "    clean"
	@echo "        Remove build artifacts and python artifacts."
	@echo "    isort"
	@echo "        Standardise import statements."
	@echo "    docs"
	@echo "        Generate and open sphinx html documentation."
	@echo "    gh-pages"
	@echo "        Generate docs and upload the HTML build to github."
	@echo "    dpkg"
	@echo "        Create a debian package of this service (in a Docker "
	@echo "        container)."
	@echo ""
	@echo "DEV/TEST"
	@echo ""
	@echo "    env"
	@echo "        Make a python virtualenv for developing."
	@echo "    lint"
	@echo "        Check style with flake8-docstrings."
	@echo "    test-fast"
	@echo "        Run py.test without slow tests."
	@echo "    test-all"
	@echo "        Run tox and include integration tests."
	@echo "    test"
	@echo "        Run tox and exclude integration tests."
	@echo "    todo-list"
	@echo "        Generate the TODO.rst file."
	@echo "    authors-list"
	@echo "        Generate the AUTHORS.rst file."
	@echo "    frozen-requirements"
	@echo "        Frozen python package requirements."
	@echo ""
	@echo "RUN"
	@echo ""
	@echo '    run'
	@echo '        Run the `gabbi-tools` service on your local machine.'
	@echo '    run-in-docker'
	@echo '        Build and run the `gabbi-tools` service in a Docker '
	@echo '        container.'
	@echo '    run-in-docker-fast'
	@echo '        Run the `gabbi-tools` service in a Docker container '
	@echo '        (assumes the `gabbi-tools` container has been built).'
	@echo '    kill-running-docker-container'
	@echo '        Kill the docker container running the `gabbi-tools` '
	@echo '        service.'
	@echo ""
	@echo "RELEASE"
	@echo ""
	@echo '    release'
	@echo '        Increment the version by RELEASE_TYPE. Update changelog. Commit and tag change.'


# -----------------------------------------------------------------------------
# BUILD
# -----------------------------------------------------------------------------


clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean: clean-build clean-pyc

isort:
	if [ ! -d .env ]; then \
		$(MAKE) env; \
	fi;
	sh -c ". ./.env/bin/activate; isort --skip-glob=.?* -rc ."

docs:
	if [ ! -d .env ]; then \
		$(MAKE) env; \
	fi;
	if [ -d docs/build ]; then \
		rm -r docs/build; \
	fi;
	git clean -f -- docs/source
	git checkout -- docs/source/technical_details.rst
	sh -c ". ./.env/bin/activate; sphinx-apidoc --separate -o docs/source src"
	sed '1,3d' ./docs/source/modules.rst >> docs/source/technical_details.rst
	sh -c ". ./.env/bin/activate; $(MAKE) -C docs clean"
	sh -c ". ./.env/bin/activate; $(MAKE) -C docs html"
	$(OPEN_CMD) docs/build/html/index.html &
	git clean -f -- docs/source
	git checkout -- docs/source/technical_details.rst

initialize-gh-pages:
	if ! git ls-remote | grep gh-pages > /dev/null 2>&1; then \
		git checkout --orphan gh-pages; \
		git rm --cached -r .; \
		touch .nojekyll; \
		curl -Lkf https://raw.githubusercontent.com/hogarthww/gitignore/master/Gh-Pages.gitignore -o .gitignore; \
		git add .nojekyll .gitignore; \
		git commit --message="Initial Commit"; \
		git clean -df .; \
		git push -u origin gh-pages; \
		git checkout master; \
	fi;

gh-pages: initialize-gh-pages docs
	git checkout gh-pages
	git fetch
	git reset --hard origin/gh-pages
	cp -R ./docs/build/html/* ./
	git add --all .
	git commit -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`"
	git push origin gh-pages
	git checkout -

dpkg-build-env:
	docker build \
		--file=./debian/Dockerfile \
		--tag=hogarth/gabbi-tools-dpkg-$${BUILD_NUMBER:-dev} \
		./

dpkg-qa:
	sudo rm -rf ./dpkg_dist/
	mkdir ./dpkg_dist/
	debchange \
		--newversion $$(python setup.py --version) \
		--urgency low \
		--distribution precise \
			"$$(python setup.py --version) Test Build"
	sudo \
		DH_VIRTUALENV_INSTALL_ROOT=/opt/hogarth/ \
		DESTINATION_DPKG_DIR=./dpkg_dist \
		dpkg-buildpackage -us -uc -b --changes-option=-u./dpkg_dist/
	git checkout -- ./debian/changelog
	sudo git clean -df -- ./debian

dpkg: dpkg-build-env
	if [ ! -d dist ]; then \
		mkdir dist; \
	fi;
	if [ -e ./dist/*.deb ]; then \
		sudo rm ./dist/*.deb; \
	fi;
	docker run \
		--volume=$$(pwd)/dist:/mnt/dist \
		--dns=127.0.1.1 \
		--dns-search=hogarthww.prv \
		--add-host="pypi-zonza.hogarthww.prv:10.9.4.60" \
		--add-host="github.hogarthww.com:5.56.171.90" \
		hogarth/gabbi-tools-dpkg-$${BUILD_NUMBER:-dev}


# -----------------------------------------------------------------------------
# DEV/TEST
# -----------------------------------------------------------------------------


lint:
	if [ ! -d .env ]; then \
		$(MAKE) env; \
	fi;
	sh -c ". ./.env/bin/activate; flake8 --exclude=.*/,__pycache__"

test-fast: clean-pyc
	if [ ! -d .env ]; then \
		$(MAKE) env; \
	fi;
	PYTHONPATH="`pwd`/src" \
	./.env/bin/py.test -vv --color=yes -m 'not integration and not slow' \
	$(TEST_PATH)

test-all: clean-pyc
	if [ ! -d .env ]; then \
		$(MAKE) env; \
	fi;
	# Unfortunately `./.env/bin/tox` does not work
	sh -c ". ./.env/bin/activate; tox"

test: clean-pyc
	if [ ! -d .env ]; then \
		$(MAKE) env; \
	fi;
	# Unfortunately `./.env/bin/tox` does not work
	sh -c ". ./.env/bin/activate; tox \"-m 'not integration'\""


testbed:
	docker pull ubuntu:14.04
	docker run -it -v $(pwd):/testbed ubuntu

todo-list:
	@sed -i'' -e '/todos-cd988ecc-225e-4bd6-befa-97b1590152dd/q' README.rst
	@echo "" >> README.rst
	@echo "::" >> README.rst
	@echo "" >> README.rst
	@echo "    -------------------------------------------------------------------" >> README.rst
	@echo "    GENERATED ON: $$(date)" >> README.rst
	@echo "    -------------------------------------------------------------------" >> README.rst
	@echo "    NUMBER OF FIXMES: $$(ack-grep FIXME src --ignore-dir=gabbi_tools.egg-info -ch)" >> README.rst
	@if [ $$(ack-grep FIXME src --ignore-dir=gabbi_tools.egg-info -ch) != 0 ]; then \
		ack-grep FIXME src --ignore-dir=gabbi_tools.egg-info | sed s/^/'    '/ >> README.rst; \
	fi;
	@echo "    -------------------------------------------------------------------" >> README.rst
	@echo "    NUMBER OF TODOS: $$(ack-grep TODO src --ignore-dir=gabbi_tools.egg-info -ch)" >> README.rst
	@if [ $$(ack-grep TODO src --ignore-dir=gabbi_tools.egg-info -ch) != 0 ]; then \
		ack-grep TODO src --ignore-dir=gabbi_tools.egg-info | sed s/^/'    '/ >> README.rst; \
	fi;
	@echo "    -------------------------------------------------------------------" >> README.rst
	@echo '' >> README.rst

authors-list:
	@sed -i'' -e '/contributors-cd988ecc-225e-4bd6-befa-97b1590152dd/q' AUTHORS.rst
	@echo "" >> AUTHORS.rst
	@echo "::" >> AUTHORS.rst
	@echo "" >> AUTHORS.rst
	@git log --all --format='%aN <%cE>' | sort -uf | sed s/^/'    '/ >> AUTHORS.rst
	@echo '' >> AUTHORS.rst



env:
	rm -rf ./.env/
	virtualenv .env -p $$(which python3.4)
	./.env/bin/pip install --index-url=https://pypi.python.org/simple/ --upgrade pip setuptools wheel
	./.env/bin/pip install flake8-docstrings isort pytest pytest-django pytest-cov tox
	./.env/bin/pip install sphinx sphinx_rtd_theme
	./.env/bin/pip install --trusted-host=pypi-zonza.hogarthww.prv  --index-url=http://pypi-zonza.hogarthww.prv/hogarthww/unstable/+simple/ -e .
	. ./.env/bin/activate

frozen-requirements:
	@echo "# ---------------------------------------------------------------- #" > requirements.txt
	@echo "# DO NOT EDIT THIS FILE MANUALLY. IT IS CONTROLLED BY THE MAKEFILE #" >> requirements.txt
	@echo "# ---------------------------------------------------------------- #" >> requirements.txt
	virtualenv .frozenenv --clear -p $$(which python3.4)
	./.frozenenv/bin/pip install --index-url=https://pypi.python.org/simple/ --upgrade pip setuptools wheel
	./.frozenenv/bin/pip install --trusted-host=pypi-zonza.hogarthww.prv  --index-url=http://pypi-zonza.hogarthww.prv/hogarthww/unstable/+simple/ .[production]
	./.frozenenv/bin/pip freeze | grep -v "$$(python setup.py --name)==" >> requirements.txt
	git --no-pager diff requirements.txt


# -----------------------------------------------------------------------------
# RUN
# -----------------------------------------------------------------------------


run:
	if [ ! -d .env ]; then \
		$(MAKE) env; \
	fi;
	./.env/bin/gabbi-tools

run-in-docker:
	docker build \
		--file=./Dockerfile \
		--tag=hogarth/gabbi-tools ./
	$(MAKE) run-in-docker-fast

kill-running-docker-container:
	exists=$$( docker ps -a -q --filter="name=gabbi-tools" -ch); \
	if [ $$exists -eq 1 ]; then \
		docker kill gabbi-tools; \
		docker rm gabbi-tools; \
	fi;

run-in-docker-fast: kill-running-docker-container
	docker run \
		--detach=false \
		--name=gabbi-tools \
		--publish=$(PORT):8080 \
		hogarth/gabbi-tools

# -----------------------------------------------------------------------------
# RELEASE
# -----------------------------------------------------------------------------


PREVIOUS_VERSION=
VERSION_CMD=python setup.py --version
VERSION=$(shell $(VERSION_CMD))
RELEASE_TYPE=
RELEASETOOLS_DIR=.releasetools

release:
	$(MAKE) increment-version
	$(MAKE) debian-changelog VERSION=$$($(VERSION_CMD)) PREVIOUS_VERSION=$(VERSION)
	$(MAKE) release-commit   VERSION=$$($(VERSION_CMD))

release-commit:
	@git add .
	@git commit -am "RELEASE version $(VERSION)"
	@git tag $(VERSION)
	@git show $(VERSION)
	@echo "+----------------------------------------------------------+"
	@echo "| NOTE: Don't forget to push your release commit and tag!  |"
	@echo "|                                                          |"
	@echo "| e.g. git push && git push --tags                         |"
	@echo "+----------------------------------------------------------+"

increment-version:
	if [ -z $(RELEASE_TYPE) ]; then >&2 echo "ERROR: RELEASE_TYPE is not set. It must be one of: major, minor, patch."; exit 1; fi
	virtualenv $(RELEASETOOLS_DIR) --clear
	./$(RELEASETOOLS_DIR)/bin/pip install --upgrade pip setuptools wheel
	./$(RELEASETOOLS_DIR)/bin/pip install --upgrade bumpversion
	./$(RELEASETOOLS_DIR)/bin/bumpversion --current-version $(VERSION) $(RELEASE_TYPE) setup.py

DEBCHANGE=$(shell which debchange)
TMP_CHANGELOG=./$(RELEASETOOLS_DIR)/changelog.tmp

debian-changelog: debchange-newversion debchange-update

debchange-newversion:
	$(DEBCHANGE) --newversion $(VERSION) --urgency medium --distribution trusty "RELEASE version $(VERSION)"

debchange-update:
	@if [ -z $(PREVIOUS_VERSION) ]; then >&2 echo "ERROR: PREVIOUS_VERSION is not set. Something is wrong with this Makefile..."; exit 1; fi
	@if [ -z $(DEBCHANGE) ]; then >&2 echo "ERROR: DEBCHANGE is not set. Do you have `devscripts` installed?"; exit 1; fi
	@git log --pretty=format:'(%aN) %s' --no-merges $(PREVIOUS_VERSION)..HEAD > $(TMP_CHANGELOG)
	@echo "" >> $(TMP_CHANGELOG)  # NOTE(@chrisdcunha) Extra line break is required.
	@while read -r logentry; do $(DEBCHANGE) --append "$$logentry"; done < $(TMP_CHANGELOG)
	@rm $(TMP_CHANGELOG)
