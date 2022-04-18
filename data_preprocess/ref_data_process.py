import numpy as np
from dec2hex import dec2hex

print("===== Processing Ref Frame =====")

data = np.rot90(np.load("./data/ref_img.npy").reshape(3840, 2160), k=-1)

padded_data = np.pad(data, (7, 9))
print(padded_data.shape)
rows = padded_data.shape[0]
cols = padded_data.shape[1]

blocks = []

row = 0
while row <= rows - 23:
    row_blocks = []
    for col in range(cols // 8):
        block = padded_data[row : row + 23, col * 8 : col * 8 + 8]
        row_blocks.append(block)

    blocks.append(row_blocks)
    row += 8
blocks = np.array(blocks)

print(blocks.shape)
ref_blocks = blocks.flatten()

dec2hex(ref_blocks, "./data/ref_processed.txt")
