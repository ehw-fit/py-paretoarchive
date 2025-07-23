import numpy as np


def pareto(*columns: np.ndarray, minimize: list[bool] | bool = True) -> np.ndarray:
    """
    Identifies the Pareto-optimal points (the Pareto front) from multiple objective columns.
    Parameters
    ----------
    *columns : np.ndarray
        Variable number of 1D numpy arrays, each representing an objective column. All columns must have the same length.
    minimize : list[bool] or bool, optional
        Indicates for each objective whether it should be minimized (True) or maximized (False).
        If a single boolean is provided, it is applied to all columns. Default is True (all objectives minimized).
    Returns
    -------
    np.ndarray
        A boolean array of the same length as the input columns, where True indicates that the corresponding point is Pareto-optimal.
    Raises
    ------
    ValueError
        If the length of `minimize` does not match the number of columns.
    AssertionError
        If fewer than two columns are provided, or if columns have mismatched lengths.
    Notes
    -----
    A point is Pareto-optimal if no other point is strictly better in all objectives (according to the minimize/maximize criteria).
    """

    if isinstance(minimize, bool):
        minimize = [minimize] * len(columns)
    elif len(minimize) == 1:
        minimize = minimize * len(columns)
    elif len(minimize) != len(columns):
        raise ValueError("Length of minimize must match length of columns.")

    assert len(
        columns) > 2, "At least two columns are required for Pareto front calculation."

    # test all columns are vectors of the same length
    for col in columns:
        assert len(col) == len(
            columns[0]), "All columns must have the same length."

    dominated = np.zeros(columns[0].shape[0], dtype=bool)

    for i in range(len(columns[0])):
        if dominated[i]:
            continue

        dom = True
        strict = False
        for c, asc in zip(columns, minimize):
            if asc:
                dom &= (c >= c[i])
                strict |= (c > c[i])
            else:
                dom &= (c <= c[i])
                strict |= (c < c[i])

        dominated |= (dom & strict)

    # Implementation of the Pareto front calculation
    return dominated == False
