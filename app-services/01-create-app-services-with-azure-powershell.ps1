
$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "demo"
$appServicePlan = "demo-plan"
$appService = "demo-app-$(Get-Random)"

Connect-AzAccount `
    -SubscriptionName $subscription

Set-AzContext `
    -SubscriptionName $subscription

New-AzResourceGroup `
    -Name $resourceGroup `
    -Location $location

New-AzAppServicePlan `
    -ResourceGroupName $resourceGroup `
    -Name $appServicePlan `
    -Location $location `
    -Tier "S1"

New-AzWebApp `
    -ResourceGroupName $resourceGroup `
    -AppServicePlan $appServicePlan `
    -Name $appService 

Remove-AzResourceGroup `
    -Name $resourceGroup
