. ./New-EncryptedString.ps1
. ./Get-DecryptedString.ps1

$enc = New-EncryptedString -String "TestPassword"
$enc

$sstring = Get-DecryptedString -EncryptedString $enc
$sstring

$string = Get-DecryptedString -EncryptedString $enc -AsPlainText
$string

$path = "../../config/azurelearning/sp.xml"
Test-Path $path
$sp = Import-Clixml $path
$sp | fl
$sp.ServicePrincipal