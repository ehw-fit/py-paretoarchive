%PREAMBLE%

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


%CLASSES%


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
