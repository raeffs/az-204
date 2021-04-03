
# https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest

$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "rg-az-204-kubernetes"
$id = Get-Random
$cluster = "aks-$id"

az login
az account set `
    --subscription $subscription

az group create `
    --name $resourceGroup `
    --location $location

# create kubernetes cluster
az aks create `
    --resource-group $resourceGroup `
    --name $cluster `
    --node-count 3 `
    --enable-addons monitoring `
    --generate-ssh-keys

# install kubectl
az aks install-cli `
    --install-location "./kubectl"

az aks get-credentials `
    --resource-group $resourceGroup `
    --name $cluster

# get nodes
kubectl get nodes

az group delete `
    --name $resourceGroup
