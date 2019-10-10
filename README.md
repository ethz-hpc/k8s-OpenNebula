# Opennebula
opennebula @ kuberenetes

# requierments

* Helm 
* Helmfile (optional)
* Kuberenetes +1.10 (tested on 1.16)

# Recommended

* NFS for the datasotarages (system + images)


# Installation

    cd Chart && helmfile sync

helmfile will install the local chart in `opennebula` namespace.

with helm 

    helm install -n opennebula --namespace opennebula chart/

# Auto ssh keys

SSH Keys could be automatically created on helm install. 

Enable (on values.yaml) `auto_ssh` to create ssh keys secrets before install the chart. (templates/auto-)
If you disable this you can run `./createSshkeys.sh` before creating the chart or create them manually.
(Note, by default this will push to 'opennebula' namespace)
 
### Auto serveradmin

Because serveradmin user is created  by Onedeamon (opennebula core process) we need to create a secret in runtime from that.
Enable `auto_serveradmin_secret` to create the secret from the oned container.

## datastores

Enable in values datasteres to create a PVC.
For now, its needed to create the datastores in the UI or in the cli matching the id's. Dont create one before so the ids starts on 100, 101. 
http://docs.opennebula.org/5.8/deployment/open_cloud_storage_setup/fs_ds.html#shared-qcow2-transfer-modes

```
>cat ds.conf
NAME   = nfs_images
DS_MAD = fs
TM_MAD = shared
>onedatastore create ds.conf
```


We are working on OneProvision. 
- [ ] create [provision template](http://docs.opennebula.org/5.8/advanced_components/ddc/reference/provision/overview.html#ddc-provision-template) and applyit as a poststart
http://docs.opennebula.org/5.8/advanced_components/ddc/usage.html

## Secure Opennebula.

Its tested to work with ssl termination at traefik ingress with cert manager.
For installing cert-manager with helmfile: https://github.com/zakkg3/cert-manager-installer (official cert-manger documentation)
https://docs.cert-manager.io/en/latest/getting-started/install/kubernetes.html#alternative-installation-methods



## how Upload an image if you dont have internet access :

For now, until we implement something better: `scp` your image to where oned StatefulSet is running. 
To get the node where it is running:

    kubectl get pods -n opennebula -l app=opennebula-oned -o wide

Use `findmnt` to find the path where the "data" emptyDir is in that node and put your image there.
This data volume is mounted on oned container on `/var/tmp`, so now you can create a new image from host path /var/temp/tourimage.qcow2

*Tested on qcow2 images.*

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

- Appmarket
- gate

Writing ***OneOperator*** to:
 * When new node is running (now k8s node with the desire label) add it into the Opennebula cluster.
 * If a node is not available, disable it in Opennebula cluster to stop scheduling things there.
 * If a node is going down as a prestop hook: drain opennebula node (move Vm's) before it stop: With this we can change the Nodes demonset to updateStrategy: Rollingupdate (now is OnDelete)
 
 
 ## Colaborate
 
 * DCO: Please open pull request with your commits signed (git commit -s)
 * Better exlicit than implici
 
 
 ### Authors

 *ETH Zurich*, High performance computing team.
 
 * **Nicolas Kowenski**: nicokowe at gmail
 * **Steven Armnstrong**: steven at armstrong.cc 
 
 
 
 
