PYTHON = python3
SETUP  := $(PYTHON) setup.py

.PHONY: clean install publish snap test venv

clean:
	$(SETUP) clean
	rm -f .coverage .eggs *.egg-info *.snap *.tar.bz2
	rm -rf .pytest_cache/ .tox/ htmlcov build dist venv
	@find . -regex '.*\(__pycache__\|\.py[co]\)' -delete

install:
	$(SETUP) install

publish:
	rm -rf dist/
	$(SETUP) sdist
	pip install twine
	twine upload dist/*

snap:
	snapcraft cleanbuild

test:
	$(SETUP) check -r -s
	tox

venv:
	$(PYTHON) -m virtualenv -p /usr/bin/$(PYTHON) venv
	venv/bin/pip install -Ur requirements.txt -Ur requirements-test.txt
	@echo "Now run the following to activate the virtual env:"
	@echo ". venv/bin/activate"
