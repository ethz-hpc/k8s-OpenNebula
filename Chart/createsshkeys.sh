#!/bin/bash
echo 'Creating keys and pushing to kubernetes cluster'
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

echo 'Deleting secrets from local machine'
rm -rf opennebula-ssh-keys

echo 'Set sshKey: ok in values file'
sed -i ''  's/sshKeys: nok/sshKeys: ok/g' values.yaml
echo 'Done, you have this secrets now:'
kubectl get secrets --namespace opennebula
