from setuptools import setup, find_packages
from setuptools.extension import Extension
from Cython.Build import cythonize


ext_module = Extension(
    "paretoarchive",
    ["paretoarchive_gen.pyx"],
    language="c++",
    extra_compile_args=["-std=c++11"],
    include_dirs=["./src"], 
#    extra_link_args=["-std=c++11"]
)

setup(
    name = 'py-paretoarchive',
    version = '0.11',
    data_files=["paretoarchive_gen.pyx",
    "src/Makefile",
    "src/nullptr_emulation.h",
    "src/paretoarchive.h",
    "src/test.cpp"]
    
    ,
    description = 'Efficient incremental Pareto archive',
    ext_modules = cythonize([ext_module]),
    packages = find_packages(),
)

