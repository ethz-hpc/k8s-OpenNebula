ARG PACKAGE_IMAGE=ethzhpc/opennebula-packages:5.8.5
ARG BASE_IMAGE=ethzhpc/ubuntu-systemd:0.0.1

FROM $PACKAGE_IMAGE as builder
FROM $BASE_IMAGE

LABEL maintainers="steven@armstrong.cc,nicokowe@gmail.com"



# Install OpenNebula and ruby gems.
COPY --from=builder /packages /packages
RUN cat /packages/repo.list
RUN ln -s /packages/repo.list /etc/apt/sources.list.d/opennebula.list
RUN apt-get -y update \
 && ln -s /bin/true /usr/local/bin/systemd-tmpfiles \
 && apt-get -y install lsb-release libcurl4-openssl-dev libmysqlclient-dev \
      opennebula-sunstone \
      logrotate \
 && rm -f /usr/local/bin/systemd-tmpfiles \
 && apt-get -y clean

RUN sed -i 's/apt-get install/apt-get -y install/g' /usr/share/one/install_gems
RUN echo '0\n' | /usr/share/one/install_gems sunstone
RUN umask 022; mkdir -p /var/log/one /var/lock/one
RUN chown oneadmin: /var/log/one /var/lock/one


## Logging to /dev/stdout, do not daemonize novnc-server
#RUN sed -i 's|^\(SUNSTONE_LOG *=\).*|\1 "/dev/stdout"|' /usr/lib/one/sunstone/sunstone-server.rb \
# && sed -i 's|^\(VNC_LOG *=\).*|\1 "/dev/stdout"|' /usr/bin/novnc-server \
# && sed -i '/cmd *=/a\        exec(cmd)' /usr/lib/one/ruby/OpenNebulaVNC.rb


# Enable wanted systemd services
ADD opennebula-novnc-wrapper /usr/bin/
RUN chmod 0755 /usr/bin/opennebula-novnc-wrapper
ADD opennebula-novnc.service /etc/systemd/system/
RUN systemctl enable opennebula-novnc.service

ADD opennebula-sunstone-logger.service /etc/systemd/system/
RUN systemctl enable opennebula-sunstone-logger.service
RUN systemctl enable opennebula-sunstone.service

# Debug enabled OpenNebulaVNC.rb
#ADD OpenNebulaVNC.rb /usr/lib/one/ruby/OpenNebulaVNC.rb
