CFLAGS = -g -O3 -ansi -pedantic -Wall -Wextra -Wno-unused-parameter

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)
CFLAGS += -I$(ERLANG_PATH)

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

all: priv/portmidi_in.so priv/portmidi_out.so priv/portmidi_list.so

priv/portmidi_in.so: src/portmidi_in.c src/portmidi_shared.c
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ -lportmidi src/portmidi_in.c src/portmidi_shared.c

priv/portmidi_out.so: src/portmidi_out.c src/portmidi_shared.c
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ -lportmidi src/portmidi_out.c src/portmidi_shared.c

priv/portmidi_list.so: src/portmidi_list.c src/portmidi_shared.c
	$(CC) $(CFLAGS) -shared $(LDFLAGS) -o $@ -lportmidi src/portmidi_list.c src/portmidi_shared.c
