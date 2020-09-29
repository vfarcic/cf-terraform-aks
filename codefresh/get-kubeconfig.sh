set -e

terraform init

export CLUSTER_NAME=$(terraform output cluster_name)

export RESOURCE_GROUP=$(terraform output resource_group)

az aks get-credentials \
  --name $CLUSTER_NAME \
  --resource-group $RESOURCE_GROUP \
  --file kubeconfig.yaml \
  --overwrite-existing

export KUBECONFIG=$PWD/kubeconfig.yaml

kubectl apply --filename codefresh/create-cluster.yaml

export CURRENT_CONTEXT=$(kubectl config current-context)

set +e

codefresh delete cluster $CURRENT_CONTEXT

set -e

codefresh create cluster \
    --kube-context $CURRENT_CONTEXT \
    --serviceaccount codefresh \
    --namespace codefresh

echo "Execute the following command to use the newly created Kube config:"
echo
echo "export KUBECONFIG=$PWD/kubeconfig.yaml"

