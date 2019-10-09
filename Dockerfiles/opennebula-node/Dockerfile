ARG PACKAGE_IMAGE=ethzhpc/opennebula-packages:5.8.5
ARG BASE_IMAGE=ethzhpc/ubuntu-systemd:0.0.1

FROM $PACKAGE_IMAGE as builder
FROM $BASE_IMAGE

LABEL maintainer="steven@armstrong.cc"

# Install opennebula-node and dependencies.
COPY --from=builder /packages /packages
RUN ln -s /packages/repo.list /etc/apt/sources.list.d/opennebula.list
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
       openssh-server \
       dmidecode ebtables bridge-utils sudo netcat-openbsd kmod \
       augeas-tools \
       opennebula-node \
    && rm -f /etc/libvirt/qemu/networks/autostart/default.xml \
    && apt-get -y clean

# Delete the ssh related files that opennebula-node generated.
RUN rm -rf /var/lib/one/.ssh/authorized_keys \
    && rm -rf /var/lib/one/.ssh/id_rsa \
    && rm -rf /var/lib/one/.ssh/id_rsa.pub

# Ensure systemd-user-sessions is started, usually done by getty.
RUN mkdir -p /etc/systemd/system/ssh.service.d \
    && printf '[Unit]\n\
Wants=systemd-user-sessions.service\n\
After=systemd-user-sessions.service\n' > /etc/systemd/system/ssh.service.d/after-systemd-user-sessions.conf


# Enable wanted systemd services
RUN systemctl enable ssh.service \
    && systemctl enable libvirtd.service


# 20190930/asteven: first make it work with unix socket.
## Configure libvirt to listen on tcp socket.
#RUN echo 'libvirtd_opts="-l"' >> /etc/default/libvirtd \
#    && printf 'listen_tls = 0\n\
#listen_tcp = 1\n\
#listen_addr = "127.0.0.1"\n\
#tcp_port = "16509"\n\
#auth_tcp = "none"\n' >> /etc/libvirt/libvirtd.conf


# Configure sshd to listen on non-standard port.
ENV SSHD_PORT=2022
RUN sed -i \
    -e "s/#Port 22/Port $SSHD_PORT/g" \
    -e 's/#PasswordAuthentication yes/PasswordAuthentication no/g' \
    /etc/ssh/sshd_config


# TODO: investigate if/how we can use augeas to configure services instead
#   of sed/awk and friends.
# Configure services.
#COPY augconf /augconf
#RUN augtool -f /augconf


RUN rm -f /sbin/init
ADD pre-init /sbin/init
RUN chmod a+x /sbin/init
