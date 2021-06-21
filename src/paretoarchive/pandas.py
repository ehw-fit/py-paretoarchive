

try:
    import pandas as pd
except ImportError:
    pd = None


from .core import PyBspTreeArchive


def pareto(data: pd.DataFrame, columns: list, **kwargs) -> pd.DataFrame:
    """
    You can easily use the library to filter a Pandas DataFrame. Note that the selected 
    columns cannot have a "NaN" values (you should use `df.dropna(subset=["c1", "c2"]`) 
    function.
    """
    filt = list(zip(*[data[c] for c in columns]))
    ids = data.index.tolist()

    sel = [ids[i] for i in PyBspTreeArchive(
        len(columns), **kwargs).filter(filt, returnIds=True)]
    filt = [i in sel for i in ids]
    return data[filt]
