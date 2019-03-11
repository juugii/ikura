NAME=Ikura
VERSION="1.0"
AUTHOR="Jules GILET"
SHELL := /usr/bin/env bash

PREFIX?=/usr/local

DIRS=sources
INSTALL_DIRS=`find $(DIRS) -type d 2>/dev/null`
INSTALL_FILES=`find $(DIRS) -type f 2>/dev/null` dependencies.txt ikura 
DOC_FILES=*.md

include dependencies.txt
include sources/pydep
include sources/requirements.txt

DEP=dependencies.txt
PYDEP=./sources/pydep
REQ=./sources/requirements.txt

PYPATH=$(shell which python3.6)

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

DOC_DIR=$(PREFIX)/share/doc/$(PKG_NAME)


pkg:
	mkdir -p $(PKG_DIR)

$(PKG): pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

build: $(PKG)

$(SIG): $(PKG)
	gpg --sign --detach-sign --armor $(PKG)

sign: $(SIG)

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

tag:
	git tag v$(VERSION)
	git push --tags

release: $(PKG) $(SIG) tag


install_pydep: $(REQ) $(PYPATH)

	$(shell dirname $(PYPATH))/pip3.6 install -r $(REQ)

install: install_pydep

	for dir in $(INSTALL_DIRS); do mkdir -p $(PREFIX)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(PREFIX)/$$file; done
	mkdir -p $(DOC_DIR)
	cp -r $(DOC_FILES) $(DOC_DIR)/
	@echo "Successfully installed Ikura."

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(PREFIX)/$$file; done
	rm -rf $(DOC_DIR)


.PHONY: build sign clean test tag release install_pydep install uninstall all
