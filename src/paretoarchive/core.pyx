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


MAXOBJ = 15

cdef extern from *:
    ctypedef int myInt1 "1"    # a fake type
    ctypedef int myInt2 "2"    # a fake type
    ctypedef int myInt3 "3"    # a fake type
    ctypedef int myInt4 "4"    # a fake type
    ctypedef int myInt5 "5"    # a fake type
    ctypedef int myInt6 "6"    # a fake type
    ctypedef int myInt7 "7"    # a fake type
    ctypedef int myInt8 "8"    # a fake type
    ctypedef int myInt9 "9"    # a fake type
    ctypedef int myInt10 "10"    # a fake type
    ctypedef int myInt11 "11"    # a fake type
    ctypedef int myInt12 "12"    # a fake type
    ctypedef int myInt13 "13"    # a fake type
    ctypedef int myInt14 "14"    # a fake type
    ctypedef int myInt15 "15"    # a fake type

ctypedef BspTreeArchive[myInt1] BspTreeArchive1

cdef class PyBspTreeArchive1:
  cdef BspTreeArchive1 *_front
  cdef int _sign[1]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive1, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive1()
    self._id = 0
    self._sign[0] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 1
    cdef ObjVec[myInt1] data
    cdef int i
    if customId == None:
        customId = self._id
        self._id += 1
    data.setId(customId)
    data[0] = self._sign[0]*item[0]
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
    cdef vector[const ObjVec[myInt1]*] vec
    cdef ObjVec[myInt1] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0]])
    return res


ctypedef BspTreeArchive[myInt2] BspTreeArchive2

cdef class PyBspTreeArchive2:
  cdef BspTreeArchive2 *_front
  cdef int _sign[2]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive2, (self._id, self._sign))

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

  def __reduce__(self):
    return (PyBspTreeArchive3, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive3()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

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

  def __reduce__(self):
    return (PyBspTreeArchive4, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive4()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

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

  def __reduce__(self):
    return (PyBspTreeArchive5, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive5()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

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


ctypedef BspTreeArchive[myInt6] BspTreeArchive6

cdef class PyBspTreeArchive6:
  cdef BspTreeArchive6 *_front
  cdef int _sign[6]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive6, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive6()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 6
    cdef ObjVec[myInt6] data
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
    data[5] = self._sign[5]*item[5]
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
    cdef vector[const ObjVec[myInt6]*] vec
    cdef ObjVec[myInt6] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5]])
    return res


ctypedef BspTreeArchive[myInt7] BspTreeArchive7

cdef class PyBspTreeArchive7:
  cdef BspTreeArchive7 *_front
  cdef int _sign[7]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive7, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive7()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 7
    cdef ObjVec[myInt7] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
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
    cdef vector[const ObjVec[myInt7]*] vec
    cdef ObjVec[myInt7] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6]])
    return res


ctypedef BspTreeArchive[myInt8] BspTreeArchive8

cdef class PyBspTreeArchive8:
  cdef BspTreeArchive8 *_front
  cdef int _sign[8]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive8, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive8()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1
    self._sign[7] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize
    self._sign[7] = 1 if config[7] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 8
    cdef ObjVec[myInt8] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
    data[7] = self._sign[7]*item[7]
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
    cdef vector[const ObjVec[myInt8]*] vec
    cdef ObjVec[myInt8] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6],self._sign[7]*veci[7]])
    return res


ctypedef BspTreeArchive[myInt9] BspTreeArchive9

cdef class PyBspTreeArchive9:
  cdef BspTreeArchive9 *_front
  cdef int _sign[9]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive9, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive9()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1
    self._sign[7] = 1
    self._sign[8] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize
    self._sign[7] = 1 if config[7] else -1  #1 minimize, -1 maximize
    self._sign[8] = 1 if config[8] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 9
    cdef ObjVec[myInt9] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
    data[7] = self._sign[7]*item[7]
    data[8] = self._sign[8]*item[8]
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
    cdef vector[const ObjVec[myInt9]*] vec
    cdef ObjVec[myInt9] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6],self._sign[7]*veci[7],self._sign[8]*veci[8]])
    return res


