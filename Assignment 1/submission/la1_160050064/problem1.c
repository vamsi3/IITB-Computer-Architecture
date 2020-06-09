#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
	for (;;) {
		char input_string[100000];
		scanf("%s", input_string);
		int *var_ptr;
		size_t var_size;
		if (strcmp(input_string, "END") == 0) {
			break;
		}
		else if (strchr(input_string, '.') != NULL) {
			float input_number = atof(input_string);
			var_ptr = &input_number;
		}
		else {
			int input_number = atoi(input_string);
			var_ptr = &input_number;
		}
		for (int i=31; i>=0; i--) {
			printf("%d", (*var_ptr >> i) & 1);
		}
		printf("\n");
	}
}
