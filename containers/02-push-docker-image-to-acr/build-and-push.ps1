
$image = "hello-world"
$tag = "latest"

# build the docker image locally
docker build -t "$loginServer/$($image):$($tag)" .

# push docker image to registry
docker push $loginServer/$($image):$($tag)

# list all images
az acr repository list `
    --name $registryName `
    --output table

# list all tags of an image
az acr repository show-tags `
    --name $registryName `
    --repository $image `
    --output table
