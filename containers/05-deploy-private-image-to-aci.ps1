
$privateContainerName = "ci-private-$id"

# create service principal
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

Write-Host "AppId: $appId"
Write-Host "AppPassword: $appPassword"

# deploy a private docker container with service principal
az container create `
    --resource-group $resourceGroup `
    --name $privateContainerName `
    --dns-name-label $privateContainerName `
    --image "$loginServer/$($image):$($tag)" `
    --ports 80 `
    --registry-login-server $loginServer `
    --registry-username $appId `
    --registry-password $appPassword

az container show `
    --resource-group $resourceGroup `
    --name $privateContainerName

# get the url of the container instance
$url = $(az container show `
    --resource-group $resourceGroup `
    --name $privateContainerName `
    --query "ipAddress.fqdn").Trim('"')

Write-Host "URL: $url"

# read the logs from the container instance
az container logs `
    --resource-group $resourceGroup `
    --name $privateContainerName
