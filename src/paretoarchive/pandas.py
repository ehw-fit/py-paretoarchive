

import pandas as pd

from typing import Union, List, Optional


def pareto(df: pd.DataFrame, columns: List[str], minimize: Optional[Union[bool, List[bool]]] = None, keep_data=False) -> pd.DataFrame:
    """
    Compute the Pareto front of a DataFrame for given columns.

    Parameters
    ----------
    df : pd.DataFrame
        Input DataFrame.
    columns : list of str
        List of column names to consider for Pareto optimality.
    minimize : None, bool, or list of bool, optional
        Whether to minimize (True) or maximize (False) each column.
        If None, all columns are minimized.
        If a single bool, applies to all columns.
        If a list, must match the length of columns.
    keep_data : bool, default False
        If True, returns the original DataFrame with an added 'pareto' column
        indicating Pareto-optimal rows. If False, returns only the Pareto-optimal rows.

    Returns
    -------
    pd.DataFrame
        DataFrame containing Pareto-optimal rows, or the original DataFrame with a 'pareto' column if keep_data is True.

    Raises
    ------
    ValueError
        If the length of minimize does not match the number of columns.
    AssertionError
        If 'dominated' or 'pareto' columns already exist in the DataFrame.

    Examples
    --------
    >>> df = pd.DataFrame({"A": [1, 2, 3], "B": [3, 2, 1]})
    >>> pareto(df, ["A", "B"], minimize=[True, False])
    """
    df = df.copy()

    if minimize is None:
        minimize = [True] * len(columns)
    elif isinstance(minimize, bool):
        minimize = [minimize] * len(columns)
    elif len(minimize) == 1:
        minimize = minimize * len(columns)
    elif len(minimize) != len(columns):
        raise ValueError("Length of minimize must match length of columns.")

    assert "dominated" not in df.columns, "DataFrame already has 'dominated' column."

    df["dominated"] = False

    for id, row in df.iterrows():
        if row["dominated"]:
            continue

        dom = True
        strict = False
        for c, asc in zip(columns, minimize):
            if asc:
                dom &= (df[c] >= row[c])
                strict |= (df[c] > row[c])
            else:
                dom &= (df[c] <= row[c])
                strict |= (df[c] < row[c])

        df["dominated"] |= (dom & strict)

    if keep_data:
        assert "pareto" not in df.columns, "DataFrame already has 'pareto' column."
        df["pareto"] = ~df["dominated"]

        return df.drop(columns=["dominated"])

    else:
        return df.query("not dominated").drop(columns=["dominated"])
