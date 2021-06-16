import sys
# sys.path.extend(['build/lib.win32-2.7','build/lib.linux-x86_64-2.7'])
from paretoarchive import *
import multiprocessing as mp
import numpy as np


def test_max_max_3():
    a = PyBspTreeArchive(3, minimizeObjective1=False, minimizeObjective2=False)
    print(a.process([1, 2, 3]))
    print(a.process([1, 3, 3]))
    print(a.process([1, 1, 2]))
    print(a.points())
    print(a.size())
    assert a.points() == [[1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]


def test_min_max_3():
    a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
    print(a.process([1, 2, 3], customId=10))
    print(a.process([1, 3, 3], customId=20))
    print(a.process([1, 1, 2], customId=30))
    print(a.points(returnIds=True))
    print(a.points())
    assert a.points() == [[1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]
    assert a.points(returnIds=True) == [20, 30]


def test_min_max_3v2():
    a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
    print(a.process([1, 3, 3], returnId=True))
    print(a.process([1, 2, 3], returnId=True))
    print(a.process([1, 1, 2], returnId=True))
    print(a.points(returnIds=True))
    assert a.points(returnIds=True) == [0, 2]


def test_min_max_3_sort():
    a = PyBspTreeArchive(3, minimizeObjective1=True, minimizeObjective2=False)
    print(a.filter([[1, 3, 3], [1, 2, 3], [1, 1, 2]]))
    assert a.filter([[1, 3, 3], [1, 2, 3], [1, 1, 2]]) == [
        [1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]

    assert a.filter([[1, 3, 3], [1, 2, 3], [1, 1, 2]], sortKey=lambda itm: itm[0]) == [
        [1.0, 3.0, 3.0], [1.0, 1.0, 2.0]]  # sort the result by first objective
    assert a.filter([[1, 3, 3], [1, 2, 3], [1, 1, 2]], sortKey=lambda itm: itm[1]) == [
        [1.0, 1.0, 2.0], [1.0, 3.0, 3.0]]  # sort the result by second objective
    assert a.filter([[1, 3, 3], [1, 2, 3], [1, 1, 2]], sortKey=lambda itm: (
        itm[0], itm[1])) == [[1.0, 1.0, 2.0], [1.0, 3.0, 3.0]]
    assert a.filter([[1, 3, 3], [1, 2, 3], [1, 1, 2]], sortKey=lambda itm: itm[2]) == [
        [1.0, 1.0, 2.0], [1.0, 3.0, 3.0]]

    a = PyBspTreeArchive(2, minimizeObjective1=True, minimizeObjective2=False)
    assert a.filter([[2, 4], [3, 1], [2, 1], [1, 1]], sortKey=lambda itm: itm[0]) == [[1.0, 1.0], [
        2.0, 4.0]]  # process the array and sort the result by first objective (useful for plotting)


# def test_no_raise():
#     # related to issue #1
#     objectives = 2
#     datasets = 3
#     points = 10
#     pareto = PyBspTreeArchive(objectives=objectives)
# 
#     def feed(data):
#         pareto.clear()
#         for d in data:
#             pareto.process(d)
#         print(pareto.points())
# 
#     main_pool = mp.Pool(processes=2)
#     data = np.random.random((datasets, points, objectives))
#     main_pool.map(feed, data)
