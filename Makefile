
.PHONY: build dist redist install install-from-source clean uninstall

default: install-from-source

src/paretoarchive/core.pyx:
	python gensrc.py

src/paretoarchive/core.cpp: src/paretoarchive/core.pyx


build: src/paretoarchive/core.cpp
	CYTHONIZE=1 ./setup.py build

dist: src/paretoarchive/core.cpp
	CYTHONIZE=1 ./setup.py sdist bdist_wheel

redist: clean dist

install: src/paretoarchive/core.cpp
	CYTHONIZE=1 pip install .

install-from-source: dist
	pip install --force-reinstall `ls dist/*.tar.gz | sort | tail -1`

clean:
	$(RM) -r build dist src/*.egg-info
	$(RM) -r src/paretoarchive/core.pyx
	$(RM) -r src/paretoarchive/core.cpp
	$(RM) -r .pytest_cache
	find . -name __pycache__ -exec rm -r {} +
	#git clean -fdX

uninstall:
	pip uninstall cython-package-example