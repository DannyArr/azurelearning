#https://docs.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps?view=azps-1.7.0

Connect-AzAccount

$sp = New-AzADServicePrincipal -DisplayName ServicePrincipalName
$enc = New-EncryptedString -SecureString $sp.Secret

$spObject = [PSCustomObject]@{
    Password = $enc
    ServicePrincipal = $sp
}

$spObject | Export-Clixml ../../config/azurelearning/sp.xml


<#  ##Removing an app and SP##

    $appId = ""
    Remove-AzADServicePrincipal -ApplicationId $appId -Force
    Remove-AzADApplication -ApplicationId $appId -Force
#>

