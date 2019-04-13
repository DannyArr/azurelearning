#https://docs.microsoft.com/en-us/powershell/azure/create-azure-service-principal-azureps?view=azps-1.7.0

Connect-AzAccount

$sp = New-AzADServicePrincipal -DisplayName "MainSP"
$enc = New-EncryptedString -SecureString $sp.Secret

$context = Get-AzContext

$spObject = [PSCustomObject]@{
    Password = $enc
    ServicePrincipal = $sp
    SubscriptionId = $context.Subscription.Id
    TenantId = $context.Tenant.Id
    ServicePrincipalId = $sp.Id
}

$path = "../../config/azurelearning/sp.xml"
$spObject | Export-Clixml $path -Force

New-AzRoleAssignment -ServicePrincipalName $sp.ApplicationId `
    -RoleDefinitionName "Contributor"

$spRetrieved = Import-Clixml $path
$sstring = Get-DecryptedString -EncryptedString $spRetrieved.Password




<#  ##Removing an app and SP##

    $appId = ""
    Remove-AzADServicePrincipal -ApplicationId $appId -Force
    Remove-AzADApplication -ApplicationId $appId -Force
#>


$cred = [PSCredential]::new($sp.ApplicationId,$sstring)

Connect-AzAccount -ServicePrincipal `
    -Credential $cred `
    -Tenant $context.Tenant.Id `
    -Subscription $context.Subscription.Id

    