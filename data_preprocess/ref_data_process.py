import numpy as np
from dec2hex import dec2hex

print("===== Processing Ref Frame =====")

data = np.load("./data/ref_img.npy")
print(data.shape)
data = data.reshape(3840, 2160)
padded_data = np.pad(data, (7, 9))
print(padded_data.shape)
blocks = []
y_anchor = 0

while y_anchor <= padded_data.shape[1] - 23:
    x = 0
    row_blocks = []
    while x <= padded_data.shape[0] - 8:
        row_blocks.append(np.array(padded_data[x : x + 8, y_anchor : y_anchor + 23]).T)
        x += 8
    blocks.append(row_blocks)
    y_anchor += 8

blocks = np.array(blocks)
print(blocks.shape)
ref_blocks = blocks.flatten()

dec2hex(ref_blocks, "./data/ref_processed.txt")
