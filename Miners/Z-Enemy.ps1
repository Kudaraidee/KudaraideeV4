$Path = '.\Bin\NVIDIA-ZEnemy\z-enemy.exe'
$Uri = 'http://nemos.dx.am/opt/nemos/z-enemy.1-11-public-final_v3.7z'


$Commands = [PSCustomObject]@{
    Bitcore = ' -i 20'
    Phi = ' -i 20'
    X16R = ' -i 20'
    X16S = ' -i 20'
    X17 = ' -i 20'
    Tribus = ' -i 20'
    Aergo = ' -i 20'
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = 4068
        Wrap = $false
        URI = $Uri
		User = $Pools.(Get-Algorithm($_)).User
    }
}
