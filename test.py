import sys
sys.path.extend(['build/lib.win32-2.7','build/lib.linux-x86_64-2.7'])
from paretoarchive import *


a = PyBspTreeArchive(3, minimizeObjective1=False, minimizeObjective2=False)
print a.process([1,2,3])
print a.process([1,3,3])
print a.process([1,1,2])
print a.points()
print a.size()
