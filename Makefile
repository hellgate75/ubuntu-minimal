PREFIX ?= ubuntu-minimal-build
VERSION ?= $(tag)

all: install build publish

install:
	rm -Rf ./build/$(VERSION)
	mkdir -p ./build/$(VERSION)/$(PREFIX)/bin
	cp bin/ubuntu-minimal ./build/$(VERSION)/$(PREFIX)/bin/ubuntu-minimal
	chmod 777 ./build/$(VERSION)/$(PREFIX)/bin/ubuntu-minimal
	install -m 0777 make-docker-wrapper.sh ./build/$(VERSION)/$(PREFIX)/bin/make-docker-wrapper

uninstall:
	@$(RM) ./build/$(VERSION)/$(PREFIX)/bin/ubuntu-minimal
	@docker rmi hellgate75/ubuntu-minimal:$(VERSION)
	@docker rmi hellgate75/ubuntu-minimal:latest

build:
#	@docker build -t hellgate75/ubuntu-minimal:$(VERSION) . \
	&& docker tag -f hellgate75/ubuntu-minimal:$(VERSION) hellgate75/ubuntu-minimal:latest
	@echo "Building version $(VERSION)"
	./build/$(VERSION)/$(PREFIX)/bin/make-docker-wrapper $(VERSION) "tail -f /dev/null" \
	&& docker tag hellgate75/ubuntu-minimal:$(VERSION) hellgate75/ubuntu-minimal:latest \


publish:
	@docker push hellgate75/ubuntu-minimal:$(VERSION) \
	&& docker push hellgate75/ubuntu-minimal:latest

.PHONY: all install uninstall build publish
