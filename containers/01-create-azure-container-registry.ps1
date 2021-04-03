
# https://docs.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest

$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "rg-az-204-containers"
$id = Get-Random
$registryName = "cr$id"

az login
az account set `
    --subscription $subscription

az group create `
    --name $resourceGroup `
    --location $location

# create azure container registry
az acr create `
    --resource-group $resourceGroup `
    --name $registryName `
    --sku "Standard"

# login to the registry
az acr login `
    --name $registryName

$registryId = $(az acr show --name $registryName --query id --output tsv)
$loginServer = $(az acr show --name $registryName --query loginServer --output tsv)

Write-Host "RegistryId: $registryId"
Write-Host "LoginServer: $loginServer"

az group delete `
    --name $resourceGroup
