
#corss:=arm-linux-gnueabihf

host:=
cc:=gcc

ifdef corss
	host=$(corss)
	cc=$(corss)-gcc
endif

ROOT=$(shell pwd)

CFLAGS+= -I./libs/include
LIBS+= -L./libs/lib

CFLAGS+= -DPJ_AUTOCONF=1 -DPJ_IS_BIG_ENDIAN=0 -DPJ_IS_LITTLE_ENDIAN=1
LIBS+= $(shell cat ./libs/lib/pkgconfig/libpjproject.pc | grep "Libs:" | grep -o "\-l.*")

target:
	@$(cc) -o app demo.c $(CFLAGS) $(LIBS)

all: alsa pjproject
	@echo "---------- all complete !! ----------"

pjproject:
	tar -xjf ./pjproject-2.8.tar.bz2 -C ./libs
	@cd $(ROOT)/libs/pjproject-2.8 && \
	./configure --prefix=$(ROOT)/libs --host=$(host) LDFLAGS=-L$(ROOT)/libs/lib CFLAG=-I$(ROOT)/libs/include --disable-ssl --disable-libwebrtc && \
	make dep && make -j4 && make install && \
	cd -

alsa:
	tar -xjf ./alsa-lib-1.1.9.tar.bz2 -C ./libs
	@cd $(ROOT)/libs/alsa-lib-1.1.9 && \
	./configure --prefix=$(ROOT)/libs --host=$(host) && \
	make -j4 && make install && \
	cd -

clean:
	@rm ./app

cleanAll:
	@rm ./libs/* ./app -rf
	@echo "---------- all clean ----------"
