#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

typedef enum magnitude {
	B_MAG = 0,
	KB_MAG,
	MB_MAG,
	GB_MAG,
} magnitude;

void pretty_print_size_label(uint32_t size, magnitude mag) {
	char converted_str[64];
	float converted_size = size;
	for (int i = 0; i < mag; i++) {
		//go up an order of magnitude up to requested
		converted_size /= 1024;
	}
	sprintf((char*)&converted_str, "%f", converted_size);

	//char* label = "";
	switch (mag) {
		case B_MAG:
			printf("[B]  ");
			break;
		case KB_MAG:
			printf("[KB] ");
			break;
		case MB_MAG:
			printf("[MB] ");
			break;
		case GB_MAG:
			printf("[GB] ");
			break;
	}

	int len = strlen(converted_str);
	len -= strlen("[KB] ");
	for (int i = 0; i < len; i++) {
		putchar(' ');
	}
	putchar('|');
}

int main(int argc, char** argv) {
	if (argc < 2) {
		printf("Usage: nifz [file]\n");
		return 1;
	}
	FILE* stream = fopen(argv[1], "r");
	if (!stream) {
		if (errno == ENOENT) {
			printf("File %s not found.\n", argv[1]);
		}
		else {
			printf("Unknown error\n");
		}
		return 1;
	}

	printf("%s's size:\n", argv[1]);

	//find file length
	fseek(stream, 0, SEEK_END);
	size_t file_size = ftell(stream);

	//we now have filesize in bytes
	//pretty-print in kb and mb
	for (int i = B_MAG; i <= GB_MAG; i++) {
		pretty_print_size_label(file_size, i);
	}
	putchar('\n');
	for (int i = B_MAG; i <= GB_MAG; i++) {
		float converted_size = file_size;
		for (int j = B_MAG; j < i; j++) {
			converted_size /= 1024.0;
		}
		printf("%f|", converted_size);
	}
	putchar('\n');

	return 0;
}



// vim:ft=objc
