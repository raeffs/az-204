
# build & tag image ...

docker push $loginServer/myimage:latest

az acr repository list `
    --name $registryName `
    --output table

az acr repository show-tags `
    --name $registryName `
    --repository "myimage" `
    --output table
