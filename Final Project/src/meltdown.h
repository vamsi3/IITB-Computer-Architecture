#pragma once

#include <cpuid.h>
#include <errno.h>
#include <fcntl.h>
#include <memory.h>
#include <pthread.h>
#include <sched.h>
#include <setjmp.h>
#include <signal.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#if !defined(__x86_64__)
	#error This program only works on x86_64 architecture
#endif

#define DEFAULT_PHYSICAL_OFFSET 0xFFFF880000000000ull

typedef enum { ERROR, INFO, SUCCESS } debug_symbol_t;

typedef struct {
	uint64_t physical_offset;
	uint64_t cache_miss_threshold;
	uint64_t retries;
	uint64_t measurements;
	uint64_t accept_after;
	uint64_t thread_count;
} meltdown_config_t;

int meltdown_init();
int meltdown_read();
int meltdown_exit();

uint64_t virtual_to_physical(uint64_t virtual_address);
uint64_t physical_to_virtual(uint64_t physical_address);
