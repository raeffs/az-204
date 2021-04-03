
# https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest

$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "rg-az-204-app-services"
$id = Get-Random
$appServicePlan = "plan-$id"
$appService = "app-$id"

az login
az account set `
    --subscription $subscription

az group create `
    --name $resourceGroup `
    --location $location

# create app service plan
az appservice plan create `
    --resource-group $resourceGroup `
    --name $appServicePlan `
    --sku "s1" `
    --is-linux

# create app service
az webapp create `
    --resource-group $resourceGroup `
    --plan $appServicePlan `
    --name $appService `
    --runtime "node:10.14"

az group delete `
    --name $resourceGroup
