from perlin_noise import PerlinNoise
from PIL import Image
from random import randint
import numpy as np

SEED=randint(0,999999)

print(f"Generating perlin noise generators (SEED={SEED})...")

noise1 = PerlinNoise(octaves=3 , seed=SEED)
noise2 = PerlinNoise(octaves=6 , seed=SEED)
noise3 = PerlinNoise(octaves=12, seed=SEED)
noise4 = PerlinNoise(octaves=24, seed=SEED)

xpix, ypix = 500, 500

print(f"Generating matrix {xpix}x{ypix}...")

pic = np.zeros((xpix, ypix))
for i in range(xpix):
    for j in range(ypix):
        # noise_val =         noise1([i/xpix, j/ypix])
        # noise_val += 0.5  * noise2([i/xpix, j/ypix])
        # noise_val += 0.25 * noise3([i/xpix, j/ypix])
        # noise_val += 0.125* noise4([i/xpix, j/ypix])

        e0 =       2*(0.5-abs(0.5-noise1([i/xpix, j/ypix])))
        e1 = 0.5  *2*(0.5-abs(0.5-noise2([i/xpix, j/ypix])))*e0
        e2 = 0.25 *2*(0.5-abs(0.5-noise3([i/xpix, j/ypix])))*(e0+e1)
        e3 = 0.125*2*(0.5-abs(0.5-noise4([i/xpix, j/ypix])))*(e0+e1+e2)
        noise_val = e3

        # noise_val = pow(noise_val, 2)

        pic[i,j] = noise_val

print("Normalizing matrix [0,255]...")
pic = (255*(pic - np.min(pic))/np.ptp(pic)).astype(np.uint8)

print("Saving matrix as hmap.png...")
im = Image.fromarray(pic)
im.save("hmap.png")
