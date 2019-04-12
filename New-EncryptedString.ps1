function New-EncryptedString {
    param(
        [parameter(mandatory=$true,ParameterSetName="plaintext")]
        [string]$String,

        [parameter(mandatory=$true,ParameterSetName="securestring")]
        [securestring]$SecureString,

        [string]$KeyPath = '/home/danny/keys/dansazure_aes.key'
    )

    $key = Get-Content $keyPath

    if($PSCmdlet.ParameterSetName -eq "plaintext") {
        $SecureString = ConvertTo-SecureString $String -AsPlainText -Force
    }    
    
    $enc = ConvertFrom-SecureString -SecureString $secureString -Key $key

    return $enc
}
