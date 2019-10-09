## Usage

### privileged

```
docker run -d \
   --cap-add SYS_ADMIN \
   -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
   registry.admin.hpc.ethz.ch/hpc/opennebula/opennebula-node:latest
```


### unprivileged

```
docker run -ti --rm \
   --name opennebula-node \
   --tmpfs /tmp \
   --tmpfs /run \
   --tmpfs /run/lock \
   -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
   registry.admin.hpc.ethz.ch/hpc/opennebula/opennebula-node:latest
```


## Kubevirt based init script

TODO: check what is necessary here
```
--net=host \
--pid=host \
--ipc=host \
--user=root \
--privileged \
```

```
docker run -ti --rm \
   --name opennebula-node \
   --tmpfs /tmp \
   --tmpfs /run \
   --tmpfs /run/lock \
   --net=host \
   --user=root \
   --privileged \
   -v /:/host:Z \
   registry.admin.hpc.ethz.ch/hpc/opennebula/opennebula-node:kubevirt
```


**ETHZ - Hpc group 2019**
