FROM ubuntu:__UBUNTU_RELEASE__
MAINTAINER Brian Morton "bmorton@yammer-inc.com"

ENV MCROUTER_VERSION __MCROUTER_VERSION__
ENV MCROUTER_SHA __MCROUTER_SHA__
ENV UBUNTU_RELEASE __UBUNTU_RELEASE__

# Install tools needed by install scripts below
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -y update && apt-get -y install curl sudo wget build-essential

# Download mcrouter
WORKDIR /tmp
RUN curl -L https://github.com/facebook/mcrouter/archive/${MCROUTER_SHA}.tar.gz | tar xvz

# Build mcrouter
WORKDIR /tmp/mcrouter-${MCROUTER_SHA}/mcrouter
ENV LDFLAGS -Wl,-rpath=/usr/local/lib/mcrouter/
ENV LD_LIBRARY_PATH /usr/local/lib/mcrouter/
RUN mkdir /tmp/mcrouter-build && ./scripts/install_ubuntu_${UBUNTU_RELEASE}.sh /tmp/mcrouter-build

# Install Ruby so we can install fpm for building the Debian package
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:brightbox/ruby-ng
RUN apt-get -y update && apt-get -y install ruby2.1 ruby2.1-dev
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install fpm

# Copy all dependencies and build the Debian package
WORKDIR /tmp/mcrouter-build/install
ADD /create_package.sh /tmp/mcrouter-build/install/create_package.sh
RUN curl -L https://github.com/bmorton/futhark/raw/master/sh/cpld.bash -o /tmp/mcrouter-build/install/copy_deps.sh && chmod +x /tmp/mcrouter-build/install/copy_deps.sh
RUN ./create_package.sh ${MCROUTER_VERSION}-${MCROUTER_SHA}
