. ./New-EncryptedString.ps1
. ./Get-DecryptedString.ps1

$enc = New-EncryptedString -String "TestPassword"
$enc

$string = Get-DecryptedString -EncryptedString $enc
$string
