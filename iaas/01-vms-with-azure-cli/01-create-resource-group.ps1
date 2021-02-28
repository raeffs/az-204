
az login
az account set `
    --subscription "Visual Studio Enterprise Subscription – MPN"

az group list `
    --output table

az group create `
    --name "demo" `
    --location "switzerlandnorth"
