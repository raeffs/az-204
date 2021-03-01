
$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "demo"
$appServicePlan = "demo-plan"
$appService = "demo-app-$(Get-Random)"

az login
az account set `
    --subscription $subscription

az group create `
    --name $resourceGroup `
    --location $location

az appservice plan create `
    --resource-group $resourceGroup `
    --name $appServicePlan `
    --sku "s1" `
    --is-linux

az webapp create `
    --resource-group $resourceGroup `
    --plan $appServicePlan `
    --name $appService `
    --runtime "node:10.14"

az group delete `
    --name $resourceGroup
