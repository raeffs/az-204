
$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "demo"

Connect-AzAccount `
    -SubscriptionName $subscription

Set-AzContext `
    -SubscriptionName $subscription

New-AzResourceGroup `
    -Name $resourceGroup `
    -Location $location

# create a windows vm and access it via remote desktop with username and password

$windowsVm = "demo-windows"
$username = "notarealadmin"
$password = ConvertTo-SecureString "supersecure#2021" -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($username, $password)

New-AzVM `
    -ResourceGroupName $resourceGroup `
    -Name $windowsVm `
    -Image "win2019datacenter" `
    -Credential $credentials `
    -OpenPorts 3389

Get-AzPublicIpAddress `
    -ResourceGroupName $resourceGroup `
    -Name $windowsVm `
    | Select-Object IpAddress

Remove-AzResourceGroup `
    -Name $resourceGroup

