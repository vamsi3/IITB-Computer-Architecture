#include <stdio.h>
#include <stdlib.h>

int main () {
	int x = 0, ans = 0;
	do {
		if (x != ((int) ((float) x)) && ans > x) ans = x;
	} while (++x != 0);
	printf("%d\n", ans);
}
