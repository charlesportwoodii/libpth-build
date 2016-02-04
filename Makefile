SHELL := /bin/bash

# Dependency Versions
VERSION?=1.2
RELEASEVER?=1

# Bash data
SCRIPTPATH=$(shell pwd -P)
CORES=$(shell grep -c ^processor /proc/cpuinfo)
RELEASE=$(shell lsb_release --codename | cut -f2)

major=$(shell echo $(VERSION) | cut -d. -f1)
minor=$(shell echo $(VERSION) | cut -d. -f2)
micro=$(shell echo $(VERSION) | cut -d. -f3)


build: clean libpth

clean:
	rm -rf /tmp/npth-$(VERSION).tar.bz2
	rm -rf /tmp/npth-$(VERSION)

libpth:
	cd /tmp && \
	wget ftp://ftp.gnupg.org/gcrypt/npth/npth-$(VERSION).tar.bz2 && \
	tar -xf npth-$(VERSION).tar.bz2 && \
	cd npth-$(VERSION) && \
	mkdir -p /usr/share/man/npth-$(VERSION) && \
	./configure \
	    --prefix=/usr/local \
	    --mandir=/usr/share/man/npth-$(VERSION) \
	    --infodir=/usr/share/info/npth-$(VERSION) \
	    --docdir=/usr/share/doc/npth-$(VERSION) && \
	make -j$(CORES) && \
	make install

package:
	cd /tmp/npth-$(VERSION) && \
	checkinstall \
	    -D \
	    --fstrans \
	    -pkgrelease "$(RELEASEVER)"-"$(RELEASE)" \
	    -pkgrelease "$(RELEASEVER)"~"$(RELEASE)" \
	    -pkgname "libpth" \
	    -pkglicense GPLv3 \
	    -pkggroup GPG \
	    -maintainer charlesportwoodii@ethreal.net \
	    -provides "npth-$(VERSION)" \
	    -pakdir /tmp \
	    -y