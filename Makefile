VERSION = `grep "ENV MCROUTER_VERSION" Dockerfile | cut -f3 -d' '`
SHA = `grep "ENV MCROUTER_SHA" Dockerfile | cut -f3 -d' '`
RELEASE = `grep "ENV RELEASE" Dockerfile | cut -f3 -d' '`

.PHONY: all build cp

all: build cp 

build:
	sed "1 s/__RELEASE__/${RELEASE}/" Dockerfile > Dockerfile-${RELEASE}
	docker build -t mcrouter -f Dockerfile-${RELEASE} .

cp:
	mkdir ./${RELEASE}
	docker create --name=mcrouter-build mcrouter && docker cp mcrouter-build:/tmp/mcrouter-build/install/yammer-mcrouter_${VERSION}-${SHA}_amd64.deb ./${RELEASE}/yammer-mcrouter_${VERSION}-${SHA}_amd64.deb && docker rm -f mcrouter-build

test:
	docker run -ti --rm -v `pwd`:/opt/mcrouter-build ubuntu:${RELEASE} sh -c "dpkg -i /opt/mcrouter-build/yammer-mcrouter_${VERSION}-${SHA}_amd64.deb; mcrouter --version; /bin/bash"

clean:
	rm -f Dockerfile-*
