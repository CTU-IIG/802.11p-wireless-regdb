# Install prefix
PREFIX = /usr
CDRA_PATH = $(PREFIX)/lib/crda

MANDIR ?= $(PREFIX)/share/man/


.PHONY: all clean install maintainer-clean

all: regulatory.bin key.pub.pem

clean:
	rm -f *.pyc *.gz

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

%.gz: %
	gzip < $< > $@

# Distributions wishing to just use John's database
# can just call make install.
install: regulatory.bin.5.gz
	install -o 0 -g 0 -m 755 -d $(DESTDIR)/$(CDRA_PATH)
	install -o 0 -g 0 -m 644 regulatory.bin $(DESTDIR)/$(CDRA_PATH)/regulatory.bin
	mkdir -p $(DESTDIR)/$(MANDIR)/man5/
	install -m 644 -t $(DESTDIR)/$(MANDIR)/man5/ regulatory.bin.5.gz
