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

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name = 'py-paretoarchive',
    version = '0.12',
    data_files=["paretoarchive_gen.pyx",
    "src/Makefile",
    "src/nullptr_emulation.h",
    "src/paretoarchive.h",
    "src/test.cpp"]
    
    ,
    author="Vojtech Mrazek, Zdenek Vasicek",

    description = 'Efficient incremental Pareto archive based on BSP ',
    long_description=long_description,
    long_description_content_type="text/markdown",

    url="https://github.com/ehw-fit/py-paretoarchive",
    project_urls={
        "Bug Tracker": "https://github.com/ehw-fit/py-paretoarchive/issues",
    },

    package_dir={"": "src"},
    ext_modules = cythonize([ext_module]),
    packages = find_packages(),
)

