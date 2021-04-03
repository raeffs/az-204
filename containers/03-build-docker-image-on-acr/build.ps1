
$image = "hello-world-on-acr"
$tag = "latest"

# build docker image on azure container registry
az acr build `
    --image "$loginServer/$($image):$($tag)" `
    --registry $registryName `
    .
