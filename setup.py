from setuptools import setup, find_packages
from setuptools.extension import Extension
from Cython.Distutils import build_ext
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
    name = 'paretoarchive',
    version = '1.0',
    description = 'Efficient incremental Pareto archive',
    ext_modules = cythonize([ext_module]),
    packages = find_packages(),
)

