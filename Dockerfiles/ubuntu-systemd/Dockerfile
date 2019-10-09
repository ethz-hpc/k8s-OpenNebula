FROM ubuntu:18.04

LABEL maintainer="steven@armstrong.cc"

ENV container docker
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

VOLUME ["/sys/fs/cgroup"]

# systemd wants SIGRTMIN+3 instead of SIGTERM on `docker stop`
# see https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/
STOPSIGNAL RTMIN+3
ENTRYPOINT ["/sbin/init"]

# Install and configure systemd.
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install systemd libpam-systemd socat \
    && apt-get -y clean

# Remove unneeded systemd stuff.
RUN cd /lib/systemd/system/sysinit.target.wants/ \
    && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1
RUN rm -f /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*


# Configure journald to log directly to console with gives us the logs on stdout.
RUN sed -i -e 's|#ForwardToConsole=no|ForwardToConsole=yes|g' /etc/systemd/journald.conf
# Make systemd output more docker/syslog friendly.
RUN sed -i -e 's|#LogColor=yes|LogColor=no|' \
   -e 's|#ShowStatus=yes|ShowStatus=no|' /etc/systemd/system.conf


# Workaround to ensure that journald sends his logs to /dev/console.
#  https://github.com/systemd/systemd/pull/4262#issuecomment-353062592
RUN rm -f /sbin/init
ADD init-console /sbin/init
RUN chmod a+x /sbin/init


RUN echo "LANG=en_US.UTF-8" > /etc/default/locale

