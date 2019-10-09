# Opennebula
opennebula @ kuberenetes

# requierments

* Helm + Helmfile
* Kuberenetes +1.10 (tested on 1.16)

# Recommended

* NFS for the datasotarages (system + images)


# Installation

    cd Chart && helmfile sync

helmfile will install the local chart in `opennebula` namespace.


# Auto ssh keys

SSH Keys could be automatically created on helm install. 

Enable (on values.yaml) `auto_ssh` to create ssh keys secrets before install the chart. (templates/auto-)
If you disable this you can run `./createSshkeys.sh` before creating the chart or create them manually.
(Note, by default this will push to 'opennebula' namespace)
 
### Auto serveradmin

Because serveradmin user is created  by Onedeamon (opennebula core process) we need to create a secret in runtime from that.
Enable `auto_serveradmin_secret` to create the secret from the oned container.



## how Upload an image :

For now, until we implement something better: `scp` your image to where oned StatefulSet is running. to get the node:

    kubectl get pods -n opennebula -l app=opennebula-oned -o wide

Use `findmnt` to find the path where the "data" emptyDir is in that node and put your image there.
This data volume is mounted on oned container on `/var/tmp`, so now you can create a new image from host path /var/temp/tourimage.qcow2

Tested on qcow2 images.



# Uninstall Opennebula 

    cd Chart && helmfile destroy
    
to delete the secrets created by this chart (not tracked by Helm)

    kubectl delete ns opennebula



### secrets 
If you enabled the `auto_ssh` or `auto_serveradmin_secret`, this resources are not being tracked by helm, so if you delete with `helm delete` the secret will still be there. 

### Mysql PVC:
By default in the values the mysql pvc have the annotation keep, to not delete it if we uninstall the chart.

you can run `./deleteall.sh` to make shure nothing is there. You can also remove the namespace, named 'openbnebula' in the helmfile.


## On development:
Writing ***OneOperator*** to:
 * When new node is running (now k8s node with the desire label) add it into the Opennebula cluster.
 * If a node is not available, disable it in Opennebula cluster to stop scheduling things there.
 * If a node is going down as a prestop hook: drain opennebula node (move Vm's) before it stop: With this we can change the Nodes demonset to updateStrategy: Rollingupdate (now is OnDelete)
