import numpy as np
from dec2hex import dec2hex

print("===== Processing Cur Frame =====")

data = np.load("./data/cur_img.npy")
print(data.shape)
data = data.reshape(3840, 2160)
size = [8, 8]
blocks = []
for y in range(int(2160 / size[1])):
    for x in range(int(3840 / size[0])):
        block = data[size[0] * x : size[0] * (x + 1), size[1] * y : size[1] * (y + 1)]
        blocks.append(block)
blocks = np.array(blocks)
print(blocks.shape)
blocks = blocks.flatten()

dec2hex(blocks, "./data/cur_processed.txt")
