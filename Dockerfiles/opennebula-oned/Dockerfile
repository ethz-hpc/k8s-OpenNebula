ARG PACKAGE_IMAGE=ethzhpc/opennebula-packages:5.8.5
ARG BASE_IMAGE=ubuntu:18.04

FROM $PACKAGE_IMAGE as builder
FROM $BASE_IMAGE

LABEL maintainer="steven@armstrong.cc"

# Tini as pid 1.
COPY --from=builder /tini /tini
ENTRYPOINT ["/tini", "--"]
CMD ["/bin/bash"]


# Install OpenNebula and ruby gems.
COPY --from=builder /packages /packages
RUN ln -s /packages/repo.list /etc/apt/sources.list.d/opennebula.list
RUN apt-get -y update \
 && apt-get -y install lsb-release opennebula mysql-client less \
 && apt-get -y clean

RUN sed -i 's/apt-get install/apt-get -y install/g' /usr/share/one/install_gems
RUN echo '0\n' | /usr/share/one/install_gems
RUN mkdir -p /var/log/one /var/lock/one
RUN chown oneadmin: /var/log/one /var/lock/one


# Fix: https://github.com/OpenNebula/one/issues/3074
RUN sed -i '/scp -rp/ s|/. |/* |' /usr/lib/one/ruby/CommandManager.rb /usr/lib/one/ruby/cli/one_helper/onehost_helper.rb

# Set a TCP endpoint for libvirt communication
# http://docs.opennebula.org/5.8/deployment/open_cloud_host_setup/kvm_driver.html#opennebula-configuration
#RUN sed -i 's|export LIBVIRT_URI=qemu:///system|export LIBVIRT_URI=qemu+tcp://localhost/system|g' /var/lib/one/remotes/etc/vmm/kvm/kvmrc

USER oneadmin
