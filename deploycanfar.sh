RED='\033[0;31m'
NC='\033[0m'

echo "${RED}Adding the repository of CANFAR and SP-Client${NC}"
echo "${RED}-------------------------------${NC}"
helm repo add science-platform https://images.opencadc.org/chartrepo/platform
helm repo add science-platform-client https://images.opencadc.org/chartrepo/client
sleep 1
echo "${RED}Updating the helm repos ...${NC}"
echo "${RED}-------------------------------${NC}"
helm repo update
sleep 1
echo "${RED}Installing science platorm - Base${NC}"
echo "${RED}-------------------------------${NC}"
helm upgrade --install base science-platform/base
sleep 1
echo "${RED}Installing science platform - PosixMapper${NC}"
echo "${RED}-------------------------------${NC}"
helm upgrade --install -n skaha-system  --values config/posixmapper.yaml posixmapper science-platform/posixmapper
sleep 2
echo "${RED}Installing storage${NC}"
echo "${RED}-------------------------------${NC}"
kubectl apply -f config/storage-pv-skaha.yaml
kubectl apply -f config/storage-pv-skaha-cavern.yaml
sleep 10
echo "${RED}Installing skaha${NC}"
echo "${RED}-------------------------------${NC}"
helm upgrade --install -n skaha-system --values config/skaha.yaml skaha science-platform/skaha
sleep 2
echo "${RED}Installing scienceplatform${NC}"
echo "${RED}-------------------------------${NC}"
helm install -n skaha-system --values config/scienceplatform.yaml scienceportal science-platform/scienceportal
sleep 5
echo "${RED}Installing cavern${NC}"
echo "${RED}-------------------------------${NC}"
helm install -n skaha-system --values config/cavern.yaml cavern science-platform/cavern
sleep 5
echo "${RED}Installing storage-ui${NC}"
echo "${RED}-------------------------------${NC}"
helm -n skaha-system upgrade --dependency-update --install --values config/storage-ui.yaml storageui science-platform-client/storageui
