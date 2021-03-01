
$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "demo"

az login
az account set `
    --subscription $subscription

az group list `
    --output table

az group create `
    --name $resourceGroup `
    --location $location

# create a windows vm and access it via remote desktop with username and password

$windowsVm = "demo-windows"
$username = "notarealadmin"

az vm create `
    --resource-group $resourceGroup `
    --name $windowsVm `
    --image "win2019datacenter" `
    --admin-username $username `
    --admin-password "supersecret#2021"

az vm open-port `
    --resource-group $resourceGroup `
    --name $windowsVm `
    --port "3389"

az vm list-ip-addresses `
    --resource-group $resourceGroup `
    --name $windowsVm `
    --output table

# create a linux vm and access it via ssh with keypair

$linuxVm = "demo-linux"
$username = "notarealadmin"

az vm create `
    --resource-group $resourceGroup `
    --name $linuxVm `
    --image "UbuntuLTS" `
    --admin-username $username `
    --authentication-type "ssh" `
    --ssh-key-value "$env:HOME\.ssh\id_rsa.pub"

az vm open-port `
    --resource-group $resourceGroup `
    --name $linuxVm `
    --port "22"

az vm list-ip-addresses `
    --resource-group $resourceGroup `
    --name $linuxVm `
    --output table

az group delete `
    --name $resourceGroup
