.PHONY: all clean

all: regulatory.bin key.pub.pem

clean:
	rm -f regulatory.bin key.pub.pem

regulatory.bin: db.txt key.priv.pem
	./db2bin.py regulatory.bin db.txt key.priv.pem

key.pub.pem: key.priv.pem
	openssl rsa -in key.priv.pem -out key.pub.pem -pubout -outform PEM

key.priv.pem:
	openssl genrsa -out key.priv.pem 2048
