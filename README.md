# Archive of non-dominated points

Creating an archive of all non-dominated points using Fast Incremental BSP Tree

### COMPILATION

```
> python2.7 setup.py build
> python2.7 install --user
```

### USAGE

PyBspTreeArchive(objectives, minimizeObjective1=True, minimizeObjective2=True, minimizeObjective3=True, minimizeObjective4=True)

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


### SOURCE

* **A Fast Incremental BSP Tree Archive for Non-dominated Points**
  https://link.springer.com/chapter/10.1007/978-3-319-54157-0_18
  https://www.ini.rub.de/PEOPLE/glasmtbl/code/ParetoArchive/index.html
* Similar problem (SKYLINE)
  https://github.com/sean-chester/SkyBench

