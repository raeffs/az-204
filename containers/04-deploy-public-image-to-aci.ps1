
$publicContainerName = "ci-public-$id"

# deploy a public docker container
az container create `
    --resource-group $resourceGroup `
    --name $publicContainerName `
    --dns-name-label $publicContainerName `
    --image "mcr.microsoft.com/azuredocs/aci-helloworld" `
    --ports 80

az container show `
    --resource-group $resourceGroup `
    --name $publicContainerName

# get the url of the container instance
$url = $(az container show `
    --resource-group $resourceGroup `
    --name $publicContainerName `
    --query "ipAddress.fqdn").Trim('"')

Write-Host "URL: $url"

az container delete `
    --resource-group $resourceGroup `
    --name $publicContainerName
