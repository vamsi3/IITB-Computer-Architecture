import os
import matplotlib.pyplot as plt

################################################################################################
# Configure your parameters here.

COMMAND_1 = "./dineroIV -informat d -l1-usize {} -l1-ubsize {} -l1-uccc -maxcount 500000 < ../traces/{}.din"
COMMAND_2 = "./dineroIV -informat d -l1-usize {} -l1-uassoc {} -l1-ubsize 32 -l1-uccc -maxcount 500000 < ../traces/{}.din"

BLOCK_SIZES = [8, 16, 32, 64, 128]
ASSOCIATIVITIES = [1, 2, 4, 8, 16]

CACHE_SIZES = [4, 8, 16, 32]

BENCHMARKS = ["cc1", "spice", "tex"]

INPUT_DIR = "/dineroIV/d4-7/"
OUTPUT_DIR = "./plots"

################################################################################################

CACHE_SIZES = [1024*cache_size for cache_size in CACHE_SIZES]

parts = [
	{
		"x-label": "Block Size",
		"x-values": BLOCK_SIZES,
		"command": COMMAND_1
	},
	{
		"x-label": "Associativity",
		"x-values": ASSOCIATIVITIES,
		"command": COMMAND_2
	}
]

def get_missing_rate_from_stream(stream):
	for line in stream:
		if line.strip().startswith("Demand miss rate"):
			return float(line.split()[3])

def get_missing_rates(cache_size, x_values, template_command, benchmark):
	missing_rates = []
	for x_value in x_values:
		stream = os.popen(template_command.format(cache_size, x_value, benchmark))
		missing_rate = get_missing_rate_from_stream(stream)
		missing_rates.append(missing_rate)
		print(missing_rate, cache_size, x_value)
	return missing_rates

def run_for_benchmark(benchmark):
	for index, part in enumerate(parts):
		os.chdir(internal_dir)

		for cache_size in CACHE_SIZES:
			missing_rates = get_missing_rates(cache_size, part["x-values"], part["command"], benchmark)
			plt.plot(part["x-values"], missing_rates, label=f"{int(cache_size/1024)}K cache")

		os.chdir(actual_dir)

		filename = f"P{index+1}-{benchmark}"
		plt.title(filename)
		plt.xlabel(part["x-label"])
		plt.ylabel("Miss Rate")
		plt.legend()
		plt.savefig(f"{OUTPUT_DIR}/{filename}.png")
		plt.clf()

actual_dir = os.getcwd()
internal_dir = os.path.join(os.getcwd()+INPUT_DIR)

for benchmark in BENCHMARKS:
	run_for_benchmark(benchmark)
