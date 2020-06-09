import os
import matplotlib.pyplot as plt

################################################################################################
# Configure your parameters here.

COMMANDS = [
	"./dineroIV -informat d -l1-usize 8192 -l1-ubsize 16 -l1-uccc -maxcount 500000 < ../traces/{}.din",
	"./dineroIV -informat d -l1-usize 16384 -l1-ubsize 16 -l1-uccc -maxcount 500000 < ../traces/{}.din",
	"./dineroIV -informat d -l1-usize 16384 -l1-ubsize 16 -l1-uassoc 2 -l1-uccc -maxcount 500000 < ../traces/{}.din",
	"./dineroIV -informat d -l1-usize 16384 -l1-ubsize 32 -l1-uassoc 2 -l1-uccc -maxcount 500000 < ../traces/{}.din",

	"./dineroIV -informat d -l1-dsize 8192 -l1-isize 8192 -l1-dbsize 32 -l1-ibsize 32 -l1-dassoc 2 -l1-iassoc 2 -l1-dccc -maxcount 500000 < ../traces/{}.din",
	"./dineroIV -informat d -l1-dsize 8192 -l1-isize 8192 -l1-dbsize 32 -l1-ibsize 32 -l1-dassoc 2 -l1-iassoc 2 -l1-iccc -maxcount 500000 < ../traces/{}.din",
	
	"./dineroIV -informat d -l1-dsize 8192 -l1-isize 8192 -l1-dbsize 32 -l1-ibsize 32 -l1-dassoc 2 -l1-iassoc 2 -l2-usize 131072 -l2-ubsize 32 -l1-uassoc 2 -l1-dccc -maxcount 500000 < ../traces/{}.din",
	"./dineroIV -informat d -l1-dsize 8192 -l1-isize 8192 -l1-dbsize 32 -l1-ibsize 32 -l1-dassoc 2 -l1-iassoc 2 -l2-usize 131072 -l2-ubsize 32 -l1-uassoc 2 -l1-iccc -maxcount 500000 < ../traces/{}.din",
	
	"./dineroIV -informat d -l1-dsize 8192 -l1-isize 8192 -l1-dbsize 32 -l1-ibsize 32 -l1-dassoc 2 -l1-iassoc 2 -l2-usize 131072 -l2-ubsize 32 -l1-uassoc 2 -l2-uccc -maxcount 500000 < ../traces/{}.din",
]

BENCHMARKS = ["cc1", "spice", "tex"]

INPUT_DIR = "/dineroIV/d4-7/"
OUTPUT_DIR = "./tables-out"

################################################################################################

params = ["Demand Fetches", "Compulsory misses", "Capacity misses", "Conflict misses", "Demand Misses", "Demand miss rate"]

def extract_data_from_line(prefix, line, data):
	if line.strip().startswith(prefix):
		line = line.split()
		base = len(prefix.split())
		data[prefix] = [float(line[base+2]), float(line[base+1]), float(line[base])]

def get_data(command):
	os.chdir(internal_dir)
	stream = os.popen(command)
	data = {}
	for line in stream:
		for param in params:
			extract_data_from_line(param, line, data)
	os.chdir(actual_dir)
	return data

def get_string(data):
	print(data)
	answer = ""
	for i in range(0,3):
		for param in params:
			answer += f"{data[param][i]}\t"
		answer += "\n"
	return answer

def insert_data_to_file(indexes, benchmark):
	merged_data = {}
	for i, index in enumerate(indexes):
		index -= 1

		data = get_data(COMMANDS[index].format(benchmark))
		if i == 0:
			merged_data = data
			continue
		for key in params:
			merged_data[key] = [x+y for x,y in zip(merged_data[key], data[key])]

	# merged_data["Demand miss rate"] = [float(x)/float(y) for x,y in zip(merged_data["Demand Misses"], merged_data["Demand Fetches"])]

	with open(f"{OUTPUT_DIR}/{benchmark}.txt", 'a') as file:
		print("in file", os.getcwd())
		file.write(get_string(merged_data))

def run_for_benchmark(benchmark):
	insert_data_to_file([1], benchmark)
	insert_data_to_file([2], benchmark)
	insert_data_to_file([3], benchmark)
	insert_data_to_file([4], benchmark)
	insert_data_to_file([5, 6], benchmark)
	# insert_data_to_file([7, 8], benchmark)
	# insert_data_to_file([9], benchmark)

actual_dir = os.getcwd()
internal_dir = os.path.join(os.getcwd()+INPUT_DIR)

for benchmark in BENCHMARKS:
	run_for_benchmark(benchmark)
