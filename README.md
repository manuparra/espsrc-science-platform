# Installation on k3s production

Within the Main node:

`curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -`

Worker nodes:

`curl -sfL https://get.k3s.io | K3S_URL=https://<Main node ip>:6443 K3S_TOKEN=mynodetoken sh -`

Where mynodetoken is in: `/var/lib/rancher/k3s/server/node-token`

From the main node, add the label to the nodes to select then as workers:

``
kubectl label nodes <rancher01> node-role.kubernetes.io/worker=
kubectl label nodes <rancher02> node-role.kubernetes.io/worker=
``

Install HELM

``
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
``

# Instalation of CANFAR

TBC.
