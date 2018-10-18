$Path = '.\Bin\NVIDIA-ZEnemy\z-enemy.exe'
$Uri = 'http://nemos.dx.am/opt/nemos/z-enemy.1-22-cuda10.0_x64.zip'


$Commands = [PSCustomObject]@{
    AeriumX = ' -i 21'
    Bitcore = ' -i 21'
    bcd = ' -i 21'
    Hex = ' -i 21'
    Phi = ' -i 21'
    Phi2 = ' -i 21'
    Poly = ' -i 21'
    renesis = ' -i 21'
    X16R = ' -i 21'
    X16S = ' -i 21'
    X17 = ' -i 21'
    Tribus = ' -i 21'
    Xevan = ' -i 20'
    Sonoa = ' -i 21' #SonoA
}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {
    [PSCustomObject]@{
        Type = "NVIDIA"
        Path = $Path
        Arguments = "-b $($Variables.NVIDIAMinerAPITCPPort) -a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -u $($Pools.(Get-Algorithm($_)).User) -p $($Pools.(Get-Algorithm($_)).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Live}
        API = "Ccminer"
        Port = $Variables.NVIDIAMinerAPITCPPort
        Wrap = $false
        URI = $Uri
	User = $Pools.(Get-Algorithm($_)).User
    }
}
