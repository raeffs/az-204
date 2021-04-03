
# https://docs.microsoft.com/en-us/cli/azure/vm?view=azure-cli-latest

$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "rg-az-204-virtual-machines"
$id = Get-Random
$windowsVm = "vm-windows-$id"
$linuxVm = "vm-linux-$id"
$username = "notarealadmin"

az login
az account set `
    --subscription $subscription

az group list `
    --output table

az group create `
    --name $resourceGroup `
    --location $location

# list available images
az vm image list

# create a windows vm
az vm create `
    --resource-group $resourceGroup `
    --name $windowsVm `
    --image "win2019datacenter" `
    --admin-username $username `
    --admin-password "supersecret#2021"

# open rdp port
az vm open-port `
    --resource-group $resourceGroup `
    --name $windowsVm `
    --port "3389"

# get the public ip
az vm list-ip-addresses `
    --resource-group $resourceGroup `
    --name $windowsVm `
    --output table

# create a linux vm
az vm create `
    --resource-group $resourceGroup `
    --name $linuxVm `
    --image "UbuntuLTS" `
    --admin-username $username `
    --authentication-type "ssh" `
    --ssh-key-value "$env:HOME\.ssh\id_rsa.pub"

# open ssh port
az vm open-port `
    --resource-group $resourceGroup `
    --name $linuxVm `
    --port "22"

# get the public ip
az vm list-ip-addresses `
    --resource-group $resourceGroup `
    --name $linuxVm `
    --output table

az group delete `
    --name $resourceGroup
