UBUNTU_RELEASE = "14.04"
MCROUTER_VERSION = $(shell git ls-remote --tags https://github.com/facebook/mcrouter.git | sort -t '/' -k 3 -V | tail -n1 | awk '{print $$1}')
MCROUTER_SHA = $(shell git ls-remote --tags https://github.com/facebook/mcrouter.git | sort -t '/' -k 3 -V | tail -n1 | awk '{print $$2}' | awk -F\/ '{print $$3}')

.PHONY: all build cp

all: build cp

build:
	sed "s/__UBUNTU_RELEASE__/${UBUNTU_RELEASE}/g" Dockerfile > Dockerfile-${UBUNTU_RELEASE}
	sed -i "s/__MCROUTER_VERSION__/${MCROUTER_VERSION}/g" Dockerfile-${UBUNTU_RELEASE}
	sed -i "s/__MCROUTER_SHA__/${MCROUTER_SHA}/g" Dockerfile-${UBUNTU_RELEASE}
	docker build -t mcrouter -f Dockerfile-${UBUNTU_RELEASE} .

cp:
	mkdir -p ./${UBUNTU_RELEASE}
	docker create --name=mcrouter-build mcrouter && docker cp mcrouter-build:/tmp/mcrouter-build/install/yammer-mcrouter_${MCROUTER_VERSION}-${MCROUTER_SHA}_amd64.deb . && docker rm -f mcrouter-build

test:
	docker run -ti --rm -v `pwd`:/opt/mcrouter-build ubuntu:${UBUNTU_RELEASE} sh -c "dpkg -i /opt/mcrouter-build/yammer-mcrouter_${MCROUTER_VERSION}-${MCROUTER_SHA}_amd64.deb; mcrouter --version; /bin/bash"

clean:
		rm -f Dockerfile-*
