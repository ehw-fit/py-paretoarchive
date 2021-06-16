#!/usr/bin/python
# This file automatically generates Cython file paretoarchive_gen.pyx based on paretorarchive.pyx
# It generates the classes for 1 to OBJS objectives
# Because of using c++ templates simple copy is needed

if __name__ == "__main__":

  OBJS = 15


  src = ['MAXOBJ = %d' % OBJS]
  src += ['']

  src += ['cdef extern from *:']
  for i in range(1,OBJS+1):
      src += ['    ctypedef int myInt%d "%d"    # a fake type' % (i,i)]


  for i in range(1,OBJS+1):
      src += ["""
  ctypedef BspTreeArchive[myInt%d] BspTreeArchive%d

  cdef class PyBspTreeArchive%d:
    cdef BspTreeArchive%d *_front
    cdef int _sign[%d]
    cdef int _id

    def __reduce__(self):
      return (PyBspTreeArchive%d, (self._id, self._sign))

    def __cinit__(self):
      self._front = new BspTreeArchive%d()
      self._id = 0""" % (i,i,i,i,i,i,i)]

      for j in range(0,i):
          src += ['    self._sign[%d] = 1' % j]


      src += ['']
      src += ['  def configure(self, config):']
      for j in range(0,i):
          src += ['    self._sign[%d] = 1 if config[%d] else -1  #1 minimize, -1 maximize' % (j,j)]

      src += ['']
      src += ["""  def __dealloc__(self):
      del self._front
      self._front = NULL

    def process(self, item, customId=None, returnId=False):
      assert len(item) == %d
      cdef ObjVec[myInt%d] data
      cdef int i
      if customId == None:
          customId = self._id
          self._id += 1
      data.setId(customId)""" % (i,i)]


      for j in range(0,i):
          src += ['    data[%d] = self._sign[%d]*item[%d]' % (j,j,j)]


      dd = []
      for j in range(0,i):
          dd.append('self._sign[%d]*veci[%d]' % (j,j))
      dd = ','.join(dd)


      src += ["""    if not returnId:
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
      cdef vector[const ObjVec[myInt%d]*] vec
      cdef ObjVec[myInt%d] veci
      cdef int i
      vec = self._front.points()
      res = []
      for i in range(0,vec.size()):
          val = vec[i]
          veci = val[0]
          if returnIds:
              res.append(veci.getId())
          else:
              res.append([%s])
      return res""" % (i,i,dd)]

      src += ['']


  src += ['OBJ2CLASS = {%s}' % ','.join(['%d:PyBspTreeArchive%d' % (i,i) for i in range(2, OBJS+1)])]
  src += ['']

  tpl = open('paretoarchive.pyx').read()
  open('paretoarchive_gen.pyx','w').write(tpl.replace('%CLASSES%','\n'.join(src)))
