Connect-AzAccount `
    -SubscriptionName "Visual Studio Enterprise Subscription – MPN"

Set-AzContext `
    -SubscriptionName "Visual Studio Enterprise Subscription – MPN"

New-AzResourceGroup `
    -Name "demo" `
    -Location "switzerlandnorth"
