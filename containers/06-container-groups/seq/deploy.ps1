
# https://docs.microsoft.com/en-us/azure/container-instances/container-instances-reference-yaml

$subscription = "Visual Studio Enterprise Subscription"
$location = "switzerlandnorth"
$resourceGroupName = "rg-az-204-containers"
$id = Get-Random
$storageAccountName = "st$id"
$seqFileShareName = "seq-data"
$caddyFileShareName = "caddy-data"
$dnsNameLabel = "containerized-seq-$id"

az login
az account set `
  --subscription $subscription

az group create `
  --name $resourceGroupName `
  --location $location

# Create a Storage Account for persistent Storage
az storage account create `
  --resource-group $resourceGroupName `
  --name $storageAccountName `
  --location $location `
  --sku Standard_LRS

# Create File Shares for Seq and Caddy
az storage share create `
  --name $seqFileShareName `
  --account-name $storageAccountName

az storage share create `
  --name $caddyFileShareName `
  --account-name $storageAccountName

$storageAccountKey = az storage account keys list `
  --resource-group $resourceGroupName `
  --account-name $storageAccountName `
  --query "[0].value" `
  --output tsv

Get-Content deployment.template.yml |
  ForEach-Object { $_ -replace "PLACEHOLDER_LOCATION", $location } |
  ForEach-Object { $_ -replace "PLACEHOLDER_FCDN", "$dnsNameLabel.$location.azurecontainer.io" } |
  ForEach-Object { $_ -replace "PLACEHOLDER_DNS_NAME_LABEL", $dnsNameLabel } |
  ForEach-Object { $_ -replace "PLACEHOLDER_CADDY_SHARE_NAME", $caddyFileShareName } |
  ForEach-Object { $_ -replace "PLACEHOLDER_SEQ_SHARE_NAME", $seqFileShareName } |
  ForEach-Object { $_ -replace "PLACEHOLDER_STORAGE_ACCOUNT_NAME", $storageAccountName } |
  ForEach-Object { $_ -replace "PLACEHOLDER_STORAGE_ACCOUNT_KEY", $storageAccountKey } |
  Out-File deployment.yml

# Create the Container Group
az container create `
  --resource-group $resourceGroupName `
  --file deployment.yml

az group delete `
  --name $resourceGroupName
