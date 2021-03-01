
$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "demo"

az login
az account set `
    --subscription $subscription

az group create `
    --name $resourceGroup `
    --location $location

# create azure container registry

$registryName = "somedemoregistry"

az acr create `
    --resource-group $resourceGroup `
    --name $registryName `
    --sku "Standard"

az acr login `
    --name $registryName

$registryId = $(az acr show --name $registryName --query id --output tsv)
$loginServer = $(az acr show --name $registryName --query loginServer --output tsv)

Write-Host $registryId
Write-Host $loginServer

# build & tag docker image ...

# push docker image to registry

docker push $loginServer/myimage:latest

az acr repository list `
    --name $registryName `
    --output table

az acr repository show-tags `
    --name $registryName `
    --repository "myimage" `
    --output table

# build docker image on azure container registry

az acr build `
    --image "myimage:latest" `
    --registry $registryName

# deploy a public docker container

$publicContainerName = "public-demo-$(Get-Random)"

az container create `
    --resource-group $resourceGroup `
    --name $publicContainerName `
    --dns-name-label $publicContainerName `
    --image "mcr.microsoft.com/azuredocs/aci-helloworld" `
    --ports 80

az container show `
    --resource-group $resourceGroup `
    --name $publicContainerName

$url = $(az container show `
    --resource-group $resourceGroup `
    --name $publicContainerName `
    --query "ipAddress.fqdn").Trim('"')

Write-Host $url

az container delete `
    --resource-group $resourceGroup `
    --name $publicContainerName

# deploy a private docker container with service principal

$privateContainerName = "private-demo-$(Get-Random)"

$appPassword = $(az ad sp create-for-rbac `
    --name "http://$registryName-pull" `
    --scopes $registryId `
    --role "acrpull" `
    --query "password" `
    --output tsv)

$appId = $(az ad sp show `
    --id "http://$registryName-pull" `
    --query "appId" `
    --output tsv)

Write-Host $appId
Write-Host $appPassword

az container create `
    --resource-group $resourceGroup `
    --name $privateContainerName `
    --dns-name-label $privateContainerName `
    --image "$loginServer/myimage:latest" `
    --ports 80 `
    --registry-login-server $loginServer `
    --registry-username $appId `
    --registry-password $appPassword

az container show `
    --resource-group $resourceGroup `
    --name $privateContainerName

$url = $(az container show `
    --resource-group $resourceGroup `
    --name $privateContainerName `
    --query "ipAddress.fqdn").Trim('"')

Write-Host $url

az container logs `
    --resource-group $resourceGroup `
    --name $privateContainerName

az group delete `
    --name $resourceGroup
