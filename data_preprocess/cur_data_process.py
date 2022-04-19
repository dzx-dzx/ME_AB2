import numpy as np
from dec2hex import dec2hex

print("===== Processing Cur Frame =====")

data = np.load("./data/cur_img.npy").reshape(3840, 2160)

rows = data.shape[0]
cols = data.shape[1]
size = 8
blocks = []

for row in range(rows // size):
    for col in range(cols // size):
        block = data[size * row : size * (row + 1), size * col : size * (col + 1)]
        block = np.rot90(block)
        blocks.append(block)

blocks = np.array(blocks)
print(blocks.shape)
blocks = blocks.flatten()

dec2hex(blocks, "./data/cur_processed.txt")
