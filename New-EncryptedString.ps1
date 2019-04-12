function New-EncryptedString {
    param(
        [parameter(mandatory=$true)]
        [string]$String,

        [string]$KeyPath = '/home/danny/keys/dansazure_aes.key'
    )

    $key = Get-Content $keyPath

    $secureString = ConvertTo-SecureString $String -AsPlainText -Force
    $enc = ConvertFrom-SecureString -SecureString $secureString -Key $key

    return $enc
}
