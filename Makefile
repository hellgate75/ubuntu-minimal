PREFIX ?= /tmp/ubuntu-minimal-build
VERSION ?= $(tag)

all: install

install:
	mkdir -p ./build/$(VERSION)/$(PREFIX)/bin
	cp bin/ubuntu-minimal ./build/$(VERSION)/$(PREFIX)/bin/ubuntu-minimal
	chmod 755 ./build/$(VERSION)/$(PREFIX)/bin/ubuntu-minimal
	install -m 0755 make-docker-wrapper.sh ./build/$(VERSION)/$(PREFIX)/bin/make-docker-wrapper

uninstall:
	@$(RM) ./build/$(VERSION)/$(PREFIX)/bin/ubuntu-minimal
	@docker rmi hellgate75/ubuntu-minimal:$(VERSION)
	@docker rmi hellgate75/ubuntu-minimal:latest

build:
#	@docker build -t hellgate75/ubuntu-minimal:$(VERSION) . \
	&& docker tag -f hellgate75/ubuntu-minimal:$(VERSION) hellgate75/ubuntu-minimal:latest
	./build/$(VERSION)/$(PREFIX)/bin/make-docker-wrapper $(VERSION) "tail -f /dev/null" &&
	docker tag -f hellgate75/ubuntu-minimal:$(VERSION) hellgate75/ubuntu-minimal:latest

publish: build
	@docker push hellgate75/ubuntu-minimal:$(VERSION) \
	&& docker push hellgate75/ubuntu-minimal:latest

.PHONY: all install uninstall build publish
