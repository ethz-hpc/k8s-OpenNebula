#!/bin/bash
#set -x
if kubectl get secret regcred -n opennebula ; then
  echo 'The secret is already there, doing nothing'
  exit 0
else
kubectl get secret regcred -n kube-system -o yaml | sed s/"namespace: kube-system"/"namespace: opennebula"/ | kubectl apply -n opennebula -f -
fi
