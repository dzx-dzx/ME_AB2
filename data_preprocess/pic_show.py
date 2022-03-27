import numpy as np
import matplotlib.pyplot as plt

cur = np.load('./data/cur_img.npy').reshape(3840, 2160).T
ref = np.load('./data/ref_img.npy').reshape(3840, 2160).T

plt.style.use('grayscale')

fig = plt.figure(figsize=(15, 4))
ax1 = fig.add_subplot(131)
plt.imshow(cur)
plt.title('Cur')

ax2 = fig.add_subplot(132)
plt.imshow(ref)
plt.title('Ref')

ax3 = fig.add_subplot(133)
plt.imshow(255 - abs(cur - ref))
plt.title('Cur - Ref')


plt.show()
