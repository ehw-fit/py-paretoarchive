# Archive of non-dominated points

Creating an archive of all non-dominated points using Fast Incremental BSP Tree

### COMPILATION

```
> python2.7 setup.py build
> python2.7 install --user
```

### USAGE

PyBspTreeArchive(objectives=3, minimizeObjective1=True, minimizeObjective2=True, minimizeObjective3=True, minimizeObjective4=True)

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
print a.size() # get the number of  non-dominates solutions
# 2
print a.points()  # get the non-dominated solutions
# [[1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]
```

Return indexes of the elements:

```python
a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
print a.process([1,3,3], returnId=True)
# (True, 0) (is non-dominated, received ID 0)
print a.process([1,2,3], returnId=True)
# (False, 1) (is dominated, received ID 1)
print a.process([1,1,2], returnId=True)
# (True, 2) (is non-dominated, received ID 2)
print a.points(returnIds=True)
# [0,2] (item with ID 0 and 2 are non-dominated)
print a.points()
# [[1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]
```

Custom IDs:

```python
a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
print a.process([1,2,3], customId=10)
# True
print a.process([1,3,3], customId=20)
# True
print a.process([1,1,2], customId=30)
# True
print a.points(returnIds=True)
# [20,30]
```


### SOURCE

* **A Fast Incremental BSP Tree Archive for Non-dominated Points**
  https://link.springer.com/chapter/10.1007/978-3-319-54157-0_18
  https://www.ini.rub.de/PEOPLE/glasmtbl/code/ParetoArchive/index.html
* Similar problem (SKYLINE)
  https://github.com/sean-chester/SkyBench

