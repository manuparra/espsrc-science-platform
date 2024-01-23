RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}Adding the repository of CANFAR${NC}"
helm repo add science-platform https://images.opencadc.org/chartrepo/platform
sleep 1
echo "${RED}Updating the helm repos ...${NC}"
helm repo update
sleep 1
echo "${RED}Installing science platorm - Base${NC}"
helm upgrade --install base science-platform/base
sleep 1
echo "${RED}Installing science platfor - PosixMapper${NC}"
helm upgrade --install -n skaha-system  --values config/posix-mapper.yaml posixmapper science-platform/posixmapper
sleep 2
echo "${RED}Installing storage${NC}"
kubectl apply -f config/storage-pv-skaha.yaml
kubectl apply -f config/storage-pv-skaha-cavern.yaml
sleep 2
echo "${RED}Installing skaha${NC}"
helm upgrade --install -n skaha-system --values config/skaha.yaml skaha science-platform/skaha
sleep 2
echo "${RED}Installing scienceplatform${NC}"
helm install -n skaha-system --values config/scienceplatform.yaml scienceportal science-platform/scienceportal

