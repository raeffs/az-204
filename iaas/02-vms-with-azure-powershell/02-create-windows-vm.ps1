
$username = "notarealadmin"
$password = ConvertTo-SecureString "supersecure#2021" -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential ($username, $password)

New-AzVM `
    -ResourceGroupName "demo" `
    -Name "demo-win" `
    -Image "win2019datacenter" `
    -Credential $credentials `
    -OpenPorts 3389

Get-AzPublicIpAddress `
    -ResourceGroupName "demo" `
    -Name "demo-win" `
    | Select-Object IpAddress

