# Makefile for the project

TARGET = listdevs

CUR_DIR := .
TOP_DIR := $(CUR_DIR)

CC = $(CROSS_COMPILE)gcc
CPP = $(CROSS_COMPILE)g++
LD = $(CROSS_COMPILE)ld
AR = $(CROSS_COMPILE)ar cr
STRIP = $(CROSS_COMPILE)strip

# -Werror
CFLAGS = -O2 -Wall -Wno-unused-function
LDFLAG += -Wl,-gc-sections
LIBS = -lpthread -lrt -lm

# Macro
EFLAGS := -D__linux__

# Header
EFLAGS += -I$(TOP_DIR)
EFLAGS += -I$(TOP_DIR)/libusb

SRCDIRS  := .
SRCFIXS  := .c

# SRCDIRS  += $(shell ls -R | grep '^\./.*:$$' | awk '{gsub(":","");print}')

SRCS := $(foreach d,$(SRCDIRS),$(wildcard $(addprefix $(d)/*,$(SRCFIXS))))
# Core
SRCS += $(TOP_DIR)/libusb/core.c
SRCS += $(TOP_DIR)/libusb/descriptor.c
SRCS += $(TOP_DIR)/libusb/hotplug.c
SRCS += $(TOP_DIR)/libusb/io.c
SRCS += $(TOP_DIR)/libusb/sync.c

SRCS += $(TOP_DIR)/libusb/os/linux_usbfs.c
SRCS += $(TOP_DIR)/libusb/os/threads_posix.c
SRCS += $(TOP_DIR)/libusb/os/events_posix.c
SRCS += $(TOP_DIR)/libusb/os/linux_netlink.c
#SRCS += $(TOP_DIR)/libusb/os/linux_udev.c

# Example
SRCS += $(TOP_DIR)/examples/listdevs.c


OBJS := $(patsubst %.c,%.o,$(SRCS))

# for debug
$(warning source list $(SRCS))
# $(warning objs list $(OBJS))


CFLAGS += $(EFLAGS)
# AM_CFLAGS = -std=gnu11  -Wall -Wextra -Wshadow -Wunused -Wwrite-strings -Werror=format-security -Werror=implicit-function-declaration -Werror=implicit-int -Werror=init-self -Werror=missing-prototypes -Werror=strict-prototypes -Werror=undef -Werror=uninitialized
# AM_CXXFLAGS = -std=gnu++11  -Wall -Wextra -Wshadow -Wunused -Wwrite-strings -Werror=format-security -Werror=implicit-function-declaration -Werror=implicit-int -Werror=init-self -Werror=missing-prototypes -Werror=strict-prototypes -Werror=undef -Werror=uninitialized -Wmissing-declarations


$(TARGET): $(OBJS)
	$(CC) $(LDFLAG) -o $@ $^ $(LIBS)
	$(STRIP) $@

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

all: $(TARGET)

clean:
	rm -rf $(TARGET) $(OBJS) *.a *~

