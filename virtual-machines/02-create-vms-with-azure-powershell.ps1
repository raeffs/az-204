
# https://docs.microsoft.com/en-us/powershell/module/az.compute/?view=azps-5.7.0#virtual-machines

$subscription = "Visual Studio Enterprise Subscription – MPN"
$location = "switzerlandnorth"
$resourceGroup = "rg-az-204-virtual-machines"
$id = Get-Random
$virtualMachine = "vm-$id"
$network = "vnet-$id"
$networkSecurityGroup = "nsg-$id"
$publicIp = "pip-$id"
$username = "notarealadmin"
$password = ConvertTo-SecureString "supersecure#2021" -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($username, $password)

Connect-AzAccount `
    -SubscriptionName $subscription

Set-AzContext `
    -SubscriptionName $subscription

# list all vms
Get-AzVM

# create resource group
New-AzResourceGroup `
    -Name $resourceGroup `
    -Location $location

# create a windows vm
New-AzVM `
    -ResourceGroupName $resourceGroup `
    -Name $virtualMachine `
    -Image "win2019datacenter" `
    -Credential $credentials `
    -OpenPorts 3389 `
    -VirtualNetworkName $network `
    -SecurityGroupName $networkSecurityGroup `
    -PublicIpAddressName $publicIp

# get the public ip of the vm
$ipAddress = Get-AzPublicIpAddress `
    -ResourceGroupName $resourceGroup `
    -Name $virtualMachine `
    | Select-Object IpAddress

# connect to the vm
mstsc.exe /v:$($ipAddress.IpAddress)

# stop the vm
Stop-AzVM `
    -ResourceGroupName $resourceGroup `
    -Name $virtualMachine

Remove-AzResourceGroup `
    -Name $resourceGroup

