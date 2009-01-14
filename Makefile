# Install prefix
PREFIX = /usr
CDRA_PATH = $(PREFIX)/lib/crda

.PHONY: all clean install maintainer-clean

all: regulatory.bin key.pub.pem

clean:
	rm -f *.pyc

maintainer-clean: clean
	rm -f regulatory.bin key.pub.pem

ifneq ($(wildcard key.priv.pem),)
regulatory.bin: db.txt key.priv.pem
	./db2bin.py regulatory.bin db.txt key.priv.pem

key.pub.pem: key.priv.pem
	openssl rsa -in key.priv.pem -out key.pub.pem -pubout -outform PEM
endif

key.priv.pem:
	openssl genrsa -out key.priv.pem 2048

install:
	install -o 0 -g 0 -m 755 -d $(CDRA_PATH)
	install -o 0 -g 0 -m 644 regulatory.bin $(CDRA_PATH)/regulatory.bin
