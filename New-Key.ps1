$key = [System.Byte[]]::new(32)
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
$Key | out-file /home/danny/keys/dansazure_aes.key