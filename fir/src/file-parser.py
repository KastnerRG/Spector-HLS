import struct

for filename in ["1-tdFir-input.dat", "1-tdFir-filter.dat", "1-tdFir-answer.dat"]:
	file = open(filename, "rb")

	endian	=	struct.unpack('i', file.read(4))
	version	=	struct.unpack('i', file.read(4))[0]>>16

	complex_indicator = version

	dims	=	struct.unpack('i', file.read(4))

	dim_val = list()
	tlen = 1
	for i in range(dims[0]):
		dim_val.append(struct.unpack('i', file.read(4))[0])
		tlen = tlen * dim_val[i]

	val_list = list(struct.unpack('f'*tlen*2, file.read(4*tlen*2)))
	for i in [dim_val[1], dim_val[0], dims[0]]:
		val_list.insert(0, i)
	file.close()

	file = open(filename[8:], 'w+')

	for i in range(len(val_list)):
		file.write(str(val_list[i]))
		file.write('\n')

	file.close()
