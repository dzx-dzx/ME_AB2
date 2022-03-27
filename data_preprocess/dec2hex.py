import numpy as np


def dec2hex(array: np.ndarray, target_file):
    data = array
    data = data.flatten()
    print(f"data shape: {data.shape}")
    with open(target_file, "w") as f:
        for value in data:
            f.write(str(hex(value)) + "\n")
