import sys
sys.path.extend(['build/lib.win32-2.7','build/lib.linux-x86_64-2.7'])
from paretoarchive import *


a = PyBspTreeArchive(3, minimizeObjective1=False, minimizeObjective2=False)
print(a.process([1,2,3]))
print(a.process([1,3,3]))
print(a.process([1,1,2]))
print(a.points())
print(a.size())
assert a.points() == [[1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]

a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
print(a.process([1,2,3], customId=10))
print(a.process([1,3,3], customId=20))
print(a.process([1,1,2], customId=30))
print(a.points(returnIds=True))
print(a.points())
assert a.points() == [[1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]
assert a.points(returnIds=True) == [20, 30]


a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
print(a.process([1,3,3], returnId=True))
print(a.process([1,2,3], returnId=True))
print(a.process([1,1,2], returnId=True))
print(a.points(returnIds=True))
assert a.points(returnIds=True) == [0, 2]



a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
print(a.filter([[1,3,3],[1,2,3], [1,1,2]]))

print(a.filter([[1,3,3],[1,2,3], [1,1,2]], sortKey=lambda itm:itm[0])) #sort the result by first objective
print(a.filter([[1,3,3],[1,2,3], [1,1,2]], sortKey=lambda itm:itm[1])) #sort the result by second objective
print(a.filter([[1,3,3],[1,2,3], [1,1,2]], sortKey=lambda itm:(itm[0],itm[1])))
print(a.filter([[1,3,3],[1,2,3], [1,1,2]], sortKey=lambda itm:itm[2]))


a = PyBspTreeArchive(2, minimizeObjective1=True, minimizeObjective2=False)
print(a.filter( [[2,4], [3,1], [2,1], [1,1]], sortKey=lambda itm: itm[0])) #process the array and sort the result by first objective (useful for plotting)

