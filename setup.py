from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext


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
    cmdclass = {'build_ext': build_ext},
    ext_modules = [ext_module]
)

