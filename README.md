# Archive of non-dominated points
[![PyPI version fury.io](https://badge.fury.io/py/py-paretoarchive.svg)](https://pypi.python.org/pypi/py-paretoarchive/)
[![PyPI license](https://img.shields.io/pypi/l/py-paretoarchive.svg)](https://pypi.python.org/pypi/py-paretoarchive/)
[![PyPI pyversions](https://img.shields.io/pypi/pyversions/py-paretoarchive.svg)](https://pypi.python.org/pypi/py-paretoarchive/)



Previous version (0.21) used to achive of all non-dominated points using Fast Incremental BSP Tree. This package provides a Python wrapper for code provided as [a fast incremental BSP archive](https://www.ini.rub.de/PEOPLE/glasmtbl/code/ParetoArchive/index.html).

In order to not needing to install Cython, the package uses numpy implementation only


#### Instalation from sources
```bash
pip3 install pytest Cython
make install-from-source
pytest
```

The package requires Cython module for its run. When Cython is correctly installed, the package should be platform independent.

### USAGE

```python
obj1 = [1, 2, 3]
obj2 = [3, 2, 1]
from paretoarchive import np_pareto
dom = np_pareto(obj1, obj2, minimize=[False, True])
print(dom) # [True, False, True] (first and third points are non-dominated)
```

## Using in Pandas
You can easily use the library to filter a Pandas DataFrame. Note that the selected columns cannot have a "NaN" values (you should use `df.dropna(subset=["c1", "c2"])` function.

```python
from paretoarchive.pandas import pareto
par_df = pareto(df, ["area", "energy", "weight"], minimize=[False, True, True])
```

### SOURCE

* Tobias Glasmachers: **A Fast Incremental BSP Tree Archive for Non-dominated Points**
  * https://link.springer.com/chapter/10.1007/978-3-319-54157-0_18
  * https://www.ini.rub.de/PEOPLE/glasmtbl/code/ParetoArchive/index.html
* Similar problem (SKYLINE)
  https://github.com/sean-chester/SkyBench

