from libcpp cimport bool
from libcpp.vector cimport vector

cdef extern from "paretoarchive.h":# namespace "std":
    cdef cppclass ObjVec[OBJ]:
        ObjVec(int id=0)
        double& operator[](unsigned int index)
        int getId()
        void setId(int id)

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
    ctypedef int myInt5 "5"    # a fake type

ctypedef BspTreeArchive[myInt2] BspTreeArchive2

cdef class PyBspTreeArchive2:
  cdef BspTreeArchive2 *_front
  cdef int _sign[2]
  cdef int _id

  def __cinit__(self):
    self._front = new BspTreeArchive2()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 2
    cdef ObjVec[myInt2] data
    cdef int i
    if customId == None:
        customId = self._id
        self._id += 1
    data.setId(customId)
    data[0] = self._sign[0]*item[0]
    data[1] = self._sign[1]*item[1]
    if not returnId:
        return self._front.process(data)
    return (self._front.process(data), customId)

  def clear(self):
    self._id = 0
    self._front.clear()

  def empty(self):
    return self._front.empty()

  def size(self):
    return self._front.size()

  def points(self, bool returnIds=False):
    cdef vector[const ObjVec[myInt2]*] vec
    cdef ObjVec[myInt2] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1]])
    return res

ctypedef BspTreeArchive[myInt3] BspTreeArchive3

cdef class PyBspTreeArchive3:
  cdef BspTreeArchive3 *_front
  cdef int _sign[3]
  cdef int _id

  def __cinit__(self):
    self._front = new BspTreeArchive3()
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._id = 0

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1 #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1 #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1 #1 minimize, -1 maximize

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 3
    cdef ObjVec[myInt3] data
    cdef int i
    if customId == None:
        customId = self._id
        self._id += 1
    data.setId(customId)
    data[0] = self._sign[0]*item[0]
    data[1] = self._sign[1]*item[1]
    data[2] = self._sign[2]*item[2]
    if not returnId:
        return self._front.process(data)
    return (self._front.process(data), customId)

  def clear(self):
    self._id = 0
    self._front.clear()

  def empty(self):
    return self._front.empty()

  def size(self):
    return self._front.size()

  def points(self, bool returnIds=False):
    cdef vector[const ObjVec[myInt3]*] vec
    cdef ObjVec[myInt3] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2]])
    return res

ctypedef BspTreeArchive[myInt4] BspTreeArchive4

cdef class PyBspTreeArchive4:
  cdef BspTreeArchive4 *_front
  cdef int _sign[4]
  cdef int _id

  def __cinit__(self):
    self._front = new BspTreeArchive4()
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._id = 0

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1 #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1 #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1 #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1 #1 minimize, -1 maximize

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 4
    cdef ObjVec[myInt4] data
    cdef int i
    if customId == None:
        customId = self._id
        self._id += 1
    data.setId(customId)
    data[0] = self._sign[0]*item[0]
    data[1] = self._sign[1]*item[1]
    data[2] = self._sign[2]*item[2]
    data[3] = self._sign[3]*item[3]
    if not returnId:
        return self._front.process(data)
    return (self._front.process(data), customId)


  def clear(self):
    self._id = 0
    self._front.clear()

  def empty(self):
    return self._front.empty()

  def size(self):
    return self._front.size()

  def points(self, bool returnIds=False):
    cdef vector[const ObjVec[myInt4]*] vec
    cdef ObjVec[myInt4] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3]])
    return res

ctypedef BspTreeArchive[myInt5] BspTreeArchive5
    

cdef class PyBspTreeArchive5:
  cdef BspTreeArchive5 *_front
  cdef int _sign[5]
  cdef int _id

  def __cinit__(self):
    self._front = new BspTreeArchive5()
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._id = 0

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1 #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1 #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1 #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1 #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1 #1 minimize, -1 maximize

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 5
    cdef ObjVec[myInt5] data
    cdef int i
    if customId == None:
        customId = self._id
        self._id += 1
    data.setId(customId)
    data[0] = self._sign[0]*item[0]
    data[1] = self._sign[1]*item[1]
    data[2] = self._sign[2]*item[2]
    data[3] = self._sign[3]*item[3]
    data[4] = self._sign[4]*item[4]
    if not returnId:
        return self._front.process(data)
    return (self._front.process(data), customId)


  def clear(self):
    self._id = 0
    self._front.clear()

  def empty(self):
    return self._front.empty()

  def size(self):
    return self._front.size()

  def points(self, bool returnIds=False):
    cdef vector[const ObjVec[myInt5]*] vec
    cdef ObjVec[myInt5] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4]])
    return res

class PyBspTreeArchive:
  def __init__(self, objectives=3, minimizeObjective1=True, minimizeObjective2=True, minimizeObjective3=True, minimizeObjective4=True, minimizeObjective5=True):
     if not objectives in [2,3,4,5]:
        raise Exception("Invalid number of objectives. Only 2,3,4 and 5 is supported")
     self._archive = {2:PyBspTreeArchive2, 3:PyBspTreeArchive3, 4:PyBspTreeArchive4, 5:PyBspTreeArchive5}[objectives]()
     self._archive.configure([minimizeObjective1,minimizeObjective2,minimizeObjective3,minimizeObjective4,minimizeObjective5])
     self.process = self._archive.process
     self.empty = self._archive.empty
     self.clear = self._archive.clear
     self.size = self._archive.size
     self.points = self._archive.points

  def filter(self, data, returnIds=False, sortKey=None):
     self.clear()
     for i, d in enumerate(data):
        self.process(d, customId=i)
     pts = self.points(returnIds=returnIds)
     if sortKey == None: 
        return pts
     return sorted(pts, key = sortKey)
