
$registryName = "somedemoregistry"
az acr create `
    --resource-group "demo" `
    --name $registryName `
    --sku "Standard"

az acr login `
    --name $registryName

$loginServer = $(az acr show --name $registryName --query loginServer --output tsv)

Write-Host $loginServer
