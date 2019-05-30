#corss:=arm-linux-gnueabihf

host:=
cc:=gcc

ifdef corss
	host=$(corss)
	cc=$(corss)-$(cc)
endif

ROOT=$(shell pwd)

all:
	@cd $(ROOT) && \
	rm ./libs -rf && \
	mkdir ./libs && \
	tar -xjf ./alsa-lib-1.1.9.tar.bz2 -C ./libs && \
	tar -xjf ./pjproject-2.8.tar.bz2 -C ./libs && \
	cd $(ROOT)/libs/alsa-lib-1.1.9 && \
	./configure --prefix=$(ROOT)/libs --host=$(host) && \
	make -j4 && make install && \
	cd $(ROOT)/libs/pjproject-2.8 && \
	./configure --prefix=$(ROOT)/libs --host=$(host) LDFLAGS=-L$(ROOT)/libs/lib CFLAG=-I$(ROOT)/libs/include --disable-ssl --disable-libwebrtc && \
	make dep && make -j4 && make install && \
	cd -
	@echo "---------- all complete !! ----------"

clean:
	@cd $(ROOT) && \
	rm ./libs -rf && \
	cd -
	@echo "---------- all clean ----------"
