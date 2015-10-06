FROM ubuntu:12.04
MAINTAINER Brian Morton "bmorton@yammer-inc.com"

ENV MCROUTER_VERSION 0.9
ENV MCROUTER_SHA e1d90728efc109f1c7258d36b641264a56bd04a8
ENV FOLLY_SHA f63b080574f6a139c952fe2a0c06f16fdf170042

# Install tools needed by install scripts below
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -y update && apt-get -y install curl sudo wget

# Download folly and mcrouter packages
WORKDIR /tmp
RUN curl -L https://github.com/facebook/folly/archive/${FOLLY_SHA}.tar.gz | tar xvz
RUN curl -L https://github.com/facebook/mcrouter/archive/${MCROUTER_SHA}.tar.gz | tar xvz

# Build folly, a dependency of mcrouter
WORKDIR /tmp/folly-${FOLLY_SHA}/folly
RUN apt-get -y update && ./build/deps_ubuntu_12.04.sh
RUN apt-get -y install libboost-program-options1.54-dev
RUN autoreconf -ivf && ./configure
RUN make -j4
RUN make install

# Build mcrouter and other dependencies
WORKDIR /tmp/mcrouter-${MCROUTER_SHA}/mcrouter
ENV LDFLAGS -Wl,-rpath=/usr/local/lib/mcrouter/
ENV LD_LIBRARY_PATH /usr/local/lib/mcrouter/
RUN mkdir /tmp/mcrouter-build && ./scripts/install_ubuntu_12.04.sh /tmp/mcrouter-build -j4

# Install Ruby so we can install fpm for building the Debian package
RUN add-apt-repository ppa:brightbox/ruby-ng
RUN apt-get -y update && apt-get -y install ruby2.1 ruby2.1-dev
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install fpm

# Copy all dependencies and build the Debian package
WORKDIR /tmp/mcrouter-build/install
ADD /create_package.sh /tmp/mcrouter-build/install/create_package.sh
RUN curl -L https://github.com/bmorton/futhark/raw/master/sh/cpld.bash -o /tmp/mcrouter-build/install/copy_deps.sh && chmod +x /tmp/mcrouter-build/install/copy_deps.sh
RUN ./create_package.sh ${MCROUTER_VERSION}-${MCROUTER_SHA}
