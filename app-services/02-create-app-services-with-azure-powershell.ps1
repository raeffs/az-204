
# https://docs.microsoft.com/en-us/powershell/module/az.websites/?view=azps-5.7.0#app-service

$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "rg-az-204-app-services"
$id = Get-Random
$appServicePlan = "plan-$id"
$appService = "app-$id"

Connect-AzAccount `
    -SubscriptionName $subscription

Set-AzContext `
    -SubscriptionName $subscription

New-AzResourceGroup `
    -Name $resourceGroup `
    -Location $location

# list all app service plans
Get-AzAppServicePlan

# list all app services
Get-AzWebApp

# create app service plan
New-AzAppServicePlan `
    -ResourceGroupName $resourceGroup `
    -Name $appServicePlan `
    -Location $location `
    -Tier "S1"

# create app service
New-AzWebApp `
    -ResourceGroupName $resourceGroup `
    -AppServicePlan $appServicePlan `
    -Name $appService

Remove-AzResourceGroup `
    -Name $resourceGroup