ctypedef BspTreeArchive[myInt10] BspTreeArchive10

cdef class PyBspTreeArchive10:
  cdef BspTreeArchive10 *_front
  cdef int _sign[10]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive10, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive10()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1
    self._sign[7] = 1
    self._sign[8] = 1
    self._sign[9] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize
    self._sign[7] = 1 if config[7] else -1  #1 minimize, -1 maximize
    self._sign[8] = 1 if config[8] else -1  #1 minimize, -1 maximize
    self._sign[9] = 1 if config[9] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 10
    cdef ObjVec[myInt10] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
    data[7] = self._sign[7]*item[7]
    data[8] = self._sign[8]*item[8]
    data[9] = self._sign[9]*item[9]
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
    cdef vector[const ObjVec[myInt10]*] vec
    cdef ObjVec[myInt10] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6],self._sign[7]*veci[7],self._sign[8]*veci[8],self._sign[9]*veci[9]])
    return res


ctypedef BspTreeArchive[myInt11] BspTreeArchive11

cdef class PyBspTreeArchive11:
  cdef BspTreeArchive11 *_front
  cdef int _sign[11]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive11, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive11()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1
    self._sign[7] = 1
    self._sign[8] = 1
    self._sign[9] = 1
    self._sign[10] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize
    self._sign[7] = 1 if config[7] else -1  #1 minimize, -1 maximize
    self._sign[8] = 1 if config[8] else -1  #1 minimize, -1 maximize
    self._sign[9] = 1 if config[9] else -1  #1 minimize, -1 maximize
    self._sign[10] = 1 if config[10] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 11
    cdef ObjVec[myInt11] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
    data[7] = self._sign[7]*item[7]
    data[8] = self._sign[8]*item[8]
    data[9] = self._sign[9]*item[9]
    data[10] = self._sign[10]*item[10]
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
    cdef vector[const ObjVec[myInt11]*] vec
    cdef ObjVec[myInt11] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6],self._sign[7]*veci[7],self._sign[8]*veci[8],self._sign[9]*veci[9],self._sign[10]*veci[10]])
    return res


ctypedef BspTreeArchive[myInt12] BspTreeArchive12

cdef class PyBspTreeArchive12:
  cdef BspTreeArchive12 *_front
  cdef int _sign[12]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive12, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive12()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1
    self._sign[7] = 1
    self._sign[8] = 1
    self._sign[9] = 1
    self._sign[10] = 1
    self._sign[11] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize
    self._sign[7] = 1 if config[7] else -1  #1 minimize, -1 maximize
    self._sign[8] = 1 if config[8] else -1  #1 minimize, -1 maximize
    self._sign[9] = 1 if config[9] else -1  #1 minimize, -1 maximize
    self._sign[10] = 1 if config[10] else -1  #1 minimize, -1 maximize
    self._sign[11] = 1 if config[11] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 12
    cdef ObjVec[myInt12] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
    data[7] = self._sign[7]*item[7]
    data[8] = self._sign[8]*item[8]
    data[9] = self._sign[9]*item[9]
    data[10] = self._sign[10]*item[10]
    data[11] = self._sign[11]*item[11]
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
    cdef vector[const ObjVec[myInt12]*] vec
    cdef ObjVec[myInt12] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6],self._sign[7]*veci[7],self._sign[8]*veci[8],self._sign[9]*veci[9],self._sign[10]*veci[10],self._sign[11]*veci[11]])
    return res


ctypedef BspTreeArchive[myInt13] BspTreeArchive13

