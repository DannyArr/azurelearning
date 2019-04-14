. ./Get-DecryptedString.ps1

$path = "../../config/azurelearning/sp.xml"

$spRetrieved = Import-Clixml $path
$sstring = Get-DecryptedString -EncryptedString $spRetrieved.Password
$sp = $spRetrieved.ServicePrincipal

$cred = [PSCredential]::new($sp.ApplicationId,$sstring)

Connect-AzAccount -ServicePrincipal `
    -Credential $cred `
    -Tenant $spRetrieved.TenantId `
    -Subscription $spRetrieved.SubscriptionId
