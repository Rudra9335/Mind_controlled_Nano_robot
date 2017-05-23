# Module reads Neurosky's raw data and loads it into a .txt file
# Dependencies: Need Consider library (https://pypi.python.org/pypi/consider)
# Import these libraries (The rest are provided)
import os
from consider import Consider
from itertools import islice
from time import strftime

# Import the function by doing the following line: from readneurosky import get_packs
# To call function: get_packs(Npacks, filename, overwrite)
def get_packs(Npacks, filename, overwrite):
	# Inputs:
	# Npacks - number of packets
	# filename - name of file for convenience
	# overwrite - set as 1 for overwrite
	# Outputs:
	# a file in your directory called "filename".txt
	# Initialize counter
	i = 1
	# Append .txt to filename
	filenametemp = filename+'.txt'
	# Check if file already exists and handle it appropriately with overwrite
	if (os.path.isfile(filenametemp) and overwrite == 1):
		os.remove(filenametemp)
	elif os.path.isfile(filenametemp):
		while os.path.isfile(filenametemp):
			filenametemp = filename+str(i)+'.txt'
			i += 1
	filename = filenametemp
	# Create file
	f = open(filename,'w')
	# Initialize Consider object
	con = Consider()
	# Generate packets to file)
	print 'hello world'
	try:
		for p in islice(con.packet_generator(), Npacks):
			temp = str(p)
			temp = temp.replace(","," ,")
			print temp
			f.write(temp+' '+strftime("%H:%M:%S")+'\n')
	except:
		print("Error: Check if headset is connected")
	# Close file
	f.close()
	del f

get_packs(45, "attention", 0)