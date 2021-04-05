
# https://docs.microsoft.com/en-us/cli/azure/storage?view=azure-cli-latest

$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "rg-az-204-storage-accounts"
$id = Get-Random
$accountName = "st$id"
$containerName = "stcontainer-$id"
$fileName = "hello-world.txt"

az login
az account set `
    --subscription $subscription

az group create `
    --name $resourceGroup `
    --location $location

# create storage account
az storage account create `
    --resource-group $resourceGroup `
    --name $accountName `
    --location $location `
    --sku Standard_LRS

# create blob container
az storage container create `
    --account-name $accountName `
    --name $containerName

# upload a file
az storage blob upload `
    --account-name $accountName `
    --container-name $containerName `
    --name $fileName `
    --file $fileName

# allow anonymous access
az storage container set-permission `
    --account-name $accountName `
    --name $containerName `
    --public-access blob

# list files
az storage blob list `
    --account-name $accountName `
    --container-name $containerName `
    --output table

# download a file
az storage blob download `
    --account-name $accountName `
    --container-name $containerName `
    --name $fileName `
    --file "downloaded-$fileName"

az group delete `
    --name $resourceGroup