cdef class PyBspTreeArchive13:
  cdef BspTreeArchive13 *_front
  cdef int _sign[13]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive13, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive13()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1
    self._sign[7] = 1
    self._sign[8] = 1
    self._sign[9] = 1
    self._sign[10] = 1
    self._sign[11] = 1
    self._sign[12] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize
    self._sign[7] = 1 if config[7] else -1  #1 minimize, -1 maximize
    self._sign[8] = 1 if config[8] else -1  #1 minimize, -1 maximize
    self._sign[9] = 1 if config[9] else -1  #1 minimize, -1 maximize
    self._sign[10] = 1 if config[10] else -1  #1 minimize, -1 maximize
    self._sign[11] = 1 if config[11] else -1  #1 minimize, -1 maximize
    self._sign[12] = 1 if config[12] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 13
    cdef ObjVec[myInt13] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
    data[7] = self._sign[7]*item[7]
    data[8] = self._sign[8]*item[8]
    data[9] = self._sign[9]*item[9]
    data[10] = self._sign[10]*item[10]
    data[11] = self._sign[11]*item[11]
    data[12] = self._sign[12]*item[12]
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
    cdef vector[const ObjVec[myInt13]*] vec
    cdef ObjVec[myInt13] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6],self._sign[7]*veci[7],self._sign[8]*veci[8],self._sign[9]*veci[9],self._sign[10]*veci[10],self._sign[11]*veci[11],self._sign[12]*veci[12]])
    return res


ctypedef BspTreeArchive[myInt14] BspTreeArchive14

cdef class PyBspTreeArchive14:
  cdef BspTreeArchive14 *_front
  cdef int _sign[14]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive14, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive14()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1
    self._sign[7] = 1
    self._sign[8] = 1
    self._sign[9] = 1
    self._sign[10] = 1
    self._sign[11] = 1
    self._sign[12] = 1
    self._sign[13] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize
    self._sign[7] = 1 if config[7] else -1  #1 minimize, -1 maximize
    self._sign[8] = 1 if config[8] else -1  #1 minimize, -1 maximize
    self._sign[9] = 1 if config[9] else -1  #1 minimize, -1 maximize
    self._sign[10] = 1 if config[10] else -1  #1 minimize, -1 maximize
    self._sign[11] = 1 if config[11] else -1  #1 minimize, -1 maximize
    self._sign[12] = 1 if config[12] else -1  #1 minimize, -1 maximize
    self._sign[13] = 1 if config[13] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 14
    cdef ObjVec[myInt14] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
    data[7] = self._sign[7]*item[7]
    data[8] = self._sign[8]*item[8]
    data[9] = self._sign[9]*item[9]
    data[10] = self._sign[10]*item[10]
    data[11] = self._sign[11]*item[11]
    data[12] = self._sign[12]*item[12]
    data[13] = self._sign[13]*item[13]
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
    cdef vector[const ObjVec[myInt14]*] vec
    cdef ObjVec[myInt14] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6],self._sign[7]*veci[7],self._sign[8]*veci[8],self._sign[9]*veci[9],self._sign[10]*veci[10],self._sign[11]*veci[11],self._sign[12]*veci[12],self._sign[13]*veci[13]])
    return res


ctypedef BspTreeArchive[myInt15] BspTreeArchive15

