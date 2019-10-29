import random
import math

file = open("input.dat", "w+")

for i in range(500000):
	file.write(str(random.randint(0,255)))
	file.write("\n")

file.write(" ")
file.close()