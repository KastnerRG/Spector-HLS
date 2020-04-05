import random

def filter_generate(filter_size, filename, x1=0, x2=10):
	
	filter_list = []
	for x in range(filter_size):
		filter_list.append(random.uniform(x1, x2))
	file = open(filename, 'w')
	file.write("int x[")
	file.write(str(filter_size))
	file.write("] = {")
	count = 0;
	for i in filter_list:
		count = count + 1
		file.write('{}'.format(i))
		if count != filter_size:
		    file.write(', ')
	file.write('};')
	file.close()

def input_generate(input_size, filename, x1=0, x2=10):
	
	input_list = []
	for x in range(input_size):
		input_list.append(random.uniform(x1, x2))
	file = open(filename, 'w')
	file.write("int x[")
	file.write(str(input_size))
	file.write("] = {")
	count = 0;
	for i in input_list:
		count = count + 1
		file.write('{}'.format(i))
		if count != input_size:
		    file.write(', ')
	file.write('};')
	file.close()

input_generate(65536, 'fir_input.h',x1=0, x2=10)
filter_generate(1024, 'fir_filter.h',x1=0, x2=10)