
#cross:=arm-linux-gnueabihf

host:=
cc:=gcc

ifdef cross
	host=$(cross)
	cc=$(cross)-gcc
endif

ROOT=$(shell pwd)

CFLAGS+= -I./libs/include
LIBS+= -L./libs/lib

CFLAGS+= -DPJ_AUTOCONF=1 -DPJ_IS_BIG_ENDIAN=0 -DPJ_IS_LITTLE_ENDIAN=1
LIBS+= $(shell grep "Libs:" ./libs/lib/pkgconfig/libpjproject.pc | grep -o "\-l.*")

target:
	@$(cc) -o app demo.c $(CFLAGS) $(LIBS)

all: dpkg-alsa alsa dpkg-pjproject pjproject
	@$(cc) -o app demo.c $(CFLAGS) $(LIBS)
	@echo "---------- all complete !! ----------"

dpkg-pjproject:
	tar -xjf ./pjproject-2.8.tar.bz2 -C ./libs

pjproject:
	@cd $(ROOT)/libs/pjproject-2.8 && \
	./configure --prefix=$(ROOT)/libs --host=$(host) LDFLAGS=-L$(ROOT)/libs/lib CFLAG=-I$(ROOT)/libs/include --disable-ssl --disable-libwebrtc && \
	make dep && make -j4 && make install && \
	cd -

dpkg-alsa:
	tar -xjf ./alsa-lib-1.1.9.tar.bz2 -C ./libs

alsa:
	@cd $(ROOT)/libs/alsa-lib-1.1.9 && \
	./configure --prefix=$(ROOT)/libs --host=$(host) && \
	make -j4 && make install && \
	cd -

clean:
	@rm ./app

cleanAll:
	@rm ./libs/* ./app -rf
	@echo "---------- all clean ----------"

