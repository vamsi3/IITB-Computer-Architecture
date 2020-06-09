#include "meltdown.h"
#include <string.h>
#include <time.h>

#define STRING_COUNT 8

const char *strings[] = {
	"If you can read this, this is really bad",
	"Burn after reading this string, it is a secret string",
	"Congratulations, you just spied on an application",
	"Wow, you broke the security boundary between user space and kernel",
	"Welcome to the wonderful world of microarchitectural attacks",
	"Please wait while we steal your secrets...",
	"Don't panic... But your CPU is broken and your data is not safe",
	"How can you read this? You should not read this!"
};

int main(int argc, char *argv[]) {
	srand(time(NULL));

	const char *secret = strings[rand() % STRING_COUNT];
	printf("\x1b[32;1mSecret string:\x1b[0m %s\n", secret);
	size_t len = strlen(secret);

	meltdown_init();

	uint64_t physical_address = virtual_to_physical((uint64_t) secret);
	if (physical_address < 0) {
		printf("\x1b[31;1m[ERROR] Could not get physical address of secret. Are you running this with sudo?\x1b[0m\n");
		meltdown_exit();
		exit(1);
	}

	printf("\x1b[32;1mPhysical address of the secret string:\x1b[0m 0x%zx\n", physical_address);
	printf("\x1b[33;1mExit using Ctrl+C once you are done with this...\x1b[0m\n");
	
	while (1) {
		// keeping the string cached
		volatile size_t temporary_variable = 0, i;
		for (i = 0; i < len; i++) {
			temporary_variable += secret[i];
		}
		sched_yield();
	}

	meltdown_exit();
}
