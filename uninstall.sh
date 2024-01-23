helm uninstall base
helm uninstall posixmapper
helm uninstall skaha
echo "No skaha-system pods installed ..."
kubectl get all -n skaha-system

