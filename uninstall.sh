RED='\033[0;31m'
NC='\033[0m'

helm uninstall base
helm uninstall posixmapper
helm uninstall skaha
helm uninstall science-platform
echo "${RED}No skaha-system pods installed ...${NC}"
kubectl get all -n skaha-system
echo "${RED}Deleting Storage ...${NC}"
kubectl delete pv science-platform-volume
kubectl delete pv science-platform-cavern-volume

