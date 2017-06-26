PREFIX ?= /usr/local
VERSION = "v0.0.1"

all: install

install:
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp bin/ubuntu-minimal $(DESTDIR)$(PREFIX)/bin/ubuntu-minimal
	chmod 755 $(DESTDIR)$(PREFIX)/bin/ubuntu-minimal
	install -m 0755 make-docker-wrapper.sh $(DESTDIR)$(PREFIX)/bin/make-docker-wrapper

uninstall:
	@$(RM) $(DESTDIR)$(PREFIX)/bin/ubuntu-minimal
	@docker rmi hellgate75/ubuntu-minimal:$(VERSION)
	@docker rmi hellgate75/ubuntu-minimal:latest

build:
#	@docker build -t hellgate75/ubuntu-minimal:$(VERSION) . \
	&& docker tag -f hellgate75/ubuntu-minimal:$(VERSION) hellgate75/ubuntu-minimal:latest
	$(DESTDIR)$(PREFIX)/bin/make-docker-wrapper $(VERSION) "tail -f /dev/null" &&
	docker tag -f hellgate75/ubuntu-minimal:$(VERSION) hellgate75/ubuntu-minimal:latest

publish: build
	@docker push hellgate75/ubuntu-minimal:$(VERSION) \
	&& docker push hellgate75/ubuntu-minimal:latest

.PHONY: all install uninstall build publish
