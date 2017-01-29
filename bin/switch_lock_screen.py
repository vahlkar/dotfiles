#!/bin/python3
import os
import sys
from random import randrange

path = './lock-screen/'
imgs = []

for element in os.listdir(path):
    if not os.path.isdir(element):
        imgs.append(element)

img = randrange(len(imgs))
img_out = open("lock.png", "wb")
img_in = open(path + imgs[img], "rb")
img_out.write(img_in.read())
img_in.close()
img_out.close()

