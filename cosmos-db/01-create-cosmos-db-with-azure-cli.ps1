
$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "demo"

$accountName = "demo-cosmosdb-$(Get-Random)"
$dbName = "demo-cosmosdb"
$containerName = "demo-cosmosdb-container"

az login
az account set `
    --subscription $subscription

az group create `
    --name $resourceGroup `
    --location $location

# create a sql api cosmos db account
az cosmosdb create `
    --name $accountName `
    --resource-group $resourceGroup

# create a sql database
az cosmosdb sql database create `
    --name $dbName `
    --account-name $accountName `
    --resource-group $resourceGroup

# create a sql database container
az cosmosdb sql container create `
    --name $containerName `
    --database-name $dbName `
    --account-name $accountName `
    --resource-group $resourceGroup `
    --partition-key-path "/id"

# cleanup
az group delete `
    --name $resourceGroup
