# mcrouter package builder

This `Dockerfile` will create a `.deb` package for mcrouter.


## Building

To build and copy the package to your local filesystem, run this:

```
$ export MCROUTER_VERSION=`grep "ENV MCROUTER_VERSION" Dockerfile | cut -f3 -d' '`
$ export MCROUTER_SHA=`grep "ENV MCROUTER_SHA" Dockerfile | cut -f3 -d' '`

$ docker build -t mcrouter . && docker create --name=mcrouter-build mcrouter && docker cp mcrouter-build:/tmp/mcrouter-build/install/yammer-mcrouter_${MCROUTER_VERSION}-${MCROUTER_SHA}_amd64.deb . && docker rm -f mcrouter-build
```


## Testing package

```
$ docker run -ti --rm -v `pwd`:/opt/mcrouter-build ubuntu:12.04 /bin/bash
root@6c009d9bcd91:/# dpkg -i /opt/mcrouter-build/yammer-mcrouter_0.9-e1d90728efc109f1c7258d36b641264a56bd04a8_amd64.deb
root@6c009d9bcd91:/# mcrouter --help
```
