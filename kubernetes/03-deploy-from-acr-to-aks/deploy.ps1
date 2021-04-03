
# add access to acr to aks
$clientId = $(az aks show `
    --resource-group $resourceGroup `
    --name $cluster `
    --query "servicePrincipalProfile.clientId" `
    --output tsv)

Write-Host "ClientId: $clientId"

$acrId = $(az acr show `
    --name $registryName `
    --resource-group "rg-az-204-containers" `
    --query "id" `
    --output tsv)

Write-Host "AcrId: $acrId"

az role assignment create `
    --assignee $clientId `
    --role acrpull `
    --scope $acrId

kubectl apply -f app.yml
kubectl apply -f service.yml

kubectl get service hello-world-service --watch

kubectl delete services hello-world-service
kubectl delete deployment hello-world-deployment
