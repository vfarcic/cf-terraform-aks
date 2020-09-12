if [ "$1" == "" ]; then
  echo "Usage: $0 [CLUSTER_NAME] [RESOURCE_GROUP]"
  exit
fi

az aks get-credentials \
  --name $1 \
  --resource-group $2 \
  --file kubeconfig.yaml \
  --overwrite-existing

echo "Execute the following command to use the newly created Kube config:"
echo
echo "export KUBECONFIG=kubeconfig.yaml"

