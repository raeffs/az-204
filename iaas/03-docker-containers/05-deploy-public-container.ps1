
az container create `
    --resource-group "demo" `
    --name "my-public-demo-container" `
    --dns-name-label "my-public-demo-container" `
    --image "mcr.microsoft.com/azuredocs/aci-helloworld" `
    --ports 80

az container show `
    --resource-group "demo" `
    --name "my-public-demo-container"

$url = $(az container show `
    --resource-group "demo" `
    --name "my-public-demo-container" `
    --query "ipAddress.fqdn").Trim('"')

Write-Host $url

az container delete `
    --resource-group "demo" `
    --name "my-public-demo-container"
