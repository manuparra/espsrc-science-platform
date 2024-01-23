helm uninstall base
helm uninstall posixmapper
helm uninstall skaha
echo "No skaha-system pods installed ..."
kubectl get all -n skaha-system
echo "Adding the repository of CANFAR"
helm repo add science-platform https://images.opencadc.org/chartrepo/platform
echo "Updating the helm repos ..."
helm repo update
echo "Installing science platorm - Base"
helm upgrade --install base science-platform/base
echo "Installing science platfor - PosixMapper"
helm upgrade --install -n skaha-system  --values posix-mapper.yaml posixmapper science-platform/posixmapper
echo "Installing storage"
kubectl apply -f storage-pv-skaha.yaml
kubectl apply -f storage-pv-skaha-cavern.yaml
echo "Installing skaha"
helm upgrade --install -n skaha-system --values skaha.yaml skaha science-platform/skaha
echo "Installing scienceplatform"
helm install -n skaha-system --values scienceplatform.yaml scienceportal science-platform/scienceportal

