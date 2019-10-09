#!/bin/bash
echo 'deleting opennebula from opennebula namspace with helm release name opennebula'
helm delete --purge opennebula
kubectl delete secret -n opennebula opennebula-ssh-keys
kubectl delete secret -n opennebula opennebula-serveradmin
kubectl delete role opennebula-api-access -n opennebula
read -p "Delete PVC (persistence) for mysql? [Yy/Nn] " -n 1 -r
echo   
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo 'Deleting PVC opennebula-mysql '
    kubectl delete pvc -n opennebula opennebula-mysql
fi
