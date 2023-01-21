
$resourceGroupName = "rg-app-services"
$appServiceName = "app-$id"

az webapp log show --name $appServiceName --resource-group $resourceGroupName

az webapp log config --application-logging "filesystem" --level "information" --name $appServiceName --resource-group $resourceGroupName

az webapp log tail --name $appServiceName --resource-group $resourceGroupName

az webapp deployment user set --user-name <name-of-user-to create> --password <new-password>
curl -u {username} https://{sitename}.scm.azurewebsites.net/api/logstream

az webapp log download --log-file \<_filename_\>.zip  --resource-group \<_resource group name_\> --name \<_app name_\>

az webapp log config --application-logging "off" --name $appServiceName --resource-group $resourceGroupName
