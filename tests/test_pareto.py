import sys
# sys.path.extend(['build/lib.win32-2.7','build/lib.linux-x86_64-2.7'])
from paretoarchive import *
import multiprocessing as mp
import numpy as np


def test_max_max_3():
    
    pts = np.array([[1, 3, 3], [1, 2, 3], [1, 1, 2]])
    
    dom = np_pareto(*pts.T, minimize=[False, False, True])
    assert (dom == [True, False, True]).all()
    


def test_min_max_3():
    
    pts = np.array([[1, 2, 3], [1, 3, 3], [1, 1, 2]])
    
    dom = np_pareto(*pts.T, minimize=[True, False, True])
    assert (dom == [False, True, True]).all()
    
