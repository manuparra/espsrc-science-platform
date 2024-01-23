# CANFAR Science platform deployment

## Install HELM

On the `control-plane` node: 

``
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
``

Include `KUBECONFIG` in order to use helm properly: 

```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```


## Start with a clean environment

To start with a clean CANFAR environment, run the next. It will remove all the namespaces related with CANFAR:

```
sh ./uninstall.sh
```

Then delete the installation of K8s for each node (if you have a current deployment)

On the control-plane:

```
/usr/local/bin/k3s-uninstall.sh
```

On the worker nodes:

```
/usr/local/bin/k3s-agent-uninstall.sh
```

## Instalation of K8s Cluster on K3S

First, include `KUBECONFIG` in order to use helm properly:

```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

This step will create a cluster with one control plane and `n`  worker nodes. Change the values of 

- ``--tls-san spsrc-jupyter.iaa.csic.es`` by your IP/FQDN, ie: 192.168.100.20 or mycomputer.local, etc,
- ``https://192.168.250.132`` by your control-plane host, ie: https://192.168.100.20

```
sh ./startcluster.sh
```

Then follow the instructions of the script and paste the command within the rest of the nodes of your infrastructure.

## Deployment of CANFAR

Run then next command and change the proper values:


``
sh ./deploycanfar.sh
``

It will take a few minutes and then all the services will be deployed on the cluster.

## Validation of the services deployed

Run the next:

```
kubectl get ingresses -n skaha-system
NAME                     CLASS     HOSTS                       ADDRESS                          PORTS   AGE
posix-mapper-ingress     traefik   spsrc-jupyter.iaa.csic.es   192.168.250.132,192.168.250.34   80      9h
science-portal-ingress   traefik   spsrc-jupyter.iaa.csic.es   192.168.250.132,192.168.250.34   80      9h
skaha-ingress            traefik   spsrc-jupyter.iaa.csic.es   192.168.250.132,192.168.250.34   80      9h
cavern-ingress           traefik   spsrc-jupyter.iaa.csic.es   192.168.250.132,192.168.250.34   80      9h
storage-ui-ingress       traefik   spsrc-jupyter.iaa.csic.es   192.168.250.132,192.168.250.34   80      26m
```

List of services and enpoints exposed within the LoadBalancer on `192.168.250.132,192.168.250.34, ...`:

- `posix-mapper-ingress` service is exposed on `/posix-mapper`
- `science-portal-ingress` service is exposed on `/science-portal`
- `skaha-ingress` service is exposed on `/skaha`
- `cavern-ingress` service is exposed on `/cavern`
- `storage-ui` service is exposed on `/storage`

## External EndPoint

In order to access to the services exposed we will use APACHE to do it as a Proxy that redirect traffic from Internet to the Internal LoadBalancer on the K8S cluster.

This is an example for one of the services (it needs to be done for each endpoint indicated within the above section):

```
  ...
  RewriteCond %{HTTP:Connection} Upgrade [NC]
  RewriteCond %{HTTP:Upgrade} websocket [NC]
  ProxyPreserveHost on
  RewriteRule /storage/(.*) ws://192.168.250.132/storage/$1 [NE,P,L]
  RewriteRule /storage/(.*)  http://192.168.250.132/storage/$1 [NE,P,L]
  ProxyPass /storage/ http://192.168.250.132/storage/
  ProxyPassReverse /storage/ http://192.168.250.132/storage/
  ...
```




