import numpy as np

def pareto(*columns : np.ndarray, minimize : list[bool] | bool = True) -> np.ndarray:
    
    if isinstance(minimize, bool):
        minimize = [minimize] * len(columns)
    elif len(minimize) == 1:
        minimize = minimize * len(columns)
    elif len(minimize) != len(columns):
        raise ValueError("Length of minimize must match length of columns.")
        
    assert len(columns) > 2, "At least two columns are required for Pareto front calculation."
    
    # test all columns are vectors of the same length
    for col in columns:
        assert len(col) == len(columns[0]), "All columns must have the same length."
        
        
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
