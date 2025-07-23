from paretoarchive.pandas import pareto
import pandas as pd

def test_df():
    df = pd.DataFrame(
        [[1, 3, 3], [1, 2, 3], [1, 1, 2]], columns=["a", "b", "c"]
    )

    assert (pareto(df, ["a", "b"]).index == [2]).all()

    assert (pareto(df, ["a", "b", "c"]).index == [2]).all()
    print(pareto(df, ["a", "b", "c"], minimize=[False, True, True]))
    assert (pareto(df, ["a", "b", "c"], minimize=[True, False, True]).index == [0, 2]).all()

if __name__ == "__main__":
    test_df()