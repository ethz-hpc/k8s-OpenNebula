# Opennebula control plane Chart.




## install

You can run in this folder (.)

    helm install -n opennebula --namespace opennebula . 

or you can run with [helmfile](https://github.com/roboll/helmfile) :

    helmfile sync

## Automatic secrets creation.

This chart will create 2 secrets if you enable this on the values file.
This secrets are not being tracked by helm, so if you want to reinstall the chart you will need to delete them, see the "garbage collector" topic above.

## Create SSH KEYS.
https://kubernetes.io/docs/concepts/configuration/secret/#use-case-pod-with-ssh-keys

This can be done by:
* enabling auto_ssh in values.yaml
* running ./createSshkeys.ch
* running this:

```bash

kubectl create namespace opennebula

mkdir opennebula-ssh-keys
ssh-keygen -f opennebula-ssh-keys/id_rsa -C oneadmin -P ''
cat opennebula-ssh-keys/id_rsa.pub > opennebula-ssh-keys/authorized_keys

cat > opennebula-ssh-keys/config <<EOT
Host *
    LogLevel ERROR
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    GSSAPIAuthentication no
    User oneadmin
EOT

kubectl create secret generic -n opennebula opennebula-ssh-keys --from-file=opennebula-ssh-keys
```

## Automate serveradmin user.

The `serveradmin` user is a special username only used for sunstone and other services. It's not for final users.
This username is created on bootstrap by onedeamon and its not possible at the moment to pre mount a secret.
Enable `auto_serveradmin_secret` in values file to make this chart automate the creation of the secret for serveradmin 
from the onedeamon's `/var/lib/one/.one/sunstone_auth`


To restart sunstone after creating the secret:
https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.10/#delete-58
https://docs.openshift.com/container-platform/3.7/rest_api/api/v1.Pod.html#curl-request-11

## Garbage collector

as this chart is creating some resources automatically, helm is not tracking them:

* opennebula-ssh-keys (secret)
* opennebula-server  (secret)
* opennebula-api (role)

For delete evertihing related with opennebula helm deploy please delete it  manually, or if you installed it in opennebula namespace (default in helmfile) you can use the secript ./deleteall.sh


## Create registry secret.

This helper script will copy the "regcred" secret from kube-system

 run `./createRegCredSecret.sh`
 

# TODO 

- [ ] HA onedeamon.
   http://docs.opennebula.org/5.8/advanced_components/ha/frontend_ha_setup.html#opennebula-ha-setup

- [ ] health check
   http://docs.opennebula.org/5.8/advanced_components/ha/frontend_ha_setup.html#checking-cluster-health

- [ ] ./delete as preuninstall hook.
- [ ] randpassword for oneadmin
- [ ] rndpassword for mysql (include in configmap?) - maybenot.
- [ ] terraform create a cluster with opennebula vm. https://github.com/smangelkramer/one-kubespray
