This dockerfile builds all OpenNebula debian packages from source and
includes them in the /packages/ directory of the resulting image.

It can be used by other dockerfiles to install the needed packages
without rebuilding all OpenNebula packages from scratch.

### Example Dockerfile

```
FROM ethzhpc/opennebula-packages:5.8.4 as builder

FROM ubuntu:18.04

# Install opennebula-node package.
COPY --from=builder /packages/opennebula-node_*.deb /var/cache/apt/archives/
RUN apt-get -y update \
    && apt-get -y install opennebula-node

```
