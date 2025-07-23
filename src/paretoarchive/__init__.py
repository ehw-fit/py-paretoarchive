
"""
This module provides Pareto front calculation utilities with support for different data structures.

Imports:
    pandas_pareto: Pareto front calculation for pandas DataFrames.
    np_pareto: Pareto front calculation for NumPy arrays.

Usage:

    # For pandas DataFrames
    pareto_front = pandas_pareto(df)

    # For NumPy arrays - returns a boolean array indicating Pareto-optimal points
    pareto_front = np_pareto(array)
"""
from .np import pareto as np_pareto
from .pandas import pareto as pandas_pareto
