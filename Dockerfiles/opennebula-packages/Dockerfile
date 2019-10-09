FROM ubuntu:18.04 as builder

LABEL maintainer="steven@armstrong.cc"

# Override in Makefile
ARG VERSION=5.8.5

# Install build dependencies
RUN apt-get update \
    && apt-get -y install \
       pbuilder debhelper ubuntu-dev-tools bash-completion \
       bison default-jdk flex javahelper libxmlrpc3-client-java \
       libxmlrpc3-common-java libxml2-dev ruby scons dh-systemd \
       npm ruby-ronn rename dpkg-dev

# Download sources
WORKDIR /
ADD https://github.com/OpenNebula/one/archive/release-$VERSION.tar.gz /one-release-$VERSION.tar.gz
RUN tar -xzf one-release-$VERSION.tar.gz \
    && mv one-release-$VERSION opennebula-$VERSION

WORKDIR /opennebula-$VERSION

# TODO: patch not fully functional yet
# Apply patch from https://github.com/OpenNebula/one/issues/3768
#ADD bug-3768.patch /tmp/
#RUN patch -p0 < /tmp/bug-3768.patch

# Make docs
RUN cd share/man \
    && ./build.sh

# Make sunstone
RUN cd src/sunstone/public \
    && ./build.sh -d \
    && export PATH=$PATH:$PWD/node_modules/.bin \
    && ./build.sh \
    && rm -rf node_modules/

# Prepare packages
WORKDIR /
ADD https://github.com/OpenNebula/packages/archive/release-$VERSION.tar.gz /packages-release-$VERSION.tar.gz
RUN tar -xzf packages-release-$VERSION.tar.gz \
    && mv packages-release-$VERSION /packages-$VERSION

WORKDIR /packages-$VERSION
RUN tar -czf /opennebula-$VERSION.tar.gz /opennebula-$VERSION/
RUN sed -i '/^debuild/,$ s/^/#/' ubuntu1804.sh \
    && ./ubuntu1804.sh /opennebula-$VERSION.tar.gz

# Build packages
WORKDIR /root/build-Ubuntu-18.04/opennebula-$VERSION
RUN apt-get -y install $(dpkg-checkbuilddeps 2>&1 | sed 's/.*Unmet build dependencies: //') \
 && echo build_opennebula.tar.gz >> debian/source/include-binaries \
 && echo xmlrpc-c.tar.gz >> debian/source/include-binaries \
 && dpkg-buildpackage -us -uc \
 && mkdir -p /packages \
 && mv /root/build-Ubuntu-18.04/*.deb /packages/

RUN cd /packages; dpkg-scanpackages -m . > Packages \
 && echo 'deb [trusted=yes] file:///packages/ ./' > /packages/repo.list


# Include tini for use as pid 1.
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 \
 && gpg --batch --verify /tini.asc /tini
RUN chmod +x /tini


FROM ubuntu:18.04

# Add tini.
COPY --from=builder /tini /tini

# Add all opennebula packages.
COPY --from=builder /packages/* /packages/

# Show the packages that we have built.
RUN ls -al /packages/

RUN cat /packages/repo.list
