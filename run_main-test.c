#include <stdio.h>
#include "pstring.h"


void run_main() {
	Pstring p1;
	Pstring p2;
	int len;
	int opt;

	// initialize first pstring
	printf("enter length and string\n");
	scanf("%d", &len);
	scanf("%s", p1.str);
	p1.len = len;

	// initialize second pstring
	printf("enter length and string\n");
	scanf("%d", &len);
	scanf("%s", p2.str);
    p2.len = len;

	// select which function to run
	printf("select function\n");
	scanf("%d", &opt);
	run_func(opt, &p1, &p2);

}
