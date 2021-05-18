
# https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest
# https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations

$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroupName = "rg-az-204-kubernetes"
$id = "advanced"
$clusterName = "aks-$id"
$virtualNetworkName = "vnet-$id"
$virtualSubnetName = "snet-$id"

# login
az login
az account set `
    --subscription $subscription

# create resource group -> primary resource group
# there is another one created by Azure that contains all the automatically created resources
az group create `
    --name $resourceGroupName `
    --location $location

# create virtual networks
az network vnet create `
    --name $virtualNetworkName `
    --resource-group $resourceGroupName `
    --location $location `
    --address-prefix 10.0.0.0/8

az network vnet subnet create `
    --name $virtualSubnetName `
    --resource-group $resourceGroupName `
    --vnet-name $virtualNetworkName `
    --address-prefix 10.0.0.0/16

$virtualSubnetId = az network vnet subnet show `
    --name $virtualSubnetName `
    --vnet-name $virtualNetworkName `
    --resource-group $resourceGroupName `
    --query "id" `
    --output tsv

# create kubernetes cluster
# enable cluster autoscaling
# specify node type and size
# use virtual machine scale set
# use azure networking and assign subnet
az aks create `
    --name $clusterName `
    --location $location `
    --resource-group $resourceGroupName `
    --generate-ssh-keys `
    --enable-cluster-autoscaler `
    --min-count 2 `
    --max-count 10 `
    --max-pods 110 `
    --node-vm-size Standard_DS2_v2 `
    --node-osdisk-size 40 `
    --vm-set-type VirtualMachineScaleSets `
    --network-plugin azure `
    --load-balancer-sku standard `
    --vnet-subnet-id $virtualSubnetId `
    --service-cidr 10.2.0.0/16 `
    --dns-service-ip 10.2.0.10 `
    --dns-name-prefix $clusterName `
    --docker-bridge-address 172.17.0.1/16 `
    --enable-managed-identity

# configure managed identities
# ...

# install kubectl and authenticate
az aks install-cli

az aks get-credentials `
    --name $clusterName `
    --resource-group $resourceGroupName

# get nodes / pods / ...
kubectl get nodes
kubectl get pods

# deploy apps
kubectl apply -f 04-advanced-deployment/whoami/deployment.yml
kubectl apply -f 04-advanced-deployment/whoami/service.yml

# cleanup everything
az group delete `
    --name $resourceGroup
