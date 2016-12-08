SHELL := /bin/bash

# Dependency Versions
VERSION?=1.3
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
	mkdir -p /usr/share/man/npth/$(VERSION) && \
	./configure \
	    --prefix=/usr/local \
	    --mandir=/usr/share/man/npth/$(VERSION) \
	    --infodir=/usr/share/info/npth/$(VERSION) \
	    --docdir=/usr/share/doc/npth/$(VERSION) && \
	make -j$(CORES) && \
	make install

fpm_debian:
	echo "Packaging libpth for Debian"

	cd /tmp/npth-$(VERSION) && make install DESTDIR=/tmp/libpth-$(VERSION)-install

	fpm -s dir \
		-t deb \
		-n libpth \
		-v $(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2) \
		-C /tmp/libpth-$(VERSION)-install \
		-p libpth_$(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2)_$(shell arch).deb \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/libpth-build \
		--description "libpth" \
		--deb-systemd-restart-after-upgrade

fpm_rpm:
	echo "Packaging libpth for RPM"

	cd /tmp/npth-$(VERSION) && make install DESTDIR=/tmp/libpth-$(VERSION)-install

	fpm -s dir \
		-t rpm \
		-n libpth \
		-v $(VERSION)_$(RELEASEVER) \
		-C /tmp/libpth-$(VERSION)-install \
		-p libpth_$(VERSION)-$(RELEASEVER)_$(shell arch).rpm \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/libpth-build \
		--description "libpth" \
		--vendor "Charles R. Portwood II" \
		--rpm-digest sha384 \
		--rpm-compression gzip