cdef class PyBspTreeArchive15:
  cdef BspTreeArchive15 *_front
  cdef int _sign[15]
  cdef int _id

  def __reduce__(self):
    return (PyBspTreeArchive15, (self._id, self._sign))

  def __cinit__(self):
    self._front = new BspTreeArchive15()
    self._id = 0
    self._sign[0] = 1
    self._sign[1] = 1
    self._sign[2] = 1
    self._sign[3] = 1
    self._sign[4] = 1
    self._sign[5] = 1
    self._sign[6] = 1
    self._sign[7] = 1
    self._sign[8] = 1
    self._sign[9] = 1
    self._sign[10] = 1
    self._sign[11] = 1
    self._sign[12] = 1
    self._sign[13] = 1
    self._sign[14] = 1

  def configure(self, config):
    self._sign[0] = 1 if config[0] else -1  #1 minimize, -1 maximize
    self._sign[1] = 1 if config[1] else -1  #1 minimize, -1 maximize
    self._sign[2] = 1 if config[2] else -1  #1 minimize, -1 maximize
    self._sign[3] = 1 if config[3] else -1  #1 minimize, -1 maximize
    self._sign[4] = 1 if config[4] else -1  #1 minimize, -1 maximize
    self._sign[5] = 1 if config[5] else -1  #1 minimize, -1 maximize
    self._sign[6] = 1 if config[6] else -1  #1 minimize, -1 maximize
    self._sign[7] = 1 if config[7] else -1  #1 minimize, -1 maximize
    self._sign[8] = 1 if config[8] else -1  #1 minimize, -1 maximize
    self._sign[9] = 1 if config[9] else -1  #1 minimize, -1 maximize
    self._sign[10] = 1 if config[10] else -1  #1 minimize, -1 maximize
    self._sign[11] = 1 if config[11] else -1  #1 minimize, -1 maximize
    self._sign[12] = 1 if config[12] else -1  #1 minimize, -1 maximize
    self._sign[13] = 1 if config[13] else -1  #1 minimize, -1 maximize
    self._sign[14] = 1 if config[14] else -1  #1 minimize, -1 maximize

  def __dealloc__(self):
    del self._front
    self._front = NULL

  def process(self, item, customId=None, returnId=False):
    assert len(item) == 15
    cdef ObjVec[myInt15] data
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
    data[5] = self._sign[5]*item[5]
    data[6] = self._sign[6]*item[6]
    data[7] = self._sign[7]*item[7]
    data[8] = self._sign[8]*item[8]
    data[9] = self._sign[9]*item[9]
    data[10] = self._sign[10]*item[10]
    data[11] = self._sign[11]*item[11]
    data[12] = self._sign[12]*item[12]
    data[13] = self._sign[13]*item[13]
    data[14] = self._sign[14]*item[14]
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
    cdef vector[const ObjVec[myInt15]*] vec
    cdef ObjVec[myInt15] veci
    cdef int i
    vec = self._front.points()
    res = []
    for i in range(0,vec.size()):
        val = vec[i]
        veci = val[0]
        if returnIds:
            res.append(veci.getId())
        else:
            res.append([self._sign[0]*veci[0],self._sign[1]*veci[1],self._sign[2]*veci[2],self._sign[3]*veci[3],self._sign[4]*veci[4],self._sign[5]*veci[5],self._sign[6]*veci[6],self._sign[7]*veci[7],self._sign[8]*veci[8],self._sign[9]*veci[9],self._sign[10]*veci[10],self._sign[11]*veci[11],self._sign[12]*veci[12],self._sign[13]*veci[13],self._sign[14]*veci[14]])
    return res

OBJ2CLASS = {2:PyBspTreeArchive2,3:PyBspTreeArchive3,4:PyBspTreeArchive4,5:PyBspTreeArchive5,6:PyBspTreeArchive6,7:PyBspTreeArchive7,8:PyBspTreeArchive8,9:PyBspTreeArchive9,10:PyBspTreeArchive10,11:PyBspTreeArchive11,12:PyBspTreeArchive12,13:PyBspTreeArchive13,14:PyBspTreeArchive14,15:PyBspTreeArchive15}



class PyBspTreeArchive:
  def __init__(self, objectives=3, minimizeObjective1=True, minimizeObjective2=True, minimizeObjective3=True, minimizeObjective4=True, minimizeObjective5=True, minimizeObjective6=True):
     if (objectives < 2) or (objectives > MAXOBJ):
        raise Exception("Invalid number of objectives. Only %s and %s is supported" % (','.join([str(a) for a in range(2, MAXOBJ)]),MAXOBJ))
     self._archive = OBJ2CLASS[objectives]()
     self._archive.configure([minimizeObjective1,minimizeObjective2,minimizeObjective3,minimizeObjective4,minimizeObjective5,minimizeObjective6])
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
