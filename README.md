# Archive of non-dominated points

Creating an archive of all non-dominated points using Fast Incremental BSP Tree. This package provides a Python wrapper for code provided as [a fast incremental BSP archive](https://www.ini.rub.de/PEOPLE/glasmtbl/code/ParetoArchive/index.html).

### COMPILATION

```bash
python setup.py build
python install --user
# or
pip3 install --user git+https://github.com/ehw-fit/py-paretoarchive
pip install --user git+https://github.com/ehw-fit/py-paretoarchive
```

### USAGE

```python
PyBspTreeArchive(objectives=3, minimizeObjective1=True, minimizeObjective2=True, minimizeObjective3=True, minimizeObjective4=True)
```

```python
from paretoarchive import PyBspTreeArchive

a = PyBspTreeArchive(3, minimizeObjective1=False, minimizeObjective2=False, minimizeObjective3=True)
a.process([1,2,3]) 
# True (is non-dominated)
a.process([1,2,3])
# True (is non-dominated)
a.process([1,3,3])
# True (is non-dominated)
a.process([1,1,2])
# True (is non-dominated)
print(a.size()) # get the number of  non-dominates solutions
# 2
print(a.points())  # get the non-dominated solutions
# [[1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]
```

Single-line example:
```python
print(PyBspTreeArchive(2, minimizeObjective1=True, minimizeObjective2=False).filter( 
    [[2,4], [3,1], [2,1], [1,1]], sortKey=lambda itm: itm[0]
    ) #process the array and sort the result by first objective (useful for plotting)
# [[1.0, 1.0], [2.0, 4.0]]
```


Return indexes of the elements:

```python
a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
print(a.process([1,3,3], returnId=True))
# (True, 0) (is non-dominated, received ID 0)
print(a.process([1,2,3], returnId=True))
# (False, 1) (is dominated, received ID 1)
print(a.process([1,1,2], returnId=True))
# (True, 2) (is non-dominated, received ID 2)
print(a.points(returnIds=True))
# [0,2] (item with ID 0 and 2 are non-dominated)
print(a.points())
# [[1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]
```

Custom IDs:

```python
a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
print(a.process([1,2,3], customId=10))
# True
print(a.process([1,3,3], customId=20))
# True
print(a.process([1,1,2], customId=30))
# True
print(a.points(returnIds=True))
# [20,30]
```

Pruning of the set of non-dominated solutions specifying data resolution:

```python
def resample(val, resolution=0.01):
    return round(val / resolution)*resolution


pf = PyBspTreeArchive(4)
for i, x in enumerate(dataset):
   pf.process( ( resample(math.log10(x['wce']),0.001),  #resolution is 0.001
                 resample(x['area'],10), #values can be only multiples of 10
                 resample(x['pwr'],0.1), #resolution is 0.1
                 resample(x['time'],0.1) #resolution is 0.1
               ), customId=i) #customId may be omitted, there is an internal counter initialized to 0
indexes = pf.points(returnIds=True)

print([dataset[i]['wce'] for i in indexes])
```

## Using in Pandas
You can easily use the library to filter a Pandas DataFrame. Note that the selected columns cannot have a "NaN" values (you should use `df.dropna(subset=["c1", "c2"])` function.

```python
from paretoarchive import PyBspTreeArchive
def pandas_pareto(data : pd.DataFrame, columns : list, **kwargs) -> pd.DataFrame:
    filt = list(zip(*[data[c] for c in columns]))
    ids = data.index.tolist()

    sel = [ids[i] for i in PyBspTreeArchive(len(columns), **kwargs).filter(filt, returnIds=True)]
    filt = [i in sel for i in ids]
    return data[filt]
    
# example usage    
par_df = pandas_pareto(df, ["area", "energy", "weight"], minimizeObjective2 = False)
```

### SOURCE

* Tobias Glasmachers: **A Fast Incremental BSP Tree Archive for Non-dominated Points**
  * https://link.springer.com/chapter/10.1007/978-3-319-54157-0_18
  * https://www.ini.rub.de/PEOPLE/glasmtbl/code/ParetoArchive/index.html
* Similar problem (SKYLINE)
  https://github.com/sean-chester/SkyBench

