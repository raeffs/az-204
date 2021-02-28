
$registryId = $(az acr show --name $registryName --query id --output tsv)
$loginServer = $(az acr show --name $registryName --query loginServer --output tsv)

Write-Host $registryId
Write-Host $loginServer

$servicePrincipalPassword = $(az ad sp create-for-rbac `
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
Write-Host $servicePrincipalPassword

az container create `
    --resource-group "demo" `
    --name "my-private-demo-container" `
    --dns-name-label "my-private-demo-container" `
    --image "$loginServer/myimage:latest" `
    --ports 80 `
    --registry-login-server $loginServer `
    --registry-username $appId `
    --registry-password $servicePrincipalPassword

az container show `
    --resource-group "demo" `
    --name "my-private-demo-container"

$url = $(az container show `
    --resource-group "demo" `
    --name "my-private-demo-container" `
    --query "ipAddress.fqdn").Trim('"')

Write-Host $url

az container logs `
    --resource-group "demo" `
    --name "my-private-demo-container" 
