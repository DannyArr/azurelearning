function Get-DecryptedString {
    param(
        [parameter(mandatory=$true)]
        [string]$EncryptedString,

        [string]$KeyPath = '/home/danny/keys/dansazure_aes.key',

        [switch]$AsPlainText
    )

    $key = Get-Content $KeyPath

    $secureString = ConvertTo-SecureString $EncryptedString -Key $key

    if($AsPlainText){
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
        $plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)

        return $plainPassword
    }
    else{
        return $secureString
    }

}


