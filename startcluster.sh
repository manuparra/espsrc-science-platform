RED='\033[0;31m'
NC='\033[0m'

echo "Installation of the cluster for spsrc-jupyter.iaa.csic.es"
#curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san spsrc-jupyter.iaa.csic.es" sh -
echo "RUN"
echo "--------------------------------------"
TOKEN=`cat /var/lib/rancher/k3s/server/node-token`
echo "${RED}curl -sfL https://get.k3s.io | K3S_URL=https://192.168.250.132:6443 K3S_TOKEN=${TOKEN} sh -${NC}"
echo "--------------------------------------"
echo "ON all your worker nodes"
echo "Then RUN on Control Plane:" 
echo "--------------------------------------"
echo "${RED}kubectl label node spsrc-k8-clusterXY node-role.kubernetes.io/worker=worker${NC}"
echo "--------------------------------------"
echo "to assing worker role"

