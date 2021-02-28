
az vm create `
    --resource-group "demo" `
    --name "demo-linux" `
    --image "UbuntuLTS" `
    --admin-username "notarealadmin" `
    --authentication-type "ssh" `
    --ssh-key-value "$env:HOME\.ssh\id_rsa.pub"

az vm open-port `
    --resource-group "demo" `
    --name "demo-linux" `
    --port "22"

az vm list-ip-addresses `
    --resource-group "demo" `
    --name "demo-linux" `
    --output table
