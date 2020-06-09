CC = gcc
CFLAGS = -lpthread

READER = string_reader
GENERATOR = string_generator

all: $(READER) $(GENERATOR)

$(READER): string_reader.c meltdown.c
	$(CC) string_reader.c meltdown.c $(CFLAGS) -w -o $(READER)

$(GENERATOR): string_generator.c
	$(CC) string_generator.c meltdown.c $(CFLAGS) -w -o $(GENERATOR)

clean:
	rm -f $(READER)
	rm -f $(GENERATOR)
