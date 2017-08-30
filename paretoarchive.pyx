from libcpp cimport bool
from libcpp.vector cimport vector

cdef extern from "paretoarchive.h":# namespace "std":
    cdef cppclass ObjVec[OBJ]:
        ObjVec()
        double& operator[](unsigned int index)

    ctypedef void* objvecty "ObjVec[2]*"

    cdef cppclass BspTreeArchive[OBJ]:
        BspTreeArchive() 
        bool process(ObjVec[OBJ] y)
        bool empty()
        unsigned int size()
        unsigned int treedepth()
        void clear()

        vector[const ObjVec[OBJ]*] points()

cdef extern from *:
    ctypedef int myInt2 "2"    # a fake type
    ctypedef int myInt3 "3"    # a fake type
    ctypedef int myInt4 "4"    # a fake type

ctypedef BspTreeArchive[myInt2] BspTreeArchive2

cdef class PyBspTreeArchive2:
  cdef BspTreeArchive2 *_front
  cdef int _sign[2]

  def __cinit__(self):
    self._front = new BspTreeArchive2()
    self._sign[0] = 1
    self._sign[1] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item):
    assert len(item) == 2
    cdef ObjVec[myInt2] data
    cdef int i
    data[0] = self._sign[0]*item[0]
    data[1] = self._sign[1]*item[1]
    return self._front.process(data)

  def empty(self):
    return self._front.empty()

  def size(self):
    return self._front.size()

  def points(self):
    cdef vector[const ObjVec[myInt2]*] vec
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        res.append([self._sign[0]*val[0][0], self._sign[1]*val[0][1]])
    return res

ctypedef BspTreeArchive[myInt3] BspTreeArchive3

cdef class PyBspTreeArchive3:
  cdef BspTreeArchive3 *_front
  cdef int _sign[3]

  def __cinit__(self):
    self._front = new BspTreeArchive3()
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1 #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1 #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1 #1 minimize, -1 maximize

  def process(self, item):
    assert len(item) == 3
    cdef ObjVec[myInt3] data
    cdef int i
    data[0] = self._sign[0]*item[0]
    data[1] = self._sign[1]*item[1]
    data[2] = self._sign[2]*item[2]
    return self._front.process(data)

  def empty(self):
    return self._front.empty()

  def size(self):
    return self._front.size()

  def points(self):
    cdef vector[const ObjVec[myInt3]*] vec
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        res.append([self._sign[0]*val[0][0],self._sign[1]*val[0][1],self._sign[2]*val[0][2]])
    return res

ctypedef BspTreeArchive[myInt4] BspTreeArchive4

cdef class PyBspTreeArchive4:
  cdef BspTreeArchive4 *_front
  cdef int _sign[4]

  def __cinit__(self):
    self._front = new BspTreeArchive4()
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1 #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1 #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1 #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1 #1 minimize, -1 maximize

  def process(self, item):
    assert len(item) == 4
    cdef ObjVec[myInt4] data
    cdef int i
    data[0] = self._sign[0]*item[0]
    data[1] = self._sign[1]*item[1]
    data[2] = self._sign[2]*item[2]
    data[3] = self._sign[3]*item[3]
    return self._front.process(data)

  def empty(self):
    return self._front.empty()

  def size(self):
    return self._front.size()

  def points(self):
    cdef vector[const ObjVec[myInt4]*] vec
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        res.append([self._sign[0]*val[0][0],self._sign[1]*val[0][1],self._sign[2]*val[0][2],self._sign[3]*val[0][3]])
    return res

class PyBspTreeArchive:
  def __init__(self, objectives, minimizeObjective1=True, minimizeObjective2=True, minimizeObjective3=True, minimizeObjective4=True):
     assert objectives in [2,3,4]
     self._archive = {2:PyBspTreeArchive2, 3:PyBspTreeArchive3, 4:PyBspTreeArchive4}[objectives]()
     self._archive.configure([minimizeObjective1,minimizeObjective2,minimizeObjective3,minimizeObjective4])
     self.process = self._archive.process
     self.empty = self._archive.empty
     self.size = self._archive.size
     self.points = self._archive.points
