$version = "0.11.13"

[array]$urls = @(
    [PSCustomObject]@{
        Name = "TerraformUrl"
        Url = "https://releases.hashicorp.com/terraform/$($version)/terraform_$($version)_windows_amd64.zip"
    },
    [PSCustomObject]@{
        Name = "ChecksumUrl"
        Url = "https://releases.hashicorp.com/terraform/$($version)/terraform_$($version)_SHA256SUMS"
    }
)


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$dir = "C:\MyPrograms\Hashicorp\Terraform"
if(!(Test-Path $dir)) {
    New-Item -ItemType Directory -Path $dir
}


foreach($urlDetail in $urls){

    $uri = $urlDetail.url

    $fileName = $uri.split("/")[-1]
    $urlDetail | Add-Member -MemberType NoteProperty -Name "FileName" -Value $fileName

    $outFile = Join-Path $dir $fileName
    Write-Output "Downloading $fileName to $outFile"
    $start_time = Get-Date
    Invoke-WebRequest -Uri $uri -OutFile $outFile
    Write-Output "Download took: $((Get-Date).Subtract($start_time).Seconds) second(s)"
}

$checksumFileName = ($urls | Where-Object Name -eq ChecksumUrl).FileName
$terraformFileName = ($urls | Where-Object Name -eq TerraformUrl).FileName
$checksumFile = Join-Path $dir $checksumFileName
$terraformFile = Join-Path $dir $terraformFileName
$checksumContent = Get-Content $checksumFile

[string]$string = $checksumContent | Select-String -Pattern $terraformFileName
$checksum = $string.Split(" ")[0]

$fileHashInfo = Get-FileHash -Path $terraformFile -Algorithm "SHA256"

if($fileHashInfo.Hash -ne $checksum){
    throw "Checksum match failure. Check your download file"
}
else{
    Write-Output "Checksum matches."
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($terraformFile, $dir)
}

$envTarget = [System.EnvironmentVariableTarget]::User
$currentPathVar = [System.Environment]::GetEnvironmentVariable("Path",$envTarget)

if(!($currentPathVar | Select-String -SimpleMatch $dir)){

    Write-Output "Updating user's environment variable"
    $newPathVar = "$currentPathVar;$dir"
    [System.Environment]::SetEnvironmentVariable("Path",$newPathVar,$envTarget)
    $Env:Path = $Env:Path + ";$dir"

}

if(!(Test-Path $profile)){
    New-Item -Path $profile
}

$aliasCmd = "Set-Alias tf terraform"

$profileContent = Get-Content $profile

if(!($profileContent | Select-String -Pattern $aliasCmd)){
    Add-Content -Path $profile -Value $aliasCmd
}



Remove-Item $terraformFile
Remove-Item $checksumFile

Write-Output "Terraform installed (Desired version = $version)"

Terraform --version
