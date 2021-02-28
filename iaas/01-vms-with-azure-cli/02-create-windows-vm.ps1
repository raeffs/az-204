
az vm create `
    --resource-group "demo" `
    --name "demo-win" `
    --image "win2019datacenter" `
    --admin-username "notarealadmin" `
    --admin-password "supersecret#2021"

az vm open-port `
    --resource-group "demo" `
    --name "demo-win" `
    --port "3389"

az vm list-ip-addresses `
    --resource-group "demo" `
    --name "demo-win" `
    --output table
