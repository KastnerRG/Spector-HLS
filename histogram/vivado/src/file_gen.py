import random
import math

file = open("input.dat", "w+")

for i in range(int(math.pow(2,20))):
	file.write(str(random.randint(0,255)))
	file.write("\n")

file.write(" ")
file.close()