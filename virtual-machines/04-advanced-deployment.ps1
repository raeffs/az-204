
$subscription = "Visual Studio Enterprise Subscription"
$location = "switzerlandnorth"

$dnsName = "raeffs-dev-on-azure"
$networkId = Get-Random
$id = Get-Random
$vmImage = "MicrosoftWindowsServer:WindowsServer:2019-Datacenter-smalldisk:latest"
$vmSize = "Standard_D2s_v4"
$username = "notarealadmin"
$password = "supersecret#2021"

$networkResourceGroupName = "rg-$networkId"
$networkSecurityGroupName = "nsg-$networkId"
$virtualNetworkName = "vnet-$networkId"
$virtualSubnetName = "snet-$networkId"

$resourceGroupName = "rg-$id"
$publicIpAddressName = "pip-$id"
$networkInterfaceName = "nic-$id"
$vmName = "vm-$id"
$osDiskName = "osdisk-$id"

az login
az account set `
    --subscription $subscription

az group create `
    --name $networkResourceGroupName `
    --location $location

az group create `
    --name $resourceGroupName `
    --location $location

# create network security group
az network nsg create `
    --name $networkSecurityGroupName `
    --resource-group $networkResourceGroupName

# create virtual network
az network vnet create `
    --name $virtualNetworkName `
    --resource-group $networkResourceGroupName `
    --location $location `
    --address-prefix 10.1.0.0/16 `
    --network-security-group $networkSecurityGroupName

az network vnet subnet create `
    --name $virtualSubnetName `
    --resource-group $networkResourceGroupName `
    --vnet-name $virtualNetworkName `
    --address-prefix 10.1.0.0/24 `
    --network-security-group $networkSecurityGroupName

$virtualSubnetId = az network vnet subnet show `
    --name $virtualSubnetName `
    --vnet-name $virtualNetworkName `
    --resource-group $networkResourceGroupName `
    --query "id" `
    --output tsv

# create public ip address for virtual machine
az network public-ip create `
    --name $publicIpAddressName `
    --resource-group $resourceGroupName `
    --allocation-method Dynamic `
    --dns-name $dnsName

# create network interface for virtual machine
az network nic create `
    --name $networkInterfaceName `
    --resource-group $resourceGroupName `
    --subnet $virtualSubnetId `
    --public-ip-address $publicIpAddressName

# create a virtual machine
az vm create `
    --name $vmName `
    --resource-group $resourceGroupName `
    --admin-username $username `
    --admin-password $password `
    --assign-identity [system] `
    --image $vmImage `
    --nics $networkInterfaceName `
    --nsg-rule NONE `
    --os-disk-name $osDiskName `
    --os-disk-size 64 `
    --size $vmSize

# attach a data disk
az vm disk attach `
    --name "disk-$id" `
    --resource-group $resourceGroupName `
    --vm-name $vmName `
    --caching ReadWrite `
    --size-gb 64 `
    --sku Premium_LRS `
    --new
